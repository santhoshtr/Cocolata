import os
import traceback
import xml.etree.ElementTree as etree

from fontTools.svgLib import SVGPath
from fontTools.ufoLib import UFOLibError
from fontTools.misc.roundTools import otRound
from ufoLib2.objects import Glyph

from glyphnames import get_glyph_name, parse_glyph_filename, get_unicode_for_name


class SVGGlyph:
    def __init__(self, svg_file_path):
        self.svg_file_path = svg_file_path
        self.svg_width = 0.0
        self.svg_height = 0.0
        self.name = ""
        self.alt = None
        self.onum = None
        self.sups = None
        self.unicode = None
        self.glyph_name = ""
        self.glyph_width = 0
        self.glyph_height = 1000
        self.glif = None
        self.transform = "1 0 0 -1 0 0"

    @staticmethod
    def svg2glif(
        svg_file,
        name,
        width=0,
        height=0,
        unicodes=None,
        transform=None,
        version=3,
        anchors=None,
    ):
        """Convert an SVG outline to a UFO glyph with given 'name', advance
        'width' and 'height' (int), and 'unicodes' (list of int).
        Return the resulting string in GLIF format (default: version 2).
        If 'transform' is provided, apply a transformation matrix before the
        conversion (must be tuple of 6 floats, or a FontTools Transform object).
        """
        glyph = Glyph(name=name)
        glyph.width = width
        glyph.height = height
        glyph.unicodes = unicodes or []
        glyph.anchors = anchors or []
        svg = SVGPath(svg_file, transform)
        pen = glyph.getPen()
        svg.draw(pen)
        return glyph

    @staticmethod
    def transform_list(arg):
        try:
            return [float(n) for n in arg.split()]
        except ValueError:
            msg = "Invalid transformation matrix: %r" % arg
            raise ValueError(msg)

    def round_glif_points(self):
        """
        Rounds the x and y coordinates of points in a Glif object.

        Parameters:
        - self: The Glif object containing the points to be rounded.

        Returns:
        - None

        Description:
        This method iterates through the contours and points in a Glif object and rounds the x and y coordinates of each point.
        The rounding is done using the otRound function.

        """
        for contour in self.glif:
            for point in contour.points:
                # Round the point's x and y coordinates
                point.x = otRound(point.x)
                point.y = otRound(point.y)

    def parse(self):
        svgObj = etree.parse(self.svg_file_path).getroot()
        parent_map = {c: p for p in svgObj.iter() for c in p}
        self.svg_width = float(svgObj.get("width", "1000").replace("px", " "))
        self.svg_height = float(svgObj.get("height", "1000").replace("px", " "))
        # Filename without extension
        filename = os.path.splitext(os.path.basename(self.svg_file_path))[0]

        # Parse filename for glyph metadata
        parsed = parse_glyph_filename(filename)
        self.name = parsed["name"]
        self.alt = parsed["alt"]
        self.onum = parsed["onum"]
        self.sups = parsed["sups"]

        # Determine Unicode value
        has_variant = self.alt or self.onum or self.sups
        self.unicode = get_unicode_for_name(self.name, has_variant=has_variant)

        self.glyph_name = get_glyph_name(self.name)
        if not self.glyph_name:
            raise UFOLibError(f"Could not calculate glyph name for {self.name}")

        prefix_map = {
            "sodipodi": "http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd",
            "inkscape": "http://www.inkscape.org/namespaces/inkscape",
        }
        widthGuide = svgObj.find(
            ".//sodipodi:guide/[@inkscape:label='width']", prefix_map
        )

        width = self.svg_width
        if widthGuide is not None:
            width = int(float(widthGuide.get("position").split(",")[0]))

        # + int(svg_config['left']) + int(svg_config['right'])
        self.glyph_width = width
        if self.glyph_width < 0:
            raise UFOLibError("Glyph %s has negative width." % self.name)

        # Calculate the transformation to do
        transform = SVGGlyph.transform_list(self.transform)

        baseGuide = svgObj.find(
            ".//sodipodi:guide/[@inkscape:label='base']", prefix_map
        )
        base = -250
        if baseGuide is not None:
            base = int(float(baseGuide.get("position").split(",")[1])) * -1
        transform[5] += self.svg_height + base  # Y offset
        anchorEls = svgObj.findall(".//{http://www.w3.org/2000/svg}text", prefix_map)
        anchors = []

        vc_guide = svgObj.find(".//sodipodi:guide/[@inkscape:label='vc']", prefix_map)
        if vc_guide is not None:
            anchors.append(
                {
                    "x": float(vc_guide.get("position").split(",")[0]),
                    "y": 0,
                    "name": "vc",
                }
            )

        anchor_names = []
        try:
            for anchorEl in anchorEls:
                x = 0
                y = 0
                name = ""
                parentEl = parent_map.get(anchorEl)
                if parentEl and "transform" in parentEl.attrib:
                    transformstr = parentEl.get("transform")
                    if "translate" in transformstr:
                        [x, y] = (
                            transformstr.strip()
                            .replace("translate(", "")
                            .replace(")", "")
                            .split(" ")
                        )
                    if "matrix" in transformstr:
                        [lhs, y] = (
                            transformstr.strip()
                            .replace("matrix(", "")
                            .replace(")", "")
                            .split(" ")
                        )
                        x = lhs.split(",")[-1]
                    x = float(x)
                    y = float(y)
                if "x" in anchorEl.attrib:
                    x = float(anchorEl.get("x"))
                if "y" in anchorEl.attrib:
                    y = float(anchorEl.get("y"))
                if (
                    "{http://www.inkscape.org/namespaces/inkscape}label"
                    in anchorEl.attrib
                ):
                    name = anchorEl.attrib[
                        "{http://www.inkscape.org/namespaces/inkscape}label"
                    ]
                else:
                    name = anchorEl.text

                anchor = {"x": x, "y": self.svg_height + base - y, "name": name}
                # print(anchor)
                anchor_names.append(name)

                if name == "vc":
                    anchor["y"] = 0
                anchors.append(anchor)
        except Exception:
            print(f"Error while processing {self.__dict__}")
            traceback.print_exc()
            pass
        if "right" not in anchor_names:
            anchors.append({"x": self.glyph_width, "y": 0, "name": "right"})
        try:
            glif_name = self.glyph_name
            if self.alt:
                glif_name = self.glyph_name + "." + self.alt
            if self.onum:
                glif_name = self.glyph_name + "." + self.onum
            if self.sups:
                glif_name = self.glyph_name + "." + self.sups
            self.glif = SVGGlyph.svg2glif(
                self.svg_file_path,
                name=glif_name,
                width=self.glyph_width,
                height=self.glyph_height,
                unicodes=self.unicode,
                transform=transform,
                anchors=anchors,
                version=3,
            )
        except Exception:
            print(f"Error while processing {self.__dict__}")
            traceback.print_exc()

        self.round_glif_points()
