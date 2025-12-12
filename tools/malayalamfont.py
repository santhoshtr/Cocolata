import logging
import os
import re
from datetime import datetime
from typing import List

from fontTools import agl
from svgglyph import SVGGlyph
from glyphnames import get_glyph_name
from ufoLib2.objects import Component, Font, Glyph, Guideline
from ufoLib2.objects.info import GaspRangeRecord
from jinja2 import Environment, FileSystemLoader

log = logging.getLogger(__name__)

LANGUAGE_ALL = [("DFLT", "dflt"), ("latn", "dflt"), ("mlm2", "dflt")]
LANGUAGE_MALAYALAM = [("mlm2", "dflt")]
LANGUAGE_LATIN = [("DFLT", "dflt"), ("latn", "dflt")]


class MalayalamFont(Font):
    def __init__(self, options, style="", weight=400):
        Font.__init__(self)
        self.options = options
        self.style = style
        self.weight = weight
        self.available_svgs = []
        self.salts = {}  # Stylistic Alternates
        self.onums = {}  # Old Numerals
        self.sups = {}  # Superscripts
        logging.basicConfig(level="WARN")

    def get_glyphs_from_named_classes(self, *argv):
        all_glyphs = []
        for class_name in argv:
            if class_name in self.options.glyphs.classes:
                glyphs = self.options.glyphs.classes[class_name]
            elif class_name in self.options.glyphs.kern.classes:
                glyphs = self.options.glyphs.kern.classes[class_name]
            if isinstance(glyphs, list):
                all_glyphs = all_glyphs + glyphs
            else:
                all_glyphs = all_glyphs + list(glyphs)
        return all_glyphs

    def get_glyph_names_from_named_classes(self, class_name):
        all_glyphs = self.get_glyphs_from_named_classes(class_name)
        return [get_glyph_name(letter) for letter in all_glyphs]

    def build(self, design_dir):
        empty_glyphs = {
            ".null": 0,
            # "nonmarkingreturn": 0,
            "uni00A0": 0x00A0,  # NBSP
            # See https://typedrawers.com/discussion/2046/special-dash-things-softhyphen-horizontalbar
            # "uni00AD": 0x00AD,  # Soft hyphen
            "zwnj": 0x200C,
            "zwj": 0x200D,
        }
        for g, u in empty_glyphs.items():
            glyph = Glyph(name=g)
            if u != 0:
                glyph.unicodes = [u]
            self.addGlyph(glyph)

        for f in sorted(os.listdir(design_dir)):
            if not f.endswith(".svg"):
                continue
            svg_glyph = SVGGlyph(os.path.join(design_dir, f))
            svg_glyph.parse()
            log.debug(f"{f} -> {svg_glyph.glyph_name}")
            self.addGlyph(svg_glyph.glif)
            if svg_glyph.alt:
                if svg_glyph.glyph_name not in self.salts:
                    self.salts[svg_glyph.glyph_name] = []

                self.salts[svg_glyph.glyph_name].append(svg_glyph.glif.name)
            if svg_glyph.onum:
                if svg_glyph.glyph_name not in self.onums:
                    self.onums[svg_glyph.glyph_name] = []

                self.onums[svg_glyph.glyph_name].append(svg_glyph.glif.name)
            if svg_glyph.sups:
                if svg_glyph.glyph_name not in self.sups:
                    self.sups[svg_glyph.glyph_name] = []

                self.sups[svg_glyph.glyph_name].append(svg_glyph.glif.name)
        # Even though we can flip the glyphs using transformation,
        # it is always better to design a glyph for that.
        # Flipping here won't work nicely with slanting for example.
        horizontally_flippables = {
            # '<': '>',
            # '«': '»',
            # '/': '\\',
            # '[': ']',
            # '{': '}',
            # '(': ')',
            # '‹': '›',
            # '„': '⹂'
        }
        for b, c in horizontally_flippables.items():
            compositename = get_glyph_name(c)
            basename = get_glyph_name(b)
            if basename not in self:
                log.warn(f"{basename} glyph not found for horizontal flipping")
                continue
            self.newGlyph(compositename)
            composite: Glyph = self[compositename]
            composite.unicodes = [ord(c)]
            component: Component = Component()
            component.baseGlyph = basename
            baseGlyph = self[basename]
            composite.width = baseGlyph.width
            # transformation = (xScale, xyScale, yxScale, yScale, xOffset, yOffset)
            component.transformation = (-1, 0, 0, 1, baseGlyph.width, 0)
            composite.appendComponent(component)
            log.debug(f"Compose {compositename}: Flip {basename}")

        # Even though we can append the glyphs, tt is always better
        # to design a glyph for that. Appending won't take the bearing values
        # into consideration
        appendables = {
            # 'ഈ': ['ഇ', 'ൗ'],
            # 'ഊ': ['ഉ', 'ൗ'],
            # 'ഐ': ['െ','എ'],
            # 'ഓ': ['ഒ', 'ാ'],
            # 'ഔ': ['ഒ', 'ൗ'],
            # 'ൊ': ['െ', 'ാ'],
            # 'ോ': ['േ', 'ാ'],
            # 'ൈ': ['െ', 'െ'],
            # 'ൌ': ['െ', 'ൗ'],
            # '"':['\'', '\''],
            # '"':[''', '''],
            # '"':[''', '''],
        }
        for c, parts in appendables.items():
            compositename = get_glyph_name(c)
            self.newGlyph(compositename)
            composite: Glyph = self[compositename]
            composite.unicodes = [ord(c)]
            composite.width = 0
            for part in parts:
                basename = get_glyph_name(part)
                if basename not in self:
                    log.warn(f"{basename} glyph not found for doubling")
                    continue
                baseGlyph = self[basename]
                component: Component = Component()
                component.move((composite.width, 0))
                component.baseGlyph = basename
                composite.width = composite.width + baseGlyph.width
                composite.appendComponent(component)

        diacritics = [
            "\u02c6",  # 02c6 Circumflex accent
            "\u00b4",  # 00b4 Acute accent
            "\u00b8",  # 00b8 cedilla
            "˚",  # 02da Ring above
            "¯",  # 00af macron
            "`",  # 0060 grave accent
            "ˇ",  # 02c7 caron
            "¨",  # 00a8 Diaeresis
            "˙",  # 02d9 dot above
            "\u02dc",  # 02dc Small tilde
            "\u02d8",  # 02d8 Breve
            "\u02db",  # 02db Ogonek
            "\u02dd",  # 02dd Double acute accent
            "\u0326",  # 0326 COMBINING COMMA BELOW
        ]

        # Cache class lookups
        lc_all = self.get_glyphs_from_named_classes("LC_ALL")
        uc_all = self.get_glyphs_from_named_classes("UC_ALL")
        latin_extra_set = set(self.get_glyphs_from_named_classes("LATIN_EXTRA"))

        for diacritic in diacritics:
            diacritic_name = get_glyph_name(diacritic)

            for base in lc_all + uc_all:
                base_name = get_glyph_name(base)
                items = [base_name, diacritic_name]
                composite_glyph_name = "".join(items)
                if composite_glyph_name in agl.AGL2UV:
                    composite_unicode = agl.AGL2UV[composite_glyph_name]
                else:
                    continue
                if chr(composite_unicode) not in latin_extra_set:
                    continue
                assert diacritic_name in self
                if base_name in ["i", "j"]:
                    base_name = "dotless" + base_name
                if base_name == "t" and diacritic_name == "caron":
                    diacritic_name = "caroncmbalt"
                if base_name == "L" and diacritic_name == "cedilla":
                    diacritic_name = "commaaccent"
                if base_name == "L" and diacritic_name == "caron":
                    diacritic_name = "caroncmbalt"
                if base_name == "l" and diacritic_name == "caron":
                    diacritic_name = "caroncmbalt"
                if base_name == "n" and diacritic_name == "cedilla":
                    diacritic_name = "commaaccent"
                if base_name == "g" and diacritic_name == "cedilla":
                    diacritic_name = "commaturnedmod"
                items = [base_name, diacritic_name]
                assert base_name in self
                log.debug(
                    f"Compose {chr(composite_unicode)} - {composite_glyph_name} : {
                        '+'.join(items)
                    } : {composite_unicode}"
                )
                self.buildComposite(composite_glyph_name, composite_unicode, items)

        # Cache class lookup
        consonants = self.get_glyphs_from_named_classes("ML_CONSONANTS")
        la_conjuncts_set = set(self.get_glyphs_from_named_classes("ML_LA_CONJUNCTS"))

        for base in consonants:
            base_glyph_name = get_glyph_name(base)
            if base_glyph_name not in self:
                continue
            if base + "്ല" not in la_conjuncts_set:
                continue
            la_glyph_name = get_glyph_name(base + "്ല")
            la_sign_glyph_name = get_glyph_name("്ല")
            log.debug(
                f"Compose {la_glyph_name} : {base_glyph_name}+{la_sign_glyph_name}"
            )
            self.buildComposite(
                la_glyph_name, None, [base_glyph_name, la_sign_glyph_name]
            )

        # Cache class lookups
        reph_conjuncts = self.get_glyphs_from_named_classes("ML_REPH_CONJUNCTS")
        cons_conjuncts = self.get_glyphs_from_named_classes("ML_CONS_CONJUNCTS")
        la_conjuncts_list = self.get_glyphs_from_named_classes("ML_LA_CONJUNCTS")
        prevent_conjuncts_set = set(
            self.get_glyph_names_from_named_classes("ML_PREVENT_CONJUNCTS")
        )

        base_for_u = (
            consonants + cons_conjuncts + la_conjuncts_list + reph_conjuncts + ["്യ"]
        )

        for base in base_for_u:
            base_glyph_name = get_glyph_name(base)
            if base_glyph_name not in self:
                continue
            u_glyph_name = get_glyph_name(base + "ു")
            uu_glyph_name = get_glyph_name(base + "ൂ")

            if u_glyph_name not in self and u_glyph_name not in prevent_conjuncts_set:
                log.debug(f"Compose {u_glyph_name} : {base_glyph_name}+u_drop_sign")
                self.buildComposite(
                    u_glyph_name, None, [base_glyph_name, "u_drop_sign"]
                )
                if base_glyph_name in self.salts:
                    u_glyph_name_alt = u_glyph_name.replace(
                        base_glyph_name, self.salts[base_glyph_name][0]
                    )
                    self.buildComposite(
                        u_glyph_name_alt,
                        None,
                        [self.salts[base_glyph_name][0], "u_drop_sign"],
                    )
                    self.salts[u_glyph_name] = [u_glyph_name_alt]
            if uu_glyph_name not in self and uu_glyph_name not in prevent_conjuncts_set:
                log.debug(f"Compose {uu_glyph_name} : {base_glyph_name}+uu_drop_sign")
                self.buildComposite(
                    uu_glyph_name, None, [base_glyph_name, "uu_drop_sign"]
                )
                if base_glyph_name in self.salts:
                    uu_glyph_name_alt = uu_glyph_name.replace(
                        base_glyph_name, self.salts[base_glyph_name][0]
                    )
                    self.buildComposite(
                        uu_glyph_name_alt,
                        None,
                        [self.salts[base_glyph_name][0], "uu_drop_sign"],
                    )
                    self.salts[uu_glyph_name] = [uu_glyph_name_alt]

        # Add space
        space = Glyph(name="space")
        space.width = self["i"].width * 1.5
        space.unicodes = [0x0020]
        self.addGlyph(space)
        # NBSP width must be same as Space width
        self["uni00A0"].width = space.width

        log.debug(f"Total glyph count: {len(self)}")

    @staticmethod
    def commonAnchor(setA, setB) -> str | None:
        nameSetA = [anchor["name"] for anchor in setA]
        nameSetB = [anchor["name"] for anchor in setB]
        commonNames = [name for name in nameSetA if name in nameSetB]
        if len(commonNames):
            return commonNames[0]
        return None

    def buildComposite(self, glyph_name: str, unicode, items: List):
        glyph_name = glyph_name.strip()
        self.newGlyph(glyph_name)
        composite: Glyph = self[glyph_name]
        composite.unicode = unicode
        base = items[0].strip()
        items = items[1:]
        component = Component(composite)
        component.baseGlyph = base
        baseGlyph: Glyph = self[base]
        composite.width = baseGlyph.width
        composite.components.append(component)

        for glyphName in items:
            glyphName = glyphName.strip()
            baseAnchors = baseGlyph.anchors
            currentGlyph = self[glyphName]
            glyphAnchors = currentGlyph.anchors
            commonAnchorName = MalayalamFont.commonAnchor(baseAnchors, glyphAnchors)

            component = Component(composite)
            component.baseGlyph = glyphName
            if commonAnchorName is None:
                # No common anchors. Avoid fallback. Just remove the glyph from font.
                del self[glyph_name]
                continue
            else:
                anchor = _anchor = None
                for a in baseAnchors:
                    if a["name"] == commonAnchorName:
                        anchor = a
                for a in glyphAnchors:
                    if a["name"] == commonAnchorName:
                        _anchor = a
                if anchor and _anchor:
                    x = anchor["x"] - _anchor["x"]
                    y = anchor["y"] - _anchor["y"]
                    component.move((x, y))
            composite.components.append(component)
            composite.lib["public.markColor"] = "0.92, 0.93, 0.94, 1.0"  # grey
            # Now current glyph is base glyph for next one, if any
            baseGlyph = currentGlyph

    def updateFontVersion(self):
        version = str(self.options.version)
        now = datetime.utcnow()
        versionMajor, versionMinor = [int(num) for num in version.split(".")]
        self.info.versionMajor = versionMajor
        self.info.versionMinor = versionMinor
        self.info.openTypeNameVersion = "Version %d.%03d" % (versionMajor, versionMinor)
        psFamily = re.sub(r"\s", "", self.options.name)
        psStyle = re.sub(r"\s", "", self.style)
        self.info.openTypeNameUniqueID = "%s-%s:%d" % (psFamily, psStyle, now.year)
        self.info.openTypeHeadCreated = now.strftime("%Y/%m/%d %H:%M:%S")

    def setGlyphList(self):
        """Write lib.plist file"""
        glyphOrderList: list[str] = []
        for glyph in self:
            glyphOrderList.append(glyph.name)

        self.glyphOrder = glyphOrderList

    def build_glyph_groups(self):
        groupDict = {}
        for gclass in self.options.glyphs.kern.classes:
            glyph_names = [
                get_glyph_name(g) for g in self.get_glyphs_from_named_classes(gclass)
            ]
            glyph_names = [g for g in glyph_names if g in self]
            groupDict[f"public.kern{gclass}"] = glyph_names
        self.groups = groupDict

    def build_kern(self):
        kerningDict = {}
        for script in ["latin", "malayalam"]:
            eval(f"LANGUAGE_{script.upper()}")
            for kern_def in self.options.glyphs.kern[script]:
                lhs_def = kern_def[0]
                rhs_def = kern_def[1]
                xAdvance = kern_def[2]
                if "1." in lhs_def:
                    # Group
                    lhs = f"public.kern{lhs_def}"
                    if "2." in rhs_def:
                        # Group
                        rhs = f"public.kern{rhs_def}"
                        kerningDict[(lhs, rhs)] = xAdvance
                    else:
                        if isinstance(rhs_def, list):
                            for rg in rhs_def:
                                rhs = get_glyph_name(rg)
                                kerningDict[(lhs, rhs)] = xAdvance
                        else:
                            rhs = get_glyph_name(rhs_def)
                            kerningDict[(lhs, rhs)] = xAdvance
                else:
                    if isinstance(lhs_def, list):
                        lhss = [get_glyph_name(letter) for letter in lhs_def]
                    else:
                        lhss = [get_glyph_name(lhs_def)]
                    for lhs in lhss:
                        if "2." in rhs_def:
                            # Group
                            rhs = f"public.kern{rhs_def}"
                            kerningDict[(lhs, rhs)] = xAdvance
                        else:
                            if isinstance(rhs_def, list):
                                for rg in rhs_def:
                                    rhs = get_glyph_name(rg)
                                    kerningDict[(lhs, rhs)] = xAdvance
                            else:
                                rhs = get_glyph_name(rhs_def)
                                kerningDict[(lhs, rhs)] = xAdvance
        # print(kerningDict)
        self.kerning = kerningDict

    def setFontInfo(self):
        name = self.options.name
        style = self.style
        repo = self.options.source

        # set various font metadata; see the full list of fontinfo attributes at
        # https://unifiedfontobject.org/versions/ufo3/fontinfo.plist/#generic-dimension-information
        self.info.unitsPerEm = int(self.options.unitsPerEm)
        # we just use a simple scheme that makes all sets of vertical metrics the same;
        # if one needs more fine-grained control they can fix up post build
        self.info.ascender = int(self.options.ascender)
        self.info.descender = int(self.options.descender)

        # Names
        self.info.familyName = name
        self.info.styleName = style
        self.info.copyright = (
            f"Copyright {datetime.utcnow().year} The {name} Project Authors ({repo})"
        )
        self.info.openTypeNameDesigner = (
            f"{self.options.author.name} ({self.options.author.email})"
        )
        self.info.openTypeNameDesignerURL = self.options.author.url
        self.info.openTypeNameLicense = self.options.license.text
        self.info.openTypeNameLicenseURL = self.options.license.url
        self.info.openTypeNameManufacturer = self.options.manufacturer.name
        self.info.openTypeOS2VendorID = self.info.openTypeNameManufacturer
        self.info.openTypeNameManufacturerURL = self.options.manufacturer.url

        # Metrics
        self.info.xHeight = int(self.options.xheight)
        self.info.capHeight = int(self.options.Xheight)
        self.info.guidelines = []
        self.info.italicAngle = 0

        # OpenType OS/2 Table - glyph metrics used historically by OS/2 and Windows platforms
        self.info.openTypeOS2CodePageRanges = [0, 1]
        self.info.openTypeOS2FamilyClass = [0, 0]
        self.info.openTypeOS2Panose = [0, 0, 8, 3, 0, 0, 0, 0, 0, 0]
        # set USE_TYPO_METRICS flag (OS/2.fsSelection bit 7) to make sure OS/2 Typo* metrics
        # are preferred to define Windows line spacing over legacy WinAscent/WinDescent:
        # https://docs.microsoft.com/en-us/typography/opentype/spec/os2#fsselection
        # The description of bit 7 in the OpenType standard reads
        # "if set, it is strongly recommended to use
        # OS/2.sTypoAscender - OS/2.sTypoDescender + OS/2.sTypoLineGap
        # as a value for default line spacing for this font."
        self.info.openTypeOS2Selection = [7]
        # A list of bit numbers indicating the embedding type.
        self.info.openTypeOS2Type = []
        # The TypoAscender minus the TypoDescender should equal the unit square.
        # the height of the ascenders in units
        self.info.openTypeOS2TypoAscender = round(self.info.ascender * 1.25)
        # the depth of the descenders in units (negative value)
        self.info.openTypeOS2TypoDescender = -round(self.info.descender * 1.25)
        self.info.openTypeOS2TypoLineGap = 0
        self.info.openTypeOS2UnicodeRanges = [0, 1, 2, 3, 23]
        self.info.openTypeOS2WeightClass = int(self.weight)
        # OpenTypeOS2WidthClass should change as per style:
        # ULTRA_CONDENSED = 1
        # EXTRA_CONDESED = 2
        # CONDENSED = 3
        # SEMI_CONDENSED = 4
        # NORMAL = 5  # alias for WidthClass.MEDIUM
        # MEDIUM = 5
        # SEMI_EXPANDED = 6
        # EXPANDED = 7
        # EXTRA_EXPANDED = 8
        # ULTRA_EXPANDED = 9
        if self.style == "Expanded":
            self.info.openTypeOS2WidthClass = 7
        elif self.style == "Condensed":
            self.info.openTypeOS2WidthClass = 3
        else:
            self.info.openTypeOS2WidthClass = 5

        # A font's winAscent and winDescent values should be greater than the head
        # table's yMax, abs(yMin) values. If they are less than these values,
        # clipping can occur on Windows platforms
        # the top extremum of the font rendering box
        self.info.openTypeOS2WinAscent = 1032  # As calculated by `make metrics-report`
        # the bottom extremum of the font rendering box (positive value)
        self.info.openTypeOS2WinDescent = 617  # As calculated by `make metrics-report`
        # When the win Metrics are significantly greater than the upm, the
        # linespacing can appear too loose. To counteract this, enabling the OS/2
        # fsSelection bit 7 (Use_Typo_Metrics), will force Windows to use the OS/2
        # typo values instead. This means the font developer can control the
        # linespacing with the typo values, whilst avoiding clipping by setting the
        # win values to values greater than the yMax and abs(yMin).

        # HHEA table
        # OS/2 and hhea vertical metric values should match. This will produce the
        # same linespacing on Mac, GNU+Linux and Windows.

        # - Mac OS X uses the hhea values.
        # - Windows uses OS/2 or Win, depending on the OS or fsSelection bit value.
        # The height of the ascenders in units
        self.info.openTypeHheaAscender = self.info.openTypeOS2TypoAscender
        # The depth of the descenders in units (negative value)
        self.info.openTypeHheaDescender = self.info.openTypeOS2TypoDescender
        self.info.openTypeHheaLineGap = 0

        # postscript metrics
        # Refer Chapter 5 of https://adobe-type-tools.github.io/font-tech-notes/pdfs/T1_SPEC.pdf
        self.info.postscriptBlueValues = [
            # Base zone
            -20,
            0,
            # xheight zone
            int(self.info.xHeight),
            int(self.info.xHeight + 15),
            # capHeight zone
            int(self.info.capHeight),
            int(self.info.capHeight + 15),
            # ascender zone
            int(self.info.ascender),
            int(self.info.ascender + 15),
        ]
        self.info.postscriptOtherBlues = [
            int(-self.info.descender),
            int(-self.info.descender + 12),
        ]
        self.info.guidelines = [
            Guideline(name="xheight", y=self.info.xHeight),
            Guideline(name="capHeight", y=self.info.capHeight),
            Guideline(name="mid", y=self.info.xHeight / 2),
        ]
        # self.info.postscriptFamilyBlues = []
        # self.info.postscriptFamilyOtherBlues = []

        self.info.postscriptSlantAngle = 0
        self.info.postscriptUnderlinePosition = -200
        self.info.postscriptUnderlineThickness = 50

        self.info.openTypeGaspRangeRecords = [
            GaspRangeRecord(
                65535, [0, 1, 2, 3]
            )  # GRIDFIT  # DOGRAY  # SYMMETRIC_GRIDFIT  # SYMMETRIC_SMOOTHING
        ]
