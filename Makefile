#!/usr/bin/make -f
SHELL:=/bin/bash
FAMILY=Cocolata
PY=uv run
STYLES=$(shell $(PY) tools/read_config.py styles)
SOURCEDIR=sources
FONTSDIR=fonts
PROOFDIR=proofs
TESTSDIR=tests
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

build: ufo $(FAMILY)
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
	$(PY) tools/builder.py --style $* --source $(SOURCEDIR)/svgs/$* --output $@
	$(PY) ufonormalizer -q -m $@
	@# remove dangling semicolons in features.fea which font editors cannot handle
	@sed -i 's/ ;$\//g' $@/features.fea

ufo: glyphs $(UFO)

# Build targets for prepating the fonts from master UFO sources.
$(FAMILY): $(FONTSDIR)/otf \
	$(FONTSDIR)/ttf \
	$(FONTSDIR)/ttf-variable \
	$(FONTSDIR)/otf-variable \
	$(FONTSDIR)/ufo \
	$(FONTSDIR)/webfonts

# Create ttf instances if a designspace exist
$(FONTSDIR)/ttf: $(FAMILY).designspace
	$(PY) fontmake --mm-designspace $(FAMILY).designspace \
		--filter DecomposeTransformedComponentsFilter  \
		--interpolate \
		--flatten-components  \
		--verbose WARNING \
		--output-dir $@  \
		--output ttf  \
		--optimize-cff 0
	$(PY) tools/fix_font.py $(FONTSDIR)/$*/ttf/*.ttf

# Create otf instances if a designspace exist
$(FONTSDIR)/otf : $(FAMILY).designspace
	$(PY) fontmake --mm-designspace $(FAMILY).designspace \
		--verbose WARNING \
		--filter DecomposeTransformedComponentsFilter  \
		--flatten-components  \
		--interpolate  \
		--optimize-cff 1 \
		--output-dir $@ \
		--output otf
	$(PY) tools/fix_font.py $@/*.otf

# Create ttf variablefont from the given designspace
$(FONTSDIR)/ttf-variable: ufo $(FAMILY).designspace
	$(PY) fontmake --mm-designspace $(FAMILY).designspace \
		--filter DecomposeTransformedComponentsFilter \
		--flatten-components \
		--verbose WARNING \
		--output-dir $@ \
		--output variable
	$(PY) tools/fix_font.py $@/*.ttf
	$(PY) tools/stat.py $(FAMILY) $@/*.ttf

# Create otf variablefont from the given designspace
$(FONTSDIR)/otf-variable : ufo $(FAMILY).designspace
	$(PY) fontmake --mm-designspace $(FAMILY).designspace \
		--filter DecomposeTransformedComponentsFilter  \
		--flatten-components \
		--output-dir $@ \
		--verbose WARNING \
		--optimize-cff 1 \
		--output variable-cff2

	$(PY) tools/fix_font.py $@/*.otf
	$(PY) tools/stat.py $(FAMILY) $@/*.otf

# Create UFO instances from the given designspace
$(FONTSDIR)/ufo: $(FAMILY).designspace
	$(PY) fontmake --mm-designspace $(FAMILY).designspace \
		--interpolate \
		--output ufo

# Package the ufo in fonts directory, directly from the source UFO.
$(FONTSDIR)/ufo: ${UFODIR}
	@cp -r $</ $@/

# Create woff2 formatted webfonts for all the otfs available
$(FONTSDIR)/webfonts:
	@mkdir -p  $@
	$(PY) python -m fontTools.ttLib.woff2 compress -o $(FONTSDIR)/$(FAMILY)-VF.woff2 $(FONTSDIR)/otf-variable/*.otf

clean:
	@find -iname "*.pyc" -delete
	@rm -rf $(FONTSDIR) $(PROOFDIR)
	rm -rf sources/svgs/*/*.svg

proofs:
	@mkdir -p ${PROOFDIR}
	hb-view $(FONTSDIR)/otf/Cocolata-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--text-file $(TESTSDIR)/ligatures.txt \
		--output-file $(PROOFDIR)/ligatures.pdf;
	hb-view $(FONTSDIR)/otf/Cocolata-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--text-file $(TESTSDIR)/content.txt \
		--output-file $(PROOFDIR)/content.pdf;

	hb-view $(FONTSDIR)/otf/Cocolata-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--text-file $(TESTSDIR)/kerning.txt \
		--output-file $(PROOFDIR)/kerning.pdf ;
	cat $(TESTSDIR)/paragraphs.english.txt | fold -sw 80 | hb-view $(FONTSDIR)/otf/Cocolata-Regular.otf \
		--font-ptem 10 \
		--margin 100 \
		--line-space 2.4 \
		--foreground=333333 \
		--output-file $(PROOFDIR)/paragraphs.english.pdf ;

test: proofs
	# fontbakery check-fontval $(FONTSDIR)/$(FAMILY)-Regular.ttf <- enable when https://github.com/microsoft/Font-Validator/issues/62 fixed
	# fontbakery check-ufo-sources $(SOURCEDIR)/ufo/$(FAMILY)-Regular.ufo
	$(PY) fontbakery check-opentype $(FONTSDIR)/otf-variable/Cocolata-VF.otf
	$(PY) fontbakery check-googlefonts --full-lists --config fontbakery.yaml --html tests/fontbakery-report.html --ghmarkdown tests/fontbakery-report.md $(FONTSDIR)/ttf-variable/Cocolata-VF.ttf

install: $(OTF)
	@mkdir -p $(INSTALLDIR);
	@cp $(FONTSDIR)/otf/*.otf $(INSTALLDIR);
	@fc-cache -fr

release:
.PHONY: release

interpolation-test: ufo
	uv run fonttools varLib.interpolatable --pdf report.pdf Cocolata.designspace

release:
	@$(eval VERSION=$(shell git describe --tags `git rev-list --tags --max-count=2`))
	@echo "Creating release for version $(VERSION)"
	# Tar files - Cocolata
	tar czvf $(FONTSDIR)-$(VERSION).tar.gz *.conf OFL.txt README.md $(FONTSDIR)
	sha256sum $(FONTSDIR)-$(VERSION).tar.gz > $(FONTSDIR)-$(VERSION).tar.gz.sha256
	md5sum $(FONTSDIR)-$(VERSION).tar.gz > $(FONTSDIR)-$(VERSION).tar.gz.md5
	# Zip files
	zip -r $(FONTSDIR)-$(VERSION).zip README.md OFL.txt $(FONTSDIR)
	sha256sum $(FONTSDIR)-$(VERSION).zip > $(FONTSDIR)-$(VERSION).zip.sha256
	md5sum $(FONTSDIR)-$(VERSION).zip > $(FONTSDIR)-$(VERSION).zip.md5

# Vertical Metrics Reporting
metrics-report:
	# May need `pip install font-line` to install font-line
	$(PY) font-line report $(FONTSDIR)/otf-variable/*.otf
