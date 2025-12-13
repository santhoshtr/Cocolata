SRCDIR    := ./glyphs
VARIANT   ?= debug
GLYPHS    := $(wildcard $(SRCDIR)/*.mp)
SVGS      := $(patsubst $(SRCDIR)/%.mp,svgs/$(VARIANT)/%.svg,$(GLYPHS))

.PHONY: all clean

default: all

all: $(SVGS)

svgs/$(VARIANT)/%.svg: $(SRCDIR)/%.mp   pens.mp config/$(VARIANT).mp
	@echo " BUILD GLYPH   $@"
ifeq ($(VARIANT), debug)
	@mpost -restricted  -s 'outputtemplate="$@"' -s 'jobname="config/$(VARIANT).mp"' --interaction=nonstopmode $< end
else
	@mpost -restricted  -s 'outputtemplate="$@"' -s 'jobname="config/$(VARIANT).mp"' --interaction=errorstopmode $< end > /dev/null
endif
	@rm -rf ./*.log ./*.mpo ./*.mpt

clean:
	@rm -rf *.tmp *.dvi *.svg *.log svgs/$(VARIANT)/*.svg *.mpt
