#!/usr/bin/make -f

# Safer shell and make defaults
SHELL := /usr/bin/env bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.DEFAULT_GOAL := build

# Configurable variables (can be overridden by env/CLI)
FAMILY ?= Cocolata
PY ?= uv run
SOURCEDIR ?= sources
FONTSDIR ?= fonts
PROOFDIR ?= proofs
TESTSDIR ?= tests
UFODIR ?= $(SOURCEDIR)/ufo
INSTALLDIR ?= $(HOME)/.local/share/fonts/$(FAMILY)

# Read styles from config
STYLES := $(shell $(PY) tools/read_config.py styles)

# Derived paths
UFO := $(STYLES:%=$(UFODIR)/$(FAMILY)-%.ufo)
TTF_INSTANCES := $(STYLES:%=$(FONTSDIR)/ttf/$(FAMILY)-%.ttf)
OTF_INSTANCES := $(STYLES:%=$(FONTSDIR)/otf/$(FAMILY)-%.otf)
WEBFONTS := $(FONTSDIR)/webfonts/$(FAMILY)-VF.woff2

# Shared options
FONTMAKE_WARN := --verbose WARNING
DECOMP_FLATTEN := --filter DecomposeTransformedComponentsFilter --flatten-components
PATHOPS := --overlaps-backend pathops
CFF1 := --optimize-cff 1
CFF2 := --optimize-cff 2

.PHONY: help build dev glyphs ufo clean proofs test install release interpolation-test metrics-report $(STYLES)

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make [target]\n\nTargets:\n"} /^[a-zA-Z0-9][^:]*:.*##/ {printf "  %-28s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ufo $(FAMILY) ## Build master UFOs and all font outputs

# Recursively watch the file changes and build SVGs (design workflow)
# Requires: inotify-tools (Linux)
dev: ## Watch glyph sources and rebuild
	while inotifywait -e MODIFY $(SOURCEDIR)/glyphs/; do $(MAKE) -C $(SOURCEDIR); done;

# Targets for preparing the glyphs from sources (per-style)
glyphs: $(STYLES) ## Generate per-style SVGs

$(STYLES): ## Generate SVGs for a style variant
	@mkdir -p $(SOURCEDIR)/svgs/$@
	VARIANT=$@ $(MAKE) -C $(SOURCEDIR)

# Build master UFOs from SVG sources
$(UFODIR)/$(FAMILY)-%.ufo: % | $(UFODIR)
	@echo " BUILD UFO  $(@F)"
	mkdir -p $(@D)
	$(PY) tools/builder.py --style $* --source $(SOURCEDIR)/svgs/$* --output $@
	$(PY) ufonormalizer -q -m $@

ufo: glyphs $(UFO) ## Build all master UFOs

# Color pipeline (v0 -> v1)
$(FONTSDIR)/$(FAMILY)-color.ufo: $(UFODIR)/$(FAMILY)-Regular.ufo | $(FONTSDIR)
	@echo " BUILD UFO  $(@F)"
	$(PY) tools/build_color_v0.py $< $@
	$(PY) ufonormalizer -q -m $@

$(FONTSDIR)/$(FAMILY)-color.otf: $(FONTSDIR)/$(FAMILY)-color.ufo | $(FONTSDIR)
	@echo " BUILD Color v0 font OTF  $(@F)"
	$(PY) fontmake $< \
		--output-dir $(FONTSDIR) \
		$(DECOMP_FLATTEN) \
		$(CFF2) \
		$(PATHOPS) \
		--output otf \
		$(FONTMAKE_WARN)

$(FONTSDIR)/$(FAMILY)-colrv1.otf: $(FONTSDIR)/$(FAMILY)-color.otf | $(FONTSDIR)
	@echo " BUILD Color v1 font OTF  $(@F)"
	$(PY) tools/build_color_v1.py $< $@

# Meta target building all deliverables
$(FAMILY): $(FONTSDIR)/otf \
	$(FONTSDIR)/ttf \
	$(FONTSDIR)/ttf-variable \
	$(FONTSDIR)/otf-variable \
	$(FONTSDIR)/ufo \
	$(WEBFONTS) ## Build all formats

# Create TTF instances (requires designspace)
$(FONTSDIR)/ttf: $(FAMILY).designspace | $(FONTSDIR)
	$(PY) fontmake --mm-designspace $< \
		$(DECOMP_FLATTEN) \
		--interpolate \
		$(FONTMAKE_WARN) \
		--output-dir $@ \
		--output ttf \
		--optimize-cff 0
	$(PY) tools/fix_font.py $@/*.ttf

# Create OTF instances (requires designspace)
$(FONTSDIR)/otf: $(FAMILY).designspace | $(FONTSDIR)
	$(PY) fontmake --mm-designspace $< \
		$(FONTMAKE_WARN) \
		$(DECOMP_FLATTEN) \
		--interpolate \
		$(CFF1) \
		--output-dir $@ \
		--output otf
	$(PY) tools/fix_font.py $@/*.otf

# Create TTF variable font (requires designspace)
$(FONTSDIR)/ttf-variable: ufo $(FAMILY).designspace | $(FONTSDIR)
	$(PY) fontmake --mm-designspace $(FAMILY).designspace \
		$(DECOMP_FLATTEN) \
		--flatten-components \
		$(PATHOPS) \
		$(FONTMAKE_WARN) \
		--output-dir $@ \
		--output variable
	$(PY) tools/fix_font.py $@/*.ttf
	$(PY) tools/stat.py $(FAMILY) $@/*.ttf

# Create OTF variable font (requires designspace)
$(FONTSDIR)/otf-variable: ufo $(FAMILY).designspace | $(FONTSDIR)
	$(PY) fontmake --mm-designspace $(FAMILY).designspace \
		$(DECOMP_FLATTEN) \
		--flatten-components \
		$(PATHOPS) \
		--output-dir $@ \
		$(FONTMAKE_WARN) \
		$(CFF1) \
		--output variable-cff2
	$(PY) tools/fix_font.py $@/*.otf
	$(PY) tools/stat.py $(FAMILY) $@/*.otf

# Package the master UFOs into fonts directory (copy master sources)
$(FONTSDIR)/ufo: $(UFODIR) | $(FONTSDIR)
	mkdir -p $@
	cp -r $(UFODIR)/ $@/

# Create WOFF2 webfont from variable OTF (single VF file)
$(WEBFONTS): $(FONTSDIR)/otf-variable/$(FAMILY)-VF.otf | $(FONTSDIR)/webfonts
	$(PY) python -m fontTools.ttLib.woff2 compress -o $@ $<

clean: ## Remove build artifacts
	@find . -name '__pycache__' -type d -prune -exec rm -rf {} +
	@find . -iname "*.pyc" -delete
	@rm -rf $(FONTSDIR) $(PROOFDIR)
	@rm -rf $(SOURCEDIR)/svgs/*/*.svg

proofs: $(FONTSDIR)/otf | $(PROOFDIR) ## Generate PDF proofs with HarfBuzz
	hb-view $(FONTSDIR)/otf/$(FAMILY)-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--text-file $(TESTSDIR)/ligatures.txt \
		--output-file $(PROOFDIR)/ligatures.pdf;
	hb-view $(FONTSDIR)/otf/$(FAMILY)-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--text-file $(TESTSDIR)/content.txt \
		--output-file $(PROOFDIR)/content.pdf;

	hb-view $(FONTSDIR)/otf/$(FAMILY)-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--text-file $(TESTSDIR)/kerning.txt \
		--output-file $(PROOFDIR)/kerning.pdf ;
	cat $(TESTSDIR)/paragraphs.english.txt | fold -sw 80 | hb-view $(FONTSDIR)/otf/$(FAMILY)-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--output-file $(PROOFDIR)/paragraphs.english.pdf ;

# Test (depends on proofs to ensure outputs exist)
test: proofs ## Run fontbakery checks
	# fontbakery check-fontval $(FONTSDIR)/$(FAMILY)-Regular.ttf <- enable when upstream is fixed
	# fontbakery check-ufo-sources $(SOURCEDIR)/ufo/$(FAMILY)-Regular.ufo
	$(PY) fontbakery check-opentype $(FONTSDIR)/otf-variable/$(FAMILY)-VF.otf
	$(PY) fontbakery check-googlefonts --full-lists --config fontbakery.yaml --html tests/fontbakery-report.html --ghmarkdown tests/fontbakery-report.md $(FONTSDIR)/ttf-variable/$(FAMILY)-VF.ttf

install: $(FONTSDIR)/otf ## Install OTFs to user fonts dir
	@mkdir -p $(INSTALLDIR);
	@cp $(FONTSDIR)/otf/*.otf $(INSTALLDIR);
	@fc-cache -fr

# Vertical Metrics Reporting
metrics-report: ## Report vertical metrics
	# May need `pip install font-line` to install font-line
	$(PY) font-line report $(FONTSDIR)/otf-variable/*.otf

interpolation-test: ufo ## Check interpolation compatibility and output a PDF report
	$(PY) fonttools varLib.interpolatable --pdf report.pdf $(FAMILY).designspace

# Release packaging
VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null || echo 0.0.0)
release: build ## Create release archives
	@echo "Creating release for version $(VERSION)"
	# Tar files - $(FAMILY)
	tar czvf $(FONTSDIR)-$(VERSION).tar.gz *.conf OFL.txt README.md $(FONTSDIR)
	sha256sum $(FONTSDIR)-$(VERSION).tar.gz > $(FONTSDIR)-$(VERSION).tar.gz.sha256
	md5sum $(FONTSDIR)-$(VERSION).tar.gz > $(FONTSDIR)-$(VERSION).tar.gz.md5
	# Zip files
	zip -r $(FONTSDIR)-$(VERSION).zip README.md OFL.txt $(FONTSDIR)
	sha256sum $(FONTSDIR)-$(VERSION).zip > $(FONTSDIR)-$(VERSION).zip.sha256
	md5sum $(FONTSDIR)-$(VERSION).zip > $(FONTSDIR)-$(VERSION).zip.md5

# Directory targets
$(UFODIR) $(FONTSDIR) $(PROOFDIR) $(FONTSDIR)/webfonts:
	mkdir -p $@
