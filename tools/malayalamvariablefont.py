import logging
import os
from typing import Dict, List

from jinja2 import Environment, FileSystemLoader
from malayalamfeatures import MalayalamFeatures
from malayalamfont import MalayalamFont

log = logging.getLogger(__name__)


class MalayalamVariableFont:
    def __init__(self, options, weights=None):
        """
        Initialize MalayalamVariableFont

        Args:
            options: Font configuration options
            weights: List of weight values
                (default: [100, 200, 300, 400, 500, 600, 700, 800, 900])
        """
        self.options = options
        if weights is None:
            self.weights = [100, 200, 300, 400, 500, 600, 700, 800, 900]
        else:
            self.weights = weights

        self.master_fonts: Dict[int, MalayalamFont] = {}
        self.feature_data_by_weight: Dict[int, dict] = {}

        # Weight to style name mapping
        self.weight_to_style = {
            100: "Thin",
            200: "ExtraLight",
            300: "Light",
            400: "Regular",
            500: "Medium",
            600: "SemiBold",
            700: "Bold",
            800: "ExtraBold",
            900: "Black",
        }

    def build_masters(self, design_dirs: Dict[int, str], output_dir: str):
        """
        Build all master UFO fonts for each weight

        Args:
            source_dirs: Dictionary mapping weight to source directory
            output_dir: Base directory for UFO output
        """
        log.info("Building master fonts for variable font...")

        for weight in self.weights:
            style = self.weight_to_style.get(weight, "Regular")
            log.info(f"Building master for weight {weight} ({style})...")

            # Create MalayalamFont instance
            font = MalayalamFont(self.options, style=style, weight=weight)

            # Build the font glyphs
            if weight in design_dirs:
                design_dir = design_dirs[weight]
            else:
                log.warning(
                    f"No source directory specified for weight {weight}, skipping"
                )
                continue

            font.build(design_dir)
            font.setFontInfo()
            font.updateFontVersion()
            font.setGlyphList()
            font.build_glyph_groups()

            # Save the master UFO
            output_path = os.path.join(output_dir, f"{self.options.name}-{style}.ufo")
            font.save(output_path, overwrite=True)

            # Store the font instance
            self.master_fonts[weight] = font

        self.write_features(output_dir="sources/ufo/")

    def collect_feature_data(self):
        """Collect feature template data from all master fonts"""
        log.info("Collecting feature data from all masters...")

        for weight, font in self.master_fonts.items():
            ml_features = MalayalamFeatures(font, self.options)
            self.feature_data_by_weight[weight] = ml_features.prepare_template_data()

    def _merge_top_anchors(
        self, anchors_by_weight: Dict[int, List[dict]]
    ) -> List[dict]:
        """
        Merge top anchor data across all weights

        Args:
            anchors_by_weight: Dictionary mapping weight to list of anchor data

        Returns:
            List of merged anchor data with variable anchor positions
        """
        # Group anchors by their base glyphs and class_name
        anchor_groups = {}

        for weight, anchors in anchors_by_weight.items():
            for anchor in anchors:
                # Create a key based on bases and class_name
                bases_key = tuple(sorted(anchor["bases"]))
                class_name = anchor["class_name"]
                key = (bases_key, class_name)

                if key not in anchor_groups:
                    anchor_groups[key] = {
                        "bases": anchor["bases"],
                        "class_name": class_name,
                        "positions": {},
                    }

                anchor_groups[key]["positions"][weight] = (anchor["x"], anchor["y"])

        # Convert to merged format
        merged_anchors = []
        for (bases_key, class_name), data in anchor_groups.items():
            # Format variable anchor
            x_values = {w: pos[0] for w, pos in data["positions"].items()}
            y_values = {w: pos[1] for w, pos in data["positions"].items()}

            merged_anchors.append(
                {
                    "bases": data["bases"],
                    "class_name": class_name,
                    "anchor": self._format_variable_anchor(x_values, y_values),
                }
            )

        return merged_anchors

    def _merge_bottom_anchors(
        self, anchors_by_weight: Dict[int, List[dict]]
    ) -> List[dict]:
        """
        Merge bottom anchor data across all weights

        Args:
            anchors_by_weight: Dictionary mapping weight to list of anchor data

        Returns:
            List of merged anchor data with variable anchor positions
        """
        # Group anchors by their base glyphs and class_name
        anchor_groups = {}

        for weight, anchors in anchors_by_weight.items():
            for anchor in anchors:
                # Create a key based on bases and class_name
                bases_key = tuple(sorted(anchor["bases"]))
                class_name = anchor["class_name"]
                key = (bases_key, class_name)

                if key not in anchor_groups:
                    anchor_groups[key] = {
                        "bases": anchor["bases"],
                        "class_name": class_name,
                        "positions": {},
                    }

                anchor_groups[key]["positions"][weight] = (anchor["x"], anchor["y"])

        # Convert to merged format
        merged_anchors = []
        for (bases_key, class_name), data in anchor_groups.items():
            # Format variable anchor
            x_values = {w: pos[0] for w, pos in data["positions"].items()}
            y_values = {w: pos[1] for w, pos in data["positions"].items()}

            merged_anchors.append(
                {
                    "bases": data["bases"],
                    "class_name": class_name,
                    "anchor": self._format_variable_anchor(x_values, y_values),
                }
            )

        return merged_anchors

    def _format_variable_anchor(
        self, x_values: Dict[int, int], y_values: Dict[int, int]
    ) -> str:
        """
        Format anchor positions for variable font

        Args:
            x_values: Dictionary mapping weight to x coordinate
            y_values: Dictionary mapping weight to y coordinate

        Returns:
            Formatted anchor string like "<anchor 100:9 400:10 700:10.6 100:19 400:20 700:20.6>"
        """
        # Sort by weight
        sorted_weights = sorted(x_values.keys())

        # Build x coordinates part
        x_parts = [f"wght={weight}.0:{x_values[weight]}" for weight in sorted_weights]

        # Build y coordinates part
        y_parts = [f"wght={weight}.0:{y_values[weight]}" for weight in sorted_weights]

        # Combine
        all_parts = x_parts + y_parts

        return "<anchor (" + " ".join(x_parts) + ") (" + " ".join(y_parts) + ")>"

    def merge_gpos_data(self, feature_data_by_weight: Dict[int, dict]) -> dict:
        """
        Merge GPOS data (anchors) across all weights

        Args:
            feature_data_by_weight: Dictionary mapping weight to feature template data

        Returns:
            Dictionary with merged GPOS data
        """
        log.info("Merging GPOS anchor data across weights...")

        # Collect top anchors by weight
        top_anchors_by_weight = {
            weight: data["top_anchors"]
            for weight, data in feature_data_by_weight.items()
        }

        # Collect bottom anchors by weight
        bottom_anchors_by_weight = {
            weight: data["bottom_anchors"]
            for weight, data in feature_data_by_weight.items()
        }

        # Merge anchors
        merged_top_anchors = self._merge_top_anchors(top_anchors_by_weight)
        merged_bottom_anchors = self._merge_bottom_anchors(bottom_anchors_by_weight)

        return {
            "top_anchors": merged_top_anchors,
            "bottom_anchors": merged_bottom_anchors,
        }

    def prepare_variable_template_data(self) -> dict:
        """
        Prepare template data for variable font features

        Uses Regular (400) weight for non-GPOS features
        and merged data for GPOS

        Returns:
            Dictionary with complete template data
        """
        log.info("Preparing variable font template data...")

        # Use Regular weight (400) as base for non-GPOS features
        base_weight = 400
        if base_weight not in self.feature_data_by_weight:
            # Fallback to first available weight
            base_weight = sorted(self.feature_data_by_weight.keys())[0]
            log.warning(
                f"Regular weight (400) not found, using weight {base_weight} as base"
            )

        base_data = self.feature_data_by_weight[base_weight].copy()

        # Merge GPOS data
        merged_gpos = self.merge_gpos_data(self.feature_data_by_weight)

        # Replace GPOS data with merged versions
        base_data["top_anchors"] = merged_gpos["top_anchors"]
        base_data["bottom_anchors"] = merged_gpos["bottom_anchors"]

        return base_data

    def write_features(self, output_dir: str):
        """
        Write feature file for variable font - write same feature file to all masters

        Args:
            output_dir: Base directory where UFO files are located
        """

        # Collect feature data from all masters
        self.collect_feature_data()

        # Prepare merged template data
        template_data = self.prepare_variable_template_data()

        # Set up Jinja2 environment with custom template for variable fonts
        template_dir = os.path.join(
            os.path.dirname(__file__), "..", "sources", "features"
        )
        env = Environment(
            loader=FileSystemLoader(template_dir), trim_blocks=True, lstrip_blocks=True
        )

        # Use a variable font specific template or the same template
        # For now, we'll use the same template but with variable anchors
        template = env.get_template("features.fea.j2")
        features_code = template.render(**template_data)

        # Write this to feature file to each Master UFO directory
        for weight in self.weights:
            style = self.weight_to_style.get(weight, "Regular")
            ufo_dir = os.path.join(output_dir, f"{self.options.name}-{style}.ufo")
            output_path = os.path.join(ufo_dir, "features.fea")

            with open(output_path, "w", encoding="utf-8") as f:
                f.write(features_code)
