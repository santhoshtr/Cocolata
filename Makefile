#!/usr/bin/make -f

# Safer shell and make defaults
SHELL := /usr/bin/env bash
.SHELLFLAGS := -eu -o pipefail -c
#MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.DEFAULT_GOAL := build

# Configurable variables (can be overridden by env/CLI)
FAMILY ?= Cocolata
SOURCEDIR ?= sources
FONTSDIR ?= fonts
PROOFDIR ?= proofs
TESTSDIR ?= tests
UFODIR ?= $(SOURCEDIR)/ufo
INSTALLDIR ?= $(HOME)/.local/share/fonts/$(FAMILY)

# The compiled Rust font tool, built by the `init` target
BIN := target/release/$(FAMILY)

# Read styles from config (build the tool first if it is missing)
STYLES := $(shell test -x $(BIN) || cargo build --release --quiet; $(BIN) styles)

# Derived paths
UFO := $(STYLES:%=$(UFODIR)/$(FAMILY)-%.ufo)

.PHONY: help init build dev glyphs ufo clean proofs test install release metrics-report $(STYLES)

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make [target]\n\nTargets:\n"} /^[a-zA-Z0-9][^:]*:.*##/ {printf "  %-28s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: $(BIN) ## Build the Rust font tool

$(BIN): $(wildcard src/*.rs) Cargo.toml Cargo.lock
	cargo build --release

build: ufo $(FAMILY) ## Build master UFOs and all font outputs

# Recursively watch the file changes and build SVGs (design workflow)
# Requires: inotify-tools (Linux)
dev: ## Watch glyph sources and rebuild
	while inotifywait -e MODIFY $(SOURCEDIR)/glyphs/; do $(MAKE) -j ufo STYLES="$(STYLES) debug"; done;

# Targets for preparing the glyphs from sources (per-style)
glyphs: $(STYLES) ## Generate per-style SVGs

$(STYLES): ## Generate SVGs for a style variant
	@mkdir -p $(SOURCEDIR)/svgs/$@
	VARIANT=$@ $(MAKE) -C $(SOURCEDIR)

ufo: $(UFO) ## Build all master UFOs

# Grouped target: one builder run produces every master UFO. Gives the
# variable-TTF rule a real dependency edge so parallel builds order
# correctly (a phony ufo target alone breaks under -j).
$(UFO) &: glyphs $(BIN)
	$(BIN) build --designspace $(FAMILY).designspace

# Meta target building all deliverables
$(FAMILY): ufo $(FONTSDIR)/$(FAMILY)-variable.ttf  $(FONTSDIR)/$(FAMILY)-variable.woff2

# Create TTF variable font (requires designspace and master UFOs)
$(FONTSDIR)/$(FAMILY)-variable.ttf: $(FAMILY).designspace $(UFO) | $(FONTSDIR) $(BIN)
	fontc -o $@ $(FAMILY).designspace
	$(BIN) postprocess $@

# Package the master UFOs into fonts directory (copy master sources)
$(FONTSDIR)/ufo: $(UFODIR) | $(FONTSDIR)
	mkdir -p $@
	cp -r $(UFODIR)/ $@/

# Create WOFF2 webfont from variable TTF (single VF file)
$(FONTSDIR)/$(FAMILY)-variable.woff2: $(FONTSDIR)/$(FAMILY)-variable.ttf | $(FONTSDIR) $(BIN)
	$(BIN) woff2 $(FONTSDIR)/$(FAMILY)-variable.ttf $@

clean: ## Remove build artifacts
	@cargo clean
	@rm -rf $(FONTSDIR) $(PROOFDIR)
	@rm -rf $(SOURCEDIR)/svgs/*/*.svg

proofs: $(FONTSDIR)/$(FAMILY)-variable.ttf ## Generate PDF proofs with HarfBuzz
	@mkdir -p $(PROOFDIR)
	hb-view $(FONTSDIR)/$(FAMILY)-variable.ttf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--text-file $(TESTSDIR)/content.txt \
		--output-file $(PROOFDIR)/content.pdf;

	cat $(TESTSDIR)/paragraphs.english.txt | fold -sw 80 | hb-view $(FONTSDIR)/$(FAMILY)-variable.ttf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--output-file $(PROOFDIR)/paragraphs.english.pdf ;

# Test (depends on proofs to ensure outputs exist)
# Requires the fontspector binary on PATH (see https://github.com/fonttools/fontspector).
test: proofs ## Run fontspector checks
	ots-sanitize $(FONTSDIR)/$(FAMILY)-variable.ttf
	fontspector --profile googlefonts --full-lists \
		--configuration fontspector.toml \
		--html $(TESTSDIR)/fontspector-report.html \
		--ghmarkdown $(TESTSDIR)/fontspector-report.md \
		$(FONTSDIR)/$(FAMILY)-variable.ttf

install: $(FAMILY)
	@mkdir -p $(INSTALLDIR);
	@cp $(FONTSDIR)/*.ttf $(INSTALLDIR);
	@fc-cache -fr

# Vertical Metrics Reporting
metrics-report: $(BIN) ## Report vertical metrics
	$(BIN) report $(FONTSDIR)/$(FAMILY)-variable.ttf

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
$(UFODIR) $(FONTSDIR) $(FONTSDIR)/webfonts:
	mkdir -p $@
