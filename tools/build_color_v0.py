import copy
import logging
import sys
from operator import itemgetter
from fontTools.ttLib import getTableModule
import ufo2ft
from fontTools.svgLib import SVGPath
from ufoLib2.objects import Font, Layer
from ufoLib2.objects import Glyph

log = logging.getLogger(__name__)


def hex_to_rgba(hex: str):
    return getTableModule("CPAL").Color.fromHex(hex)


@staticmethod
def svg2glif(
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
    #    svg = SVGPath(svg_file, transform)
    svg_str = f"""<svg width="{width}" height="{height}" xmlns="http://www.w3.org/2000/svg">
  <path d="M 0 0 L -1000 0 L 1000 -82 L 0 82 Z" />
  <path d="M 0 -102 L 1000 -102 L 1000 -184 L 0 -184 Z" />
  <path d="M 0 -204 L 1000 -204 L 1000 -286 L 0 -286 Z" />
  <path d="M 0 -306 L 1000 -306 L 1000 -388 L 0 -388 Z" />
  <path d="M 0 -408 L 1000 -408 L 1000 -490 L 0 -490 Z" />
  <path d="M 0 -510 L 1000 -510 L 1000 -592 L 0 -592 Z" />
  <path d="M 0 -612 L 1000 -612 L 1000 -694 L 0 -694 Z" />
  <path d="M 0 -714 L 1000 -714 L 1000 -796 L 0 -796 Z" />
  <path d="M 0 -816 L 1000 -816 L 1000 -898 L 0 -898 Z" />
  <path d="M 0 -918 L 1000 -918 L 1000 -1000 L 0 -1000 Z" />
</svg>
    """
    svg = SVGPath.fromstring(svg_str, transform)
    pen = glyph.getPen()
    svg.draw(pen)
    return glyph


layer_mapping = []
CPAL_palettes = []
layer_mapping.append(["public.default", 0])
# layer_mapping.append(["ink", 1])
font = Font().open(sys.argv[1])
# layer: Layer = font.newLayer(name="ink")
layer = font.layers.get("public.default")
mask_glyph = svg2glif(
    "ink_mask",
    1000,
    1400,
    None,
    (1, 0, 0, -1, 0, 0),
)
layer.insertGlyph(mask_glyph, "ink_mask")


layer_mapping = sorted(layer_mapping, key=itemgetter(1))
font.lib[ufo2ft.constants.COLOR_LAYER_MAPPING_KEY] = layer_mapping

palettes = [
    ["#E65100", "#FFCC80"],  # Orange
    ["#212121", "#EEEEEE"],  # Gray
    ["#263238", "#B0BEC5"],  # Blue Gray
    ["#F57F17", "#FFF59D"],  # Yellow
    ["#1B5E20", "#A5D6A7"],  # Green
    ["#01579B", "#81D4FA"],  # Light Blue
    ["#0D47A1", "#90CAF9"],  # Blue
    ["#B71C1C", "#EF9A9A"],  # Red
    ["#4A148C", "#CE93D8"],  # Purple
    ["#004D40", "#80CBC4"],  # Teal
    ["#3E2723", "#BCAAA4"],  # Brown
    ["#880E4F", "#F48FB1"],  # Pink
    ["#311B92", "#B39DDB"],  # Deep Purple
    ["#1A237E", "#9FA8DA"],  # Indigo
    ["#006064", "#80DEEA"],  # Cyan
    ["#33691E", "#C5E1A5"],  # Light Green
    ["#827717", "#E6EE9C"],  # Lime
    ["#FF6F00", "#FFE082"],  # Amber
    ["#BF360C", "#FFAB91"],  # Deep Orange
]
for layer_colors in palettes:
    CPAL_palette = []
    for color in layer_colors:
        (r, g, b, a) = hex_to_rgba(color)
        CPAL_palette.append((r / 255.0, g / 255.0, b / 255.0, a / 255.0))
    CPAL_palettes.append(CPAL_palette)

font.lib[ufo2ft.constants.COLOR_PALETTES_KEY] = CPAL_palettes
font.info.familyName = "Cocalata Color"

font.save(sys.argv[2], overwrite=True)
log.info(f"Color UFO font saved at {sys.argv[2]}")
