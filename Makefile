# var
MODULE  = $(notdir $(CURDIR))
module  = $(shell echo $(MODULE) | tr A-Z a-z)

# version
MVA_VER = 3.13.12.0

# tool
CURL = curl -L -o
CF   = clang-format

# all
all: install

# doc
.PHONY: doc
doc: doc/ISDS205_User_Guide.pdf

doc/ISDS205_User_Guide.pdf:
	$(CURL) $@ http://english.instrustar.com/upload/user%20guide/ISDS205%20User%20Guide.pdf

# install
.PHONY: install update doc gz
install:
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
gz: distr/Multi_VirAnalyzer_$(MVA_VER).zip


distr/Multi_VirAnalyzer_$(MVA_VER).zip:
	$(CURL) "$@" "http://www.instrustar.com/upload/software/English%20Version($(MVA_VER)).zip"

# merge
MERGE += Makefile apt.txt
MERGE += .clang-format .editorconfig .doxygen .gitignore
MERGE += .vscode bin doc lib inc src tmp

.PHONY: dev
dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout shadow -- $(MERGE)

.PHONY: shadow
shadow:
	git push -v
	git checkout $@
	git pull -v

.PHONY: release
release:
	git tag $(NOW)-$(REL)
	git push -v --tags
	$(MAKE) shadow

.PHONY: zip
zip:
	git archive \
		--format zip \
		--output $(TMP)/$(MODULE)_$(NOW)_$(REL).src.zip \
	HEAD
