import argparse
import logging
import os
import sys

import yaml
from malayalamvariablefont import MalayalamVariableFont
from munch import DefaultMunch

log = logging.getLogger(__name__)


def dir_path(path):
    if os.path.isdir(path):
        return path
    else:
        raise argparse.ArgumentTypeError(f"readable_dir:{path} is not a valid path")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Build a UFO formatted font", add_help=True
    )
    parser.add_argument(
        "-c",
        "--config",
        help="The font information and configuraion",
        default="config.yaml",
        type=argparse.FileType("r"),
    )
    parser.add_argument("-s", "--source", help="SVG sources", type=dir_path)
    parser.add_argument("-o", "--output", help="Output UFO File")
    parser.add_argument(
        "-l", "--log-level", default="INFO", required=False, help="Set log level"
    )

    options = parser.parse_args()
    try:
        logging.basicConfig(level=options.log_level)
    except ValueError:
        logging.error("Invalid log level: {}".format(options.log_level))
        sys.exit(1)

    design_dirs = {
        100: "sources/svgs/Thin",
        200: "sources/svgs/ExtraLight",
        300: "sources/svgs/Light",
        400: "sources/svgs/Regular",
        500: "sources/svgs/Medium",
        600: "sources/svgs/SemiBold",
        700: "sources/svgs/Bold",
        800: "sources/svgs/ExtraBold",
        900: "sources/svgs/Black",
    }
    config = DefaultMunch.fromDict(yaml.load(options.config, Loader=yaml.FullLoader))
    font = MalayalamVariableFont(config, weights=design_dirs.keys())
    font.build_masters(design_dirs=design_dirs, output_dir="sources/ufo/")
