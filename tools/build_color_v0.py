import logging
from math import pi
import sys
from operator import itemgetter
from fontTools.ttLib import getTableModule
import ufo2ft
from ufoLib2.objects import Font
from ufoLib2.objects import Glyph
from ufoLib2.objects import Component

from svgglyph import SVGGlyph

log = logging.getLogger(__name__)


def hex_to_rgba(hex: str):
    return getTableModule("CPAL").Color.fromHex(hex)


layer_mapping = []
CPAL_palettes = []
layer_mapping.append(["public.default", 0])
# layer_mapping.append(["ink", 1])
font = Font().open(sys.argv[1])
# layer: Layer = font.newLayer(name="ink")
layer = font.layers.get("public.default")
# mask_glyph = SVGGlyph("./tools/ink_mask.svg")
samples = 5
for i in range(samples):
    mask_glyph = SVGGlyph(f"./tools/ink_mask_{i}.svg")
    mask_glyph.parse()
    layer.insertGlyph(mask_glyph.glif, f"ink_mask_{i}")

layer_mapping = sorted(layer_mapping, key=itemgetter(1))
font.lib[ufo2ft.constants.COLOR_LAYER_MAPPING_KEY] = layer_mapping

palettes = [
    ["#E65100", "#FFCC80"],  # Orange
    ["#212121", "#EEEEEE"],  # Gray
    ["#263238", "#B0BEC5"],  # Blue Gray
    ["#F57F17", "#FFF59D"],  # Yellow
    ["#1B5E20", "#A5D6A7"],  # Green
    ["#01579B", "#81D4FA"],  # Light Blue
    ["#0D47A1", "#4000FF"],  # Blue
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
