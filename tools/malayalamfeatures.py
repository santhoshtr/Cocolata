import logging
from typing import List

from fontTools import agl
from glyphnames import get_glyph_name
from ufoLib2.objects import Font
from jinja2 import Environment, FileSystemLoader
import os

log = logging.getLogger(__name__)

LANGUAGE_ALL = [("DFLT", "dflt"), ("latn", "dflt"), ("mlm2", "dflt")]
LANGUAGE_MALAYALAM = [("mlm2", "dflt")]
LANGUAGE_LATIN = [("DFLT", "dflt"), ("latn", "dflt")]


class MalayalamFeatures:
    """
    Handles OpenType feature generation for Malayalam fonts.
    Works with an already-built UFO font to generate feature code.
    """

    def __init__(self, ufo_font: Font, options):
        """
        Initialize MalayalamFeatures

        Args:
            ufo_font: Already built UFO font
            options: Font configuration options
        """
        self.font = ufo_font
        self.options = options
        # These will be populated if the font has them
        self.salts = getattr(ufo_font, "salts", {})
        self.onums = getattr(ufo_font, "onums", {})
        self.sups = getattr(ufo_font, "sups", {})

    def prepare_template_data(self):
        """Prepare all data needed for Jinja2 templates"""
        data = {
            "glyph_classes": self._prepare_glyph_classes(),
            "gdef": self._prepare_gdef_data(),
            "mark_classes": self._prepare_mark_classes(),
            "ligatures": self._prepare_ligature_data(),
            "chillus": self._prepare_chillu_data(),
            "conjuncts": self._prepare_conjunct_data(),
            "cons_signs": self._prepare_cons_signs_data(),
            "cons_signs_order_rules": self._prepare_cons_signs_order_rules(),
            "reph": self._prepare_reph_data(),
            "reph_conjuncts": self._prepare_reph_conjuncts_data(),
            "vowel_sign_rules": self._prepare_vowel_sign_rules(),
            "top_anchors": self._prepare_top_anchors(),
            "bottom_anchors": self._prepare_bottom_anchors(),
            "aam_rules": self._prepare_aam_rules(),
            "calt_rules": self._prepare_calt_rules(),
            "salts": self.salts,
            "sups": self.sups,
            "aalts": self._prepare_aalt_data(),
        }
        return data

    def _prepare_glyph_classes(self):
        """Prepare glyph classes for templates"""
        classes = {}
        for gclass in self.options.glyphs.classes:
            glyph_names = [
                get_glyph_name(g) for g in self.get_glyphs_from_named_classes(gclass)
            ]
            glyph_names = [g for g in glyph_names if g in self.font]
            classes[gclass] = glyph_names
        return classes

    def _prepare_gdef_data(self):
        """Prepare GDEF table data"""
        bases = []
        ligatures = []
        marks = [
            "acutecmb",
            "brevecmb",
            "caroncmb",
            "cedillacmb",
            "circumflexcmb",
            "commaaccent",
            "commaturnedabovecmb",
            "dieresiscmb",
            "dotaccentcmb",
            "gravecmb",
            "hungarumlautcmb",
            "macroncmb",
            "ml_virama",
            "ml_candrabindu",
            "ml_circular_virama",
            "ml_combining_anusvara_above",
            "ml_vertical_bar_virama",
            "ml_dot_reph",
            "ogonekcmb",
            "ringcmb",
            "tildecmb",
        ]

        # Bases: consonants and Latin letters
        base_classes = ["ML_CONSONANTS", "LC_ALL", "UC_ALL"]
        for class_name in base_classes:
            for glyph in self.get_glyphs_from_named_classes(class_name):
                glyph_name = get_glyph_name(glyph)
                if glyph_name in self.font:
                    bases.append(glyph_name)

        # Ligatures: conjuncts and Latin extras
        lig_classes = [
            "ML_REPH_CONJUNCTS",
            "ML_CONS_CONJUNCTS",
            "ML_LA_CONJUNCTS",
            "LATIN_EXTRA",
        ]
        for class_name in lig_classes:
            for glyph in self.get_glyphs_from_named_classes(class_name):
                glyph_name = get_glyph_name(glyph)
                if glyph_name in self.font:
                    ligatures.append(glyph_name)

        return {
            "bases": bases,
            "ligatures": ligatures,
            "marks": [m for m in marks if m in self.font],
        }

    def _prepare_mark_classes(self):
        """Prepare mark class definitions"""
        return [
            {
                "glyph": "ml_combining_anusvara_above",
                "x": 148,
                "y": 0,
                "class_name": "vc_vc",
            },
            {"glyph": "ml_dot_reph", "x": -54, "y": 0, "class_name": "vc_vc"},
            {
                "glyph": "ml_sign_vocalic_l",
                "x": 50,
                "y": 0,
                "class_name": "bottom_bottom",
            },
            {
                "glyph": "ml_sign_vocalic_ll",
                "x": 166,
                "y": 0,
                "class_name": "bottom_bottom",
            },
        ]

    def _prepare_ligature_data(self):
        """Prepare ligature data"""
        ligatures = self.get_glyphs_from_named_classes("LATIN_LIGATURES")
        components_map = {"heart": ["less", "three"]}

        latin_ligs = []
        for ligature in ligatures:
            if ligature in components_map:
                components = [
                    get_glyph_name(letter) for letter in components_map.get(ligature)
                ]
            else:
                components = [get_glyph_name(letter) for letter in ligature]

            latin_ligs.append({"input": components, "output": get_glyph_name(ligature)})

        return {"latin": latin_ligs}

    def _prepare_chillu_data(self):
        """Prepare chillu data"""
        chillus = [
            "ന്\u200d",
            "ര്\u200d",
            "ല്\u200d",
            "ള്\u200d",
            "ണ്\u200d",
            "ഴ്\u200d",
            "ക്\u200d",
        ]

        chillu_data = []
        for chillu in chillus:
            chillu_data.append(
                {
                    "input": [get_glyph_name(letter) for letter in chillu],
                    "output": get_glyph_name(chillu),
                }
            )
        return chillu_data

    def _prepare_cons_signs_data(self):
        """Prepare consonant signs data"""
        cons_signs = ["്യ", "്വ"]
        return [
            {
                "input": [get_glyph_name(letter) for letter in cons_sign],
                "output": get_glyph_name(cons_sign),
            }
            for cons_sign in cons_signs
        ]

    def _prepare_cons_signs_order_rules(self):
        """Prepare consonant signs order fix rules"""
        return [
            {"pattern": "ml_ya ml_virama_ra'"},
            {"pattern": "ml_virama_ya ml_virama_ra'"},
            {"pattern": "ml_virama_va ml_virama_ra'"},
        ]

    def _prepare_reph_data(self):
        """Prepare reph data"""
        return {
            "input": [get_glyph_name(letter) for letter in "്ര"],
            "output": get_glyph_name("്ര"),
        }

    def _prepare_reph_conjuncts_data(self):
        """Prepare reph conjuncts data"""
        reph = "്ര"
        reph_conjuncts = []

        reph_conjuncts_glyphs = self.get_glyphs_from_named_classes("ML_REPH_CONJUNCTS")
        reph_glyph_name = get_glyph_name(reph)

        for ligature in reph_conjuncts_glyphs:
            base_ligature = ligature.replace(reph, "")
            ligature_glyph_name = get_glyph_name(ligature)
            if ligature_glyph_name not in self.font:
                continue

            reph_conjuncts.append(
                {
                    "input": [
                        reph_glyph_name,
                        get_glyph_name(base_ligature),
                    ],
                    "output": ligature_glyph_name,
                }
            )

        return reph_conjuncts

    def _prepare_vowel_sign_rules(self):
        """Prepare vowel sign substitution rules"""
        rules = []
        vowel_signs = self.options.glyphs.classes["ML_VOWEL_SIGNS_CONJOINING"]

        # Cache class lookups
        consonants = self.get_glyphs_from_named_classes("ML_CONSONANTS")
        reph_conjuncts = self.get_glyphs_from_named_classes("ML_REPH_CONJUNCTS")
        cons_conjuncts = self.get_glyphs_from_named_classes("ML_CONS_CONJUNCTS")
        la_conjuncts = self.get_glyphs_from_named_classes("ML_LA_CONJUNCTS")

        ligatures = sorted(
            consonants + reph_conjuncts + cons_conjuncts + la_conjuncts + ["്യ"]
        )

        for ligature in ligatures:
            ligature_glyph_name = get_glyph_name(ligature)
            if ligature_glyph_name not in self.font:
                continue

            for vowel_sign in vowel_signs:
                vowel_sign_name = get_glyph_name(vowel_sign, prefix="_")
                replacement_ligature = ligature_glyph_name + vowel_sign_name

                if replacement_ligature not in self.font:
                    continue

                rules.append(
                    {
                        "input": [
                            ligature_glyph_name,
                            get_glyph_name(vowel_sign),
                        ],
                        "output": replacement_ligature,
                    }
                )

        return rules

    def _prepare_aam_rules(self):
        """Prepare aam sign rules"""
        return [
            {
                "input": [
                    get_glyph_name("◌"),
                    get_glyph_name("ാ"),
                    get_glyph_name("ം"),
                ],
                "output": get_glyph_name("ാം"),
            }
        ]

    def _prepare_calt_rules(self):
        """Prepare contextual alternates rules"""
        if "calts" not in self.options.glyphs:
            return {}

        calt_rules = {}
        for script in self.options.glyphs.calts:
            rules = []
            for calt_def in self.options.glyphs.calts[script]:
                rules.append(
                    {
                        "precontext": get_glyph_name(calt_def[0]),
                        "base": get_glyph_name(calt_def[1]),
                        "replacement": get_glyph_name(calt_def[1]) + "." + calt_def[2],
                    }
                )
            calt_rules[script] = rules
        return calt_rules

    def _prepare_conjunct_data(self):
        """Prepare conjunct data"""
        prevent_stack_contexts = {
            "ഷ്ട": ["്ട"],
            "ഷ്പ": ["്ര"],
            "സ്പ": ["്ര"],
            "യ്ത": ["്ത"],
            "സ്ക": ["്ക", "്ര"],
            "സ്ത": ["്ത"],
            "പ്ത": ["്ത"],
            "സ്ന": ["്ന"],
            "ശ്ന": ["്ന"],
            "ല്പ": ["്പ"],
        }

        basic_conjuncts = []
        conditional_conjuncts = []
        chaining_rules = []

        # Cache class lookup
        cons_conjuncts = self.get_glyphs_from_named_classes("ML_CONS_CONJUNCTS")

        for conjunct in cons_conjuncts:
            conjunct_glyph_name = get_glyph_name(conjunct)
            if conjunct_glyph_name not in self.font:
                continue

            conjunct_data = {
                "input": [get_glyph_name(letter) for letter in conjunct],
                "output": conjunct_glyph_name,
            }

            if conjunct in prevent_stack_contexts.keys():
                conditional_conjuncts.append(conjunct_data)

                # Create chaining rules
                for post_stack_conj in prevent_stack_contexts.get(conjunct):
                    ignore_pattern = " ".join(
                        [get_glyph_name(letter) + "'" for letter in conjunct]
                        + [get_glyph_name(letter) for letter in post_stack_conj]
                    )
                    pattern = " ".join(
                        [get_glyph_name(letter) + "'" for letter in conjunct]
                    )
                    chaining_rules.append(
                        {"ignore_pattern": ignore_pattern, "pattern": pattern}
                    )
            else:
                basic_conjuncts.append(conjunct_data)

        # LA conjuncts
        la_conjuncts = []
        la_conjuncts_glyphs = self.get_glyphs_from_named_classes("ML_LA_CONJUNCTS")

        for conjunct in la_conjuncts_glyphs:
            conjunct_glyph_name = get_glyph_name(conjunct)
            if conjunct_glyph_name in self.font:
                la_conjuncts.append(
                    {
                        "input": [get_glyph_name(letter) for letter in conjunct],
                        "output": conjunct_glyph_name,
                    }
                )

        # Fixup rules for vowel signs
        fixup_rules = []
        split_rules = []
        vowel_signs = self.options.glyphs.classes["ML_VOWEL_SIGNS_CONJOINING"]

        # Cache class lookups
        all_conjuncts = self.get_glyphs_from_named_classes(
            "ML_CONS_CONJUNCTS"
        ) + self.get_glyphs_from_named_classes("ML_LA_CONJUNCTS")
        ligatures = sorted(all_conjuncts)

        # Pre-cache vowel sign names
        vowel_sign_names = [get_glyph_name(vs) for vs in vowel_signs]

        for ligature in ligatures:
            ligature_glyph_name = get_glyph_name(ligature)
            if ligature_glyph_name not in self.font:
                continue

            missing_vowels = []
            for i, vowel_sign in enumerate(vowel_signs):
                ligature_vowel = ligature + vowel_sign
                replacement_ligature_glyphname = get_glyph_name(ligature_vowel)
                if replacement_ligature_glyphname not in self.font:
                    missing_vowels.append(vowel_sign_names[i])

            if missing_vowels:
                # Find largest sequence that has vowel support
                parts = []
                seq = ""
                largest_seq = seq
                first_vowel_sign = vowel_signs[0]
                for char in reversed(ligature):
                    seq = char + seq
                    if get_glyph_name(seq + first_vowel_sign) in self.font:
                        largest_seq = seq

                # Create split rule
                for letter in ligature[0 : len(ligature) - len(largest_seq)]:
                    parts.append(letter)
                if len(largest_seq):
                    parts.append(largest_seq)

                split_rules.append(
                    {
                        "input": ligature_glyph_name,
                        "output": [get_glyph_name(letter) for letter in parts],
                    }
                )

                fixup_rules.append(
                    {
                        "input": get_glyph_name(ligature),
                        "context": "[" + " ".join(missing_vowels) + "]",
                    }
                )

        return {
            "basic": basic_conjuncts,
            "conditional": conditional_conjuncts,
            "chaining_rules": chaining_rules,
            "la_conjuncts": la_conjuncts,
            "fixup_rules": fixup_rules,
            "split_rules": split_rules,
        }

    def _prepare_aalt_data(self):
        """Prepare access all alternates data"""
        aalts = {"latin": [], "malayalam": []}

        # Add Latin alternates (example data)
        if "A" in self.salts:
            aalts["latin"].append({"base": "A", "alts": ["A.alt1", "A.alt2"]})

        # Add Malayalam alternates
        for base, alts in self.salts.items():
            if base.startswith("ml_"):
                aalts["malayalam"].append(
                    {"base": base, "alt": alts[0] if alts else base}
                )

        return aalts

    def get_glyphs_from_named_classes(self, *argv):
        """Get glyphs from named classes in options"""
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
        """Get glyph names from named classes"""
        all_glyphs = self.get_glyphs_from_named_classes(class_name)
        return [get_glyph_name(letter) for letter in all_glyphs]

    def _prepare_top_anchors(self):
        """Prepare top anchor positioning data"""
        feature = "abvm"
        name = "abvm_topmarks"

        # Cache class lookups
        top_marks = self.get_glyphs_from_named_classes("ML_TOP_MARKS")
        top_mark_glyphs = [get_glyph_name(c) for c in top_marks]

        consonants = self.get_glyphs_from_named_classes("ML_CONSONANTS")
        reph_conjuncts = self.get_glyphs_from_named_classes("ML_REPH_CONJUNCTS")
        cons_conjuncts = self.get_glyphs_from_named_classes("ML_CONS_CONJUNCTS")
        la_conjuncts = self.get_glyphs_from_named_classes("ML_LA_CONJUNCTS")

        lettersWithMarks = sorted(
            consonants
            + reph_conjuncts
            + cons_conjuncts
            + la_conjuncts
            + top_marks
            + ["\u25cc"]  # Dotted circle.
        )

        anchors = {}
        visual_center_anchor_name = "vc"
        vowel_signs = self.options.glyphs.classes["ML_VOWEL_SIGNS_CONJOINING"]

        # FIXME, should do this for alt glyphs too
        for letter in lettersWithMarks:
            glyph_name = get_glyph_name(letter)
            if glyph_name not in self.font:
                continue
            glyph = self.font[glyph_name]
            for anchor in glyph.anchors:
                if visual_center_anchor_name == anchor.name:
                    anchors[glyph.name] = {
                        visual_center_anchor_name: (int(anchor.x), int(anchor.y))
                    }

            if glyph.name not in anchors:
                anchors[glyph.name] = {
                    visual_center_anchor_name: (int(glyph.width / 2), 0)
                }

        top_bases = {}
        top_marks = {}
        for glyphname, anchors_dict in anchors.items():
            for anchorname, position in anchors_dict.items():
                if anchorname == visual_center_anchor_name:
                    if glyphname in top_mark_glyphs:
                        top_marks[glyphname] = position
                    else:
                        top_bases[glyphname] = position

        def get_base_set(letter):
            base_set = [letter]
            for vowel_sign in vowel_signs:
                letterWithVowel = get_glyph_name(letter) + get_glyph_name(
                    vowel_sign, prefix="_"
                )
                if letterWithVowel not in self.font:
                    continue
                glyphWithVowel = self.font[letterWithVowel]
                base_set.append(glyphWithVowel.name)
            return base_set

        template_data = []
        for letter in lettersWithMarks:
            glyph_name = get_glyph_name(letter)
            if glyph_name not in self.font:
                continue
            if glyph_name not in top_bases:
                continue

            anchor = top_bases.get(glyph_name)
            template_data.append(
                {
                    "bases": get_base_set(glyph_name),
                    "x": anchor[0],
                    "y": anchor[1],
                    "class_name": "vc_vc",
                },
            )

        return template_data

    def _prepare_bottom_anchors(self):
        """Prepare bottom anchor positioning data"""
        anchors = {}
        bbvm_anchor_name = "bottom"

        # Cache class lookups
        consonants = self.get_glyphs_from_named_classes("ML_CONSONANTS")
        bottom_marks = self.get_glyphs_from_named_classes("ML_BOTTOM_MARKS")
        lettersWithMarks = sorted(consonants + bottom_marks)

        for letter in lettersWithMarks:
            glyph_name = get_glyph_name(letter)
            if glyph_name not in self.font:
                continue
            glyph = self.font[glyph_name]
            for anchor in glyph.anchors:
                if bbvm_anchor_name == anchor.name:
                    anchors[glyph.name] = {
                        bbvm_anchor_name: (int(anchor.x), int(anchor.y))
                    }

            if glyph.name not in anchors:
                anchors[glyph.name] = {bbvm_anchor_name: (int(glyph.width), 0)}

        template_data = []
        for letter in lettersWithMarks:
            glyph_name = get_glyph_name(letter)
            if glyph_name not in self.font:
                continue

            anchor_dict = anchors.get(glyph_name)
            if anchor_dict is None:
                continue

            anchor = anchor_dict.get(bbvm_anchor_name)
            if anchor is None:
                continue

            template_data.append(
                {
                    "bases": [glyph_name],
                    "x": anchor[0],
                    "y": anchor[1],
                    "class_name": "bottom_bottom",
                },
            )

        return template_data

    def write_features(self, output_path=None):
        """
        Build OpenType features using Jinja2 templates and write to font or file

        Args:
            output_path: Optional path to write features.fea file.
                        If None, sets self.font.features.text
        """
        # Prepare data for templates
        template_data = self.prepare_template_data()

        # Set up Jinja2 environment
        template_dir = os.path.join(
            os.path.dirname(__file__), "..", "sources", "features"
        )
        env = Environment(
            loader=FileSystemLoader(template_dir), trim_blocks=True, lstrip_blocks=True
        )

        # Render the main template
        template = env.get_template("features.fea.j2")
        features_code = template.render(**template_data)

        if output_path:
            # Write to file
            with open(output_path, "w", encoding="utf-8") as f:
                f.write(features_code)
        else:
            # Set the features in the font
            self.font.features.text = features_code
