#!/usr/bin/make -f

# Safer shell and make defaults
SHELL := /usr/bin/env bash
.SHELLFLAGS := -eu -o pipefail -c
#MAKEFLAGS += --warn-undefined-variables
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

.PHONY: help build dev glyphs ufo clean proofs test install release metrics-report $(STYLES)

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

ufo: glyphs $(UFO) ## Build all master UFOs

# Meta target building all deliverables
$(FAMILY): ufo $(FONTSDIR)/$(FAMILY)-variable.ttf  $(FONTSDIR)/$(FAMILY)-variable.woff2

# Create TTF variable font (requires designspace)
$(FONTSDIR)/$(FAMILY)-variable.ttf: $(FAMILY).designspace | $(FONTSDIR)
	cargo run --  --designspace $(FAMILY).designspace
	fontc -o $@ $(FAMILY).designspace
	$(PY) tools/fix_font.py $@
	$(PY) tools/stat.py $(FAMILY) $@

# Package the master UFOs into fonts directory (copy master sources)
$(FONTSDIR)/ufo: $(UFODIR) | $(FONTSDIR)
	mkdir -p $@
	cp -r $(UFODIR)/ $@/

# Create WOFF2 webfont from variable OTF (single VF file)
$(FONTSDIR)/$(FAMILY)-variable.woff2: $(FAMILY).designspace | $(FONTSDIR)
	$(PY) python -m fontTools.ttLib.woff2 compress -o $@ $(FONTSDIR)/$(FAMILY)-variable.ttf

clean: ## Remove build artifacts
	@find . -name '__pycache__' -type d -prune -exec rm -rf {} +
	@find . -iname "*.pyc" -delete
	@rm -rf $(FONTSDIR) $(PROOFDIR)
	@rm -rf $(SOURCEDIR)/svgs/*/*.svg

proofs: $(FONTSDIR)/ttf | $(PROOFDIR) ## Generate PDF proofs with HarfBuzz
	hb-view $(FONTSDIR)/ttf/$(FAMILY)-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--text-file $(TESTSDIR)/ligatures.txt \
		--output-file $(PROOFDIR)/ligatures.pdf;
	hb-view $(FONTSDIR)/otf/$(FAMILY)-Regular.ttf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--text-file $(TESTSDIR)/content.txt \
		--output-file $(PROOFDIR)/content.pdf;

	hb-view $(FONTSDIR)/otf/$(FAMILY)-Regular.ttf \
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
	$(PY) fontbakery check-opentype $(FONTSDIR)/otf-variable/$(FAMILY)-VF.ttf
	$(PY) fontbakery check-googlefonts --full-lists --config fontbakery.yaml --html tests/fontbakery-report.html --ghmarkdown tests/fontbakery-report.md $(FONTSDIR)/ttf-variable/$(FAMILY)-VF.ttf

install: $(FAMILY)
	@mkdir -p $(INSTALLDIR);
	@cp $(FONTSDIR)/*.ttf $(INSTALLDIR);
	@fc-cache -fr

# Vertical Metrics Reporting
metrics-report: ## Report vertical metrics
	# May need `pip install font-line` to install font-line
	$(PY) font-line report $(FONTSDIR)/ttf-variable/*.ttf

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
