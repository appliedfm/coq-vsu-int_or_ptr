.PHONY: all theories clightgen clean deepclean

all: theories


#
# meta
#

PUBLISHER=appliedfm
PROJECT=int_or_ptr


#
# configure
#

J?=$(shell nproc)
BITSIZE?=opam
COQC?=coqc
SHA256SUM?=sha256sum
VSUTOOL?=vsu

-include CONFIGURE


VSU_INCLUDE_DIR=$(shell $(VSUTOOL) -I)
CLIGHTGEN64?=$(shell $(VSUTOOL) --show-tool-path=coq-compcert/clightgen)
CLIGHTGEN32?=$(shell $(VSUTOOL) --show-tool-path=coq-compcert-32/clightgen)


TARGET=x86_64-linux
VARIANT=
COMPCERT_PACKAGE=coq-compcert
VST_PACKAGE=coq-vst


COQLIB=$(shell $(COQC) -where | tr -d '\r' | tr '\\' '/')

COQLIBINSTALL=$(COQLIB)/user-contrib
COQ_INSTALL_DIR?=$(COQLIBINSTALL)/$(PUBLISHER)/$(PROJECT)

ifeq ($(BITSIZE),64) # This is an alias for BITSIZE=opam
else ifeq ($(BITSIZE),32)
	TARGET=x86_32-linux
	COMPCERT_PACKAGE=coq-compcert-32
	VST_PACKAGE=coq-vst-32
	COQLIBINSTALL=$(COQLIB)/../coq-variant
	VARIANT=32/
endif


COQ_INSTALL_DIR=$(COQLIBINSTALL)/$(PUBLISHER)/$(VARIANT)$(PROJECT)
CLIGHT_TARGETS=theories/$(PROJECT)/vst/clightgen/$(TARGET)/int_or_ptr.v


#
# clightgen
#

ifeq ($(SRC),opam)
	C_INCLUDE_PATH?=$(VSU_INCLUDE_DIR)
else
	C_INCLUDE_PATH?=src/c/include
endif


theories/$(PROJECT)/vst/clightgen/x86_64-linux/int_or_ptr.v: \
	$(C_INCLUDE_PATH)/coq-vsu-int_or_ptr/src/int_or_ptr.c \
	$(C_INCLUDE_PATH)/coq-vsu-int_or_ptr/int_or_ptr.h

theories/$(PROJECT)/vst/clightgen/x86_32-linux/int_or_ptr.v: \
	$(C_INCLUDE_PATH)/coq-vsu-int_or_ptr/src/int_or_ptr.c \
	$(C_INCLUDE_PATH)/coq-vsu-int_or_ptr/int_or_ptr.h

theories/$(PROJECT)/vst/clightgen/x86_64-linux/%.v:
	mkdir -p `dirname $@`
	$(CLIGHTGEN64) -Wall -Wno-unused-variable -I`$(VSUTOOL) -I` -normalize -o $@ $<
	echo "(*\nInput hashes (sha256):\n\n`$(SHA256SUM) $^`\n*)" >> $@

theories/$(PROJECT)/vst/clightgen/x86_32-linux/%.v:
	mkdir -p `dirname $@`
	$(CLIGHTGEN32) -Wall -Wno-unused-variable -I`$(VSUTOOL) -I` -normalize -o $@ $<
	echo "(*\nInput hashes (sha256):\n\n`$(SHA256SUM) $^`\n*)" >> $@

clightgen: \
	theories/$(PROJECT)/vst/clightgen/x86_64-linux/int_or_ptr.v \
	theories/$(PROJECT)/vst/clightgen/x86_32-linux/int_or_ptr.v


#
# theories
#

_CoqProject: $(CLIGHT_TARGETS)
	echo "# $(TARGET)"                          > $@
	echo `$(VSUTOOL) -Q $(COMPCERT_PACKAGE)`    >> $@
	echo `$(VSUTOOL) -Q $(VST_PACKAGE)`         >> $@
	echo "-Q theories/$(PROJECT)/vst/ast                    $(PUBLISHER).$(PROJECT).vst.ast"        >> $@
	find     theories/$(PROJECT)/vst/ast                   -name "*.v" | sort                       >> $@
	echo "-Q theories/$(PROJECT)/vst/clightgen/$(TARGET)    $(PUBLISHER).$(PROJECT).vst.clightgen"  >> $@
	find     theories/$(PROJECT)/vst/clightgen/$(TARGET)   -name "*.v" | sort                       >> $@
	echo "-Q theories/$(PROJECT)/vst/cmodel                 $(PUBLISHER).$(PROJECT).vst.cmodel"     >> $@
	find     theories/$(PROJECT)/vst/cmodel                -name "*.v" | sort                       >> $@
	echo "-Q theories/$(PROJECT)/vst/spec                   $(PUBLISHER).$(PROJECT).vst.spec"       >> $@
	find     theories/$(PROJECT)/vst/spec                  -name "*.v" | sort                       >> $@
	echo "-Q theories/$(PROJECT)/vst/verif                  $(PUBLISHER).$(PROJECT).vst.verif"      >> $@
	find     theories/$(PROJECT)/vst/verif                 -name "*.v" | sort                       >> $@


Makefile.coq: Makefile _CoqProject
	cat _CoqProject
	coq_makefile -f _CoqProject -o Makefile.coq

theories: Makefile.coq
	$(MAKE) -f Makefile.coq -j$(J)


#
# install
#

.PHONY: install install-src install-model install-vst


C_SOURCES= \
	$(shell find src/c/include -name "*.c" | sort | cut -d'/' -f4-) \
	$(shell find src/c/include -name "*.h" | sort | cut -d'/' -f4-)

install-src:
	install -d "$(VSU_INCLUDE_DIR)"
	for d in $(sort $(dir $(C_SOURCES))); do install -d "$(VSU_INCLUDE_DIR)/$$d"; done
	for f in $(C_SOURCES); do install -m 0644 src/c/include/$$f "$(VSU_INCLUDE_DIR)/$$(dirname $$f)"; done
	tree "$(VSU_INCLUDE_DIR)" || true


COQ_SOURCES_VST= \
	$(shell find theories/$(PROJECT)/vst/ast                    -name "*.v" | sort | cut -d'/' -f3-) \
	$(shell find theories/$(PROJECT)/vst/clightgen/$(TARGET)    -name "*.v" | sort | cut -d'/' -f3-) \
	$(shell find theories/$(PROJECT)/vst/cmodel                 -name "*.v" | sort | cut -d'/' -f3-) \
	$(shell find theories/$(PROJECT)/vst/spec                   -name "*.v" | sort | cut -d'/' -f3-) \
	$(shell find theories/$(PROJECT)/vst/verif                  -name "*.v" | sort | cut -d'/' -f3-)

COQ_COMPILED_VST=$(COQ_SOURCES_VST:%.v=%.vo)

install-vst: theories
	[ -z $(PACKAGE_NAME) ] || echo "{" > install-meta.json
	[ -z $(PACKAGE_NAME) ] || echo "    \"coq-library-name\": \"$(PUBLISHER).$(PROJECT)\"," >> install-meta.json
	[ -z $(PACKAGE_NAME) ] || echo "    \"coq-library-path\": \"$(COQ_INSTALL_DIR)\"" >> install-meta.json
	[ -z $(PACKAGE_NAME) ] || echo "}" >> install-meta.json
	[ -z $(PACKAGE_NAME) ] || install -d `$(VSUTOOL) --show-unit-metadata-path`
	[ -z $(PACKAGE_NAME) ] || install -m 0644 install-meta.json `$(VSUTOOL) --show-unit-metadata-path`/$(PACKAGE_NAME).json
	install -d "$(COQ_INSTALL_DIR)"
	for d in $(sort $(dir $(COQ_COMPILED_VST) $(COQ_COMPILED_VST))); do install -d "$(COQ_INSTALL_DIR)/$$d"; done
	for f in $(COQ_COMPILED_VST) $(COQ_COMPILED_VST); do install -m 0644 theories/$(PROJECT)/$$f "$(COQ_INSTALL_DIR)/$$(dirname $$f)"; done
	mv    $(COQ_INSTALL_DIR)/vst/clightgen/$(TARGET)/* $(COQ_INSTALL_DIR)/vst/clightgen/
	rmdir $(COQ_INSTALL_DIR)/vst/clightgen/$(TARGET)
	tree "$(COQ_INSTALL_DIR)" || true


#
# clean
#

clean:
	[ ! -f Makefile.coq ] || $(MAKE) -f Makefile.coq clean
	rm -f install-meta.json
	rm -f `find ./ -name "*Makefile.coq*"`
	rm -f `find ./ -name ".*.cache"`
	rm -f `find ./ -name "*.aux"`
	rm -f `find ./ -name "*.glob"`
	rm -f `find ./ -name "*.vo*"`

deepclean: clean
	rm -f _CoqProject

verydeepclean: deepclean
	rm -rf theories/$(PROJECT)/vst/clightgen
