import os
import re
import traceback
import xml.etree.ElementTree as etree

from fontTools.svgLib import SVGPath
from fontTools.ufoLib import UFOLibError
from fontTools.misc.roundTools import otRound
from ufoLib2.objects import Glyph

from glyphnames import get_glyph_name, parse_glyph_filename, get_unicode_for_name


# Compiled regex patterns for performance
TRANSLATE_PATTERN = re.compile(r"translate\(([^)]+)\)")
MATRIX_PATTERN = re.compile(r"matrix\(([^)]+)\)")

# Namespace mappings at module level
PREFIX_MAP = {
    "sodipodi": "http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd",
    "inkscape": "http://www.inkscape.org/namespaces/inkscape",
    "svg": "http://www.w3.org/2000/svg",
}


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

    @staticmethod
    def parse_transform(transform_str):
        """Parse SVG transform attribute and extract x, y coordinates.

        Args:
            transform_str: SVG transform attribute string

        Returns:
            tuple: (x, y) coordinates as floats
        """
        x, y = 0.0, 0.0

        # Try translate pattern
        translate_match = TRANSLATE_PATTERN.search(transform_str)
        if translate_match:
            coords = translate_match.group(1).split()
            x = float(coords[0])
            y = float(coords[1]) if len(coords) > 1 else 0.0
            return x, y

        # Try matrix pattern
        matrix_match = MATRIX_PATTERN.search(transform_str)
        if matrix_match:
            values = matrix_match.group(1).replace(",", " ").split()
            if len(values) >= 6:
                x = float(values[4])
                y = float(values[5])
                return x, y

        return x, y

    @staticmethod
    def get_anchor_label(anchor_el):
        """Extract anchor label from element.

        Args:
            anchor_el: XML element

        Returns:
            str: Label text or None
        """
        inkscape_label = anchor_el.get(
            "{http://www.inkscape.org/namespaces/inkscape}label"
        )
        if inkscape_label:
            return inkscape_label
        return anchor_el.text

    def parse(self):
        """Parse SVG file and extract glyph information.

        This method performs a single-pass extraction of all needed data from the SVG.
        """
        try:
            tree = etree.parse(self.svg_file_path)
            svgObj = tree.getroot()
        except etree.ParseError as e:
            raise UFOLibError(f"Failed to parse SVG file {self.svg_file_path}: {e}")

        # Extract basic SVG dimensions
        self.svg_width = float(svgObj.get("width", "1000").replace("px", ""))
        self.svg_height = float(svgObj.get("height", "1000").replace("px", ""))

        # Parse filename for glyph metadata
        filename = os.path.splitext(os.path.basename(self.svg_file_path))[0]
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

        # Extract guides and anchors in a single pass
        width_guide = svgObj.find(
            ".//sodipodi:guide[@inkscape:label='width']", PREFIX_MAP
        )
        base_guide = svgObj.find(
            ".//sodipodi:guide[@inkscape:label='base']", PREFIX_MAP
        )
        vc_guide = svgObj.find(".//sodipodi:guide[@inkscape:label='vc']", PREFIX_MAP)

        # Calculate width
        width = self.svg_width
        if width_guide is not None:
            position = width_guide.get("position", "")
            if position:
                width = int(float(position.split(",")[0]))

        self.glyph_width = width
        if self.glyph_width < 0:
            raise UFOLibError(f"Glyph {self.name} has negative width.")

        # Calculate base offset
        base = -250
        if base_guide is not None:
            position = base_guide.get("position", "")
            if position:
                base = int(float(position.split(",")[1])) * -1

        # Calculate transformation
        transform = SVGGlyph.transform_list(self.transform)
        transform[5] += self.svg_height + base  # Y offset

        # Process anchors
        anchors = []

        # Add vc guide anchor if present
        if vc_guide is not None:
            position = vc_guide.get("position", "")
            if position:
                x = float(position.split(",")[0])
                anchors.append({"x": x, "y": 0, "name": "vc"})

        # Build parent map for anchor processing
        parent_map = {c: p for p in svgObj.iter() for c in p}

        # Find all text elements (used as anchors)
        anchor_elements = svgObj.findall(".//{http://www.w3.org/2000/svg}text")

        anchor_names = set()
        for anchor_el in anchor_elements:
            try:
                x = float(anchor_el.get("x", 0))
                y = float(anchor_el.get("y", 0))

                # Check parent for transform
                parent_el = parent_map.get(anchor_el)
                if parent_el is not None:
                    transform_str = parent_el.get("transform", "")
                    if transform_str:
                        parent_x, parent_y = SVGGlyph.parse_transform(transform_str)
                        x += parent_x
                        y += parent_y

                # Get anchor name/label
                name = SVGGlyph.get_anchor_label(anchor_el)
                if not name:
                    continue

                # Calculate final position
                anchor_y = self.svg_height + base - y
                if name == "vc":
                    anchor_y = 0

                anchor = {"x": x, "y": anchor_y, "name": name}
                anchors.append(anchor)
                anchor_names.add(name)

            except (ValueError, AttributeError, KeyError) as e:
                # Log but continue processing other anchors
                print(f"Warning: Failed to process anchor in {self.svg_file_path}: {e}")
                continue

        # Add default "right" anchor if not present
        if "right" not in anchor_names:
            anchors.append({"x": self.glyph_width, "y": 0, "name": "right"})

        # Build glyph name with variant suffix
        glif_name = self.glyph_name
        if self.alt:
            glif_name = self.glyph_name + "." + self.alt
        elif self.onum:
            glif_name = self.glyph_name + "." + self.onum
        elif self.sups:
            glif_name = self.glyph_name + "." + self.sups

        # Create GLIF
        try:
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
        except Exception as e:
            raise UFOLibError(
                f"Failed to convert SVG to GLIF for {self.svg_file_path}: {e}"
            )

        self.round_glif_points()
