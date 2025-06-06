#!/usr/bin/make -f
SHELL:=/bin/bash
FAMILY=Kanchana
STYLES=$(shell uv run tools/read_config.py styles)
SOURCEDIR=sources
FONTSDIR=fonts
PROOFDIR=proofs
TESTSDIR=tests
TTFDIR=${FONTSDIR}/ttf
OTFDIR=${FONTSDIR}/otf
WEBFONTSDIR=${FONTSDIR}/webfonts
UFODIR=${SOURCEDIR}/ufo
INSTALLDIR=~/.fonts/$(FAMILY)

UFO=$(STYLES:%=$(UFODIR)/$(FAMILY)-%.ufo)
TTF=$(STYLES:%=$(FONTSDIR)/$(FAMILY)-%.ttf)
OTF=$(STYLES:%=$(FONTSDIR)/$(FAMILY)-%.otf)
WEBFONTS=$(STYLES:%=$(FONTSDIR)/$(FAMILY)-%.woff2)

.PHONY: $(STYLES) ufo clean glyphs build proofs autobuild


default: build

help:
	@echo "Build targets"
	@echo
	@echo " make build: Builds the fonts and places them in the fonts/ directory"
	@echo " make test:  Tests the fonts with fontbakery"
	@echo " make proof: Creates HTML proof documents in the proof/ directory"
	@echo

build: ufo Kanchana
# Recursively watch the file changes and make the (debug) svgs.
# Useful in design workflow.
# Package inotify-tools are available in linux distros
dev:
	while inotifywait -e MODIFY $(SOURCEDIR)/glyphs/; do $(MAKE) -C $(SOURCEDIR); done;

# Targets for preparing the glyphs from metapost and preparing master UFOs.
glyphs: $(STYLES)

$(STYLES):
	@mkdir -p $(SOURCEDIR)/svgs/$@
	VARIANT=$@ $(MAKE) -C $(SOURCEDIR)

$(UFODIR)/$(FAMILY)-%.ufo: %
	@echo " BUILD UFO  $(@F)"
	@mkdir -p ${UFODIR}
	uv run tools/builder.py --style $* --source $(SOURCEDIR)/svgs/$* --output $@
	uv run ufonormalizer -q -m $@
	@# remove dangling semicolons in features.fea which font editors cannot handle
	@sed -i 's/ ;$\//g' $@/features.fea

ufo: glyphs $(UFO)

# Build targets for prepating the fonts from master UFO sources.
Kanchana: glyphs $(TTF) $(OTF) $(WEBFONTS)

# Create ttf instances if a designspace e

# Compile otf from UFO file. This target will be picked up only if designspace is missing for the variant
$(FONTSDIR)/%.otf: ${UFODIR}/%.ufo
	uv run fontmake --validate-ufo \
		--verbose=WARNING \
		--optimize-cff 1 \
		--flatten-components \
		--filter DecomposeTransformedComponentsFilter  \
		--output otf \
		--output-dir $(FONTSDIR) \
		--ufo-paths $(UFODIR)/$*.ufo
	uv run tools/fix_font.py $@

# Compile ttf from UFO file. This target will be picked up only if designspace is missing for the variant
$(FONTSDIR)/%.ttf: ${UFODIR}/%.ufo
	uv run fontmake --verbose=WARNING \
		--output ttf \
		--flatten-components \
		--filter DecomposeTransformedComponentsFilter \
		--optimize-cff 1 \
		--output-dir $(FONTSDIR) \
		--ufo-paths $(UFODIR)/$*.ufo
	uv run tools/fix_font.py $@

# Package the ufo in fonts directory, directly from the source UFO.
$(FONTSDIR)/%/ufo: ${UFODIR}/%.ufo
	@cp -r $</ $@/

# Create woff2 formatted webfonts for all the otfs available
# Could be done using fonttools but using a python script to avoid hassles of loop
# and filename mangling in Makefile
$(FONTSDIR)/%.woff2: ${FONTSDIR}/%.ttf
	uv run python -m fontTools.ttLib.woff2 compress -o $@ ${FONTSDIR}/$*.ttf


clean:
	@find -iname "*.pyc" -delete
	@rm -rf $(FONTSDIR) $(PROOFDIR)
	rm -rf sources/svgs/*/*.svg

proofs:
	@mkdir -p ${PROOFDIR}
	hb-view $(FONTSDIR)/Kanchana-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--text-file $(TESTSDIR)/ligatures.txt \
		--output-file $(PROOFDIR)/ligatures.pdf;
	hb-view $(FONTSDIR)/Kanchana-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--text-file $(TESTSDIR)/content.txt \
		--output-file $(PROOFDIR)/content.pdf;

	hb-view $(FONTSDIR)/Kanchana-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--text-file $(TESTSDIR)/kerning.txt \
		--output-file $(PROOFDIR)/kerning.pdf ;
	cat $(TESTSDIR)/paragraphs.english.txt | fold -sw 80 | hb-view $(FONTSDIR)/Kanchana-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--output-file $(PROOFDIR)/paragraphs.english.pdf ;

test: proofs
	# fontbakery check-fontval $(FONTSDIR)/$(FAMILY)-Regular.ttf <- enable when https://github.com/microsoft/Font-Validator/issues/62 fixed
	# fontbakery check-ufo-sources $(SOURCEDIR)/ufo/$(FAMILY)-Regular.ufo
	uv run fontbakery check-opentype $(FONTSDIR)/Kanchana/otf-variable/Kanchana-VF.otf
	uv run fontbakery check-googlefonts --full-lists --config fontbakery.yaml --html tests/fontbakery-report.html --ghmarkdown tests/fontbakery-report.md $(FONTSDIR)/Kanchana/ttf-variable/Kanchana-VF.ttf

install: $(FONTSDIR)/Kanchana/otf-variable
	@mkdir -p $(INSTALLDIR);
	@cp $(FONTSDIR)/Kanchana-Regular.otf $(INSTALLDIR);
	@cp $(FONTSDIR)/Kanchana-Thin.otf $(INSTALLDIR);
	@fc-cache -fr

release:
.PHONY: release

release:
	@$(eval VERSION=$(shell git describe --tags `git rev-list --tags --max-count=1`))
	@echo "Creating release for version $(VERSION)"
	# Tar files - Kanchana
	tar czvf $(FONTSDIR)/Kanchana-$(VERSION).tar.gz *.conf OFL.txt README.md $(FONTSDIR)/Kanchana
	sha256sum $(FONTSDIR)/Kanchana-$(VERSION).tar.gz > $(FONTSDIR)/Kanchana-$(VERSION).tar.gz.sha256
	md5sum $(FONTSDIR)/Kanchana-$(VERSION).tar.gz > $(FONTSDIR)/Kanchana-$(VERSION).tar.gz.md5
	# Zip files
	zip -r $(FONTSDIR)/Kanchana-$(VERSION).zip README.md OFL.txt $(FONTSDIR)/Kanchana
	sha256sum $(FONTSDIR)/Kanchana-$(VERSION).zip > $(FONTSDIR)/Kanchana-$(VERSION).zip.sha256
	md5sum $(FONTSDIR)/Kanchana-$(VERSION).zip > $(FONTSDIR)/Kanchana-$(VERSION).zip.md5

# Vertical Metrics Reporting
metrics-report:
	# May need `pip install font-line` to install font-line
	font-line report $(FONTSDIR)/Kanchana/otf-variable/*.otf
