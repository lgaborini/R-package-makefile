SCRIPTS := $(wildcard R/*.R)
MAN := $(wildcard man/*.Rd)

PKG := $(shell head -1 DESCRIPTION | sed 's/Package: //' | cat)
VERSION := $(shell sed -n 3p DESCRIPTION | sed 's/Version: //' | cat)
PKG_SOURCE := ../$(PKG)_$(VERSION).tar.gz
PKG_BINARY := ../$(PKG)_$(VERSION).zip

all: document source_package binary_package packages pkgdown drat

.PHONY: document source_package binary_package packages pkgdown drat targets all

targets:
	$(info Package : $(PKG))
	$(info Version : $(VERSION))
	$(info Source  : $(PKG_SOURCE))
	$(info Binary  : $(PKG_BINARY))
	$(info Rds     : $(MAN))
	$(info Scripts : $(SCRIPTS))

# Requires GNU Make 4.3
#
# https://www.gnu.org/software/make/manual/html_node/Multiple-Targets.html
# &: groups all targets as if they were one
#
# It builds the help files at most once (instead of once per .Rd)
$(MAN) &: $(SCRIPTS)
	$(info ** Running devtools::document **)
	@R --slave -e "devtools::document(roclets = c('rd', 'collate', 'namespace'))"

document: $(MAN)

$(PKG_SOURCE): $(MAN)
	$(info ** Making source package $(PKG_SOURCE) **)
	R --slave -e "devtools::build(args = c('--no-build-vignettes'))"

$(PKG_BINARY): $(MAN)
	$(info ** Making binary package $(PKG_BINARY) **)
	R --slave -e "devtools::build(binary = TRUE, args = c('--preclean'))"

source_package: $(PKG_SOURCE)

binary_package: $(PKG_BINARY)

packages: document source_package binary_package

pkgdown: document
	$(info ** Making pkgdown site **)
	R --slave -e "pkgdown::build_site(preview = FALSE)"

drat: packages
	$(info ** Pushing packages to drat repo **)
	R --slave -e "drat::insertPackage('$(PKG_SOURCE)')"
	R --slave -e "drat::insertPackage('$(PKG_BINARY)')"
   