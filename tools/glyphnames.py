import unicodedata
from functools import lru_cache
from fontTools import agl

# Extra Adobe Glyph List mappings not in fontTools
AGL2UV_EXTRA = {
    "onesuperior": 0x00B9,
    "twosuperior": 0x00B2,
    "threesuperior": 0x00B3,
    "foursuperior": 0x2074,
    "quotedblbasereversed": 0x2E42,
    "Acaron": 0x01CD,
    "acaron": 0x01CE,
    "Lcedilla": 0x013B,
    "lcedilla": 0x013C,
    "Kcedilla": 0x0136,
    "kcedilla": 0x0137,
    "Ncedilla": 0x0145,
    "Gcedilla": 0x0122,
    "gcedilla": 0x0123,
    "ncedilla": 0x0146,
    "Rcedilla": 0x0156,
    "rcedilla": 0x0157,
    "ringcmb": 0x030A,
    "tildecmb": 0x0303,
    "hungarumlautcmb": 0x030B,
    "cedillacmb": 0x0327,
    "acutecmb": 0x0301,
    "ogonekcmb": 0x0328,
    "dieresiscmb": 0x0308,
    "dotaccentcmb": 0x0307,
    "circumflexcmb": 0x0302,
    "commaturnedabovecmb": 0x0312,
    "caroncmb": 0x030C,
    "brevecmb": 0x0306,
    "macroncmb": 0x0304,
    "gravecmb": 0x0300,
    "commaturnedmod": 0x02BB,
    "commaaccent": 0x0326,
    "scommaaccent": 0x0219,
    "Scommaaccent": 0x0218,
    "Tcommaaccent": 0x021A,
    "tcommaaccent": 0x021B,
    "dotlessj": 0x0237,
    "jcaron": 0x01F0,
    "notdef": 0,
    "uni25CC": 0x25CC,
}

UV2AGL_EXTRA = {
    0x0326: "commaaccent",
    0x0328: "ogonekcmb",
}

# Chillu normalization map at module level
CHILLU_NORMALIZE_MAP = {
    "ന്\u200d": "ൻ",
    "ര്\u200d": "ർ",
    "ല്\u200d": "ൽ",
    "ള്\u200d": "ൾ",
    "ണ്\u200d": "ൺ",
    "ഴ്\u200d": "ൖ",
    "ക്\u200d": "ൿ",
}


def initialize_agl_mappings():
    """Initialize Adobe Glyph List mappings with extra values"""
    agl.AGL2UV.update(AGL2UV_EXTRA)
    agl.UV2AGL.update(UV2AGL_EXTRA)


# Initialize mappings at module import
initialize_agl_mappings()


@lru_cache(maxsize=1024)
def name_from_uc(char: str) -> str:
    """
    Convert a Malayalam Unicode character to a descriptive name.

    Args:
        char: Single Unicode character

    Returns:
        Descriptive name with underscores (e.g., "sign_virama")
    """
    return (
        unicodedata.name(char)
        .replace("MALAYALAM SIGN", "")
        .replace("MALAYALAM", "")
        .replace("LETTER", "")
        .replace("VOWEL", "")
        .lower()
        .strip()
        .replace(" ", "_", -1)
        .replace("-", "_")
    )


@lru_cache(maxsize=2048)
def get_glyph_name(name: str, prefix: str = "ml_") -> str:
    """
    Generate a glyph name from a character or string.

    Args:
        name: Character, string, or glyph name
        prefix: Prefix for Malayalam glyphs (default: "ml_")

    Returns:
        Glyph name suitable for use in font

    Examples:
        >>> get_glyph_name("A")
        'A'
        >>> get_glyph_name("ക")
        'ml_ka'
        >>> get_glyph_name("ക്ക")
        'ml_ka_virama_ka'
    """
    name_parts = name.split("_")
    base_name = name_parts[0]
    ext = "_" + "_".join(name_parts[1:]) if len(name_parts) > 1 else ""

    if not base_name:
        return name

    codepoint = ord(base_name[0])

    # Special cases
    if codepoint == 8205:
        return "zwj"

    if base_name == "notdef":
        return ".notdef"

    # Malayalam Unicode range (U+0D00 to U+0D7F)
    if 3328 <= codepoint <= 3455:
        if len(base_name) > 1:
            # Normalize chillu characters
            normalized_name = CHILLU_NORMALIZE_MAP.get(base_name, base_name)
            return prefix + "_".join(name_from_uc(c) for c in normalized_name) + ext
        else:
            return prefix + name_from_uc(base_name) + ext

    # Single character - use Adobe Glyph List or uni name
    if len(base_name) == 1:
        glyph_name = agl.UV2AGL.get(codepoint)
        if glyph_name is None:
            glyph_name = f"uni{hex(codepoint).replace('0x', '').upper()}"
        return glyph_name + ext

    # Multi-character or already a glyph name
    return agl.UV2AGL.get(base_name, base_name) + ext


def parse_glyph_filename(filename: str) -> dict:
    """
    Parse a glyph filename to extract metadata.

    Args:
        filename: Filename without extension (e.g., "ka.alt1")

    Returns:
        Dictionary with keys: name, alt, onum, sups, variant

    Examples:
        >>> parse_glyph_filename("ka")
        {'name': 'ka', 'alt': None, 'onum': None, 'sups': None, 'variant': None}
        >>> parse_glyph_filename("ka.alt1")
        {'name': 'ka', 'alt': 'alt1', 'onum': None, 'sups': None, 'variant': 'alt1'}
    """
    parts = filename.split(".")
    result = {
        "name": parts[0],
        "alt": None,
        "onum": None,
        "sups": None,
        "variant": None,
    }

    if len(parts) > 1:
        variant = parts[1]
        alt_suffixes = ["alt", "wide", "narrow", "alt1", "alt2", "alt3"]

        if variant in alt_suffixes:
            result["alt"] = variant
            result["variant"] = variant
        elif variant == "oldnum":
            result["onum"] = variant
            result["variant"] = variant
        elif variant == "sups":
            result["sups"] = variant
            result["variant"] = variant

    return result


def get_unicode_for_name(name: str, has_variant: bool = False) -> list[int] | None:
    """
    Get Unicode codepoint(s) for a glyph name.

    Args:
        name: Character or glyph name
        has_variant: Whether this is a variant glyph (alt, onum, sups)

    Returns:
        List of Unicode codepoints, or None if not applicable

    Examples:
        >>> get_unicode_for_name("A")
        [65]
        >>> get_unicode_for_name("A", has_variant=True)
        None
        >>> get_unicode_for_name("Agrave")
        [192]
    """
    # Variant glyphs don't get Unicode values
    if has_variant:
        return None

    # Single character
    if len(name) == 1:
        return [ord(name)]

    # Check Adobe Glyph List
    if name in agl.AGL2UV:
        return [agl.AGL2UV.get(name)]

    return None
