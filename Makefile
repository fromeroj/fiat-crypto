.SUFFIXES:

MOD_NAME := Crypto
SRC_DIR  := src
TIMED?=
TIMECMD?=
STDTIME?=/usr/bin/time -f "$* (real: %e, user: %U, sys: %S, mem: %M ko)"
TIMER=$(if $(TIMED), $(STDTIME), $(TIMECMD))

PROFILE?=
VERBOSE?=
SHOW := $(if $(VERBOSE),@true "",@echo "")
HIDE := $(if $(VERBOSE),,@)
INSTALLDEFAULTROOT := Crypto

.PHONY: coq clean update-_CoqProject cleanall install \
	install-coqprime clean-coqprime coqprime \
	specific-c specific-display display \
	specific non-specific lite only-heavy printlite \
	curves-proofs no-curves-proofs \
	bench c

SORT_COQPROJECT = sed 's,[^/]*/,~&,g' | env LC_COLLATE=C sort | sed 's,~,,g' | uniq

FAST_TARGETS += archclean clean cleanall clean-coqprime printenv clean-old update-_CoqProject Makefile.coq
SUPER_FAST_TARGETS += update-_CoqProject Makefile.coq

SLOW :=
ifneq ($(filter-out $(SUPER_FAST_TARGETS),$(MAKECMDGOALS)),)
SLOW := 1
else
ifeq ($(MAKECMDGOALS),)
SLOW := 1
endif
endif

ifneq ($(SLOW),)
COQ_VERSION_PREFIX = The Coq Proof Assistant, version
COQ_VERSION := $(firstword $(subst $(COQ_VERSION_PREFIX),,$(shell "$(COQBIN)coqc" --version 2>/dev/null)))

-include Makefile.coq
endif

ifeq ($(filter curves-proofs no-curves-proofs lite only-heavy printdeps printreversedeps printlite,$(MAKECMDGOALS)),)
-include etc/coq-scripts/Makefile.vo_closure
else
include etc/coq-scripts/Makefile.vo_closure
endif

.DEFAULT_GOAL := coq

update-_CoqProject::
	$(SHOW)'ECHO > _CoqProject'
	$(HIDE)(echo '-R $(SRC_DIR) $(MOD_NAME)'; echo '-R Bedrock Bedrock'; echo '-arg "-compat 8.6"'; (git ls-files 'src/*.v' 'Bedrock/*.v' | $(SORT_COQPROJECT))) > _CoqProject

$(VOFILES): | coqprime

# add files to this list to prevent them from being built by default
UNMADE_VOFILES := src/SpecificGen/% src/Specific/%Display.vo
# add files to this list to prevent them from being built as final
# targets by the "lite" target
LITE_UNMADE_VOFILES := src/Curves/Weierstrass/AffineProofs.vo src/Specific/Karatsuba.vo src/Specific/NISTP256/AMD64/IntegrationTestMontgomeryP256.vo src/Specific/X25519/C64/ladderstep.vo
CURVES_PROOFS_PRE_VOFILES := $(filter src/Curves/%Proofs.vo,$(VOFILES))
NO_CURVES_PROOFS_UNMADE_VOFILES := src/Curves/Weierstrass/AffineProofs.vo

COQ_VOFILES := $(filter-out $(UNMADE_VOFILES),$(VOFILES))
SPECIFIC_VO := $(filter src/Specific/%,$(VOFILES))
NON_SPECIFIC_VO := $(filter-out $(SPECIFIC_VO),$(VO_FILES))
SPECIFIC_DISPLAY_VO := $(filter src/Specific/%Display.vo,$(VOFILES))
DISPLAY_VO := $(SPECIFIC_DISPLAY_VO)
DISPLAY_JAVA_VO := $(filter %JavaDisplay.vo,$(DISPLAY_VO))
DISPLAY_NON_JAVA_VO := $(filter-out $(DISPLAY_JAVA_VO),$(DISPLAY_VO))
# computing the vo_reverse_closure is slow, so we only do it if we're
# asked to make the lite target
ifneq ($(filter lite,$(MAKECMDGOALS)),)
LITE_ALL_UNMADE_VOFILES := $(foreach vo,$(LITE_UNMADE_VOFILES),$(call vo_reverse_closure,$(VOFILES),$(vo)))
LITE_VOFILES := $(filter-out $(LITE_ALL_UNMADE_VOFILES),$(COQ_VOFILES))
endif
ifneq ($(filter only-heavy,$(MAKECMDGOALS)),)
HEAVY_VOFILES := $(call vo_closure,$(LITE_UNMADE_VOFILES))
endif
ifneq ($(filter no-curves-proofs,$(MAKECMDGOALS)),)
NO_CURVES_PROOFS_ALL_UNMADE_VOFILES := $(foreach vo,$(NO_CURVES_PROOFS_UNMADE_VOFILES),$(call vo_reverse_closure,$(VOFILES),$(vo)))
NO_CURVES_PROOFS_VOFILES := $(filter-out $(NO_CURVES_PROOFS_ALL_UNMADE_VOFILES),$(COQ_VOFILES))
endif
ifneq ($(filter curves-proofs,$(MAKECMDGOALS)),)
CURVES_PROOFS_VOFILES := $(call vo_closure,$(CURVES_PROOFS_PRE_VOFILES))
endif

specific: $(SPECIFIC_VO) coqprime
non-specific: $(NON_SPECIFIC_VO) coqprime
coq: $(COQ_VOFILES) coqprime
lite: $(LITE_VOFILES) coqprime
only-heavy: $(HEAVY_VOFILES) coqprime
curves-proofs: $(CURVES_PROOFS_VOFILES) coqprime
no-curves-proofs: $(NO_CURVES_PROOFS_VOFILES) coqprime
specific-display: $(SPECIFIC_DISPLAY_VO:.vo=.log) coqprime
specific-c: $(SPECIFIC_DISPLAY_VO:Display.vo=.c) coqprime
display: $(DISPLAY_VO:.vo=.log) coqprime

printlite::
	@echo 'Files Made:'
	@for i in $(sort $(LITE_VOFILES)); do echo $$i; done
	@echo
	@echo
	@echo 'Files Not Made:'
	@for i in $(sort $(LITE_ALL_UNMADE_VOFILES)); do echo $$i; done

COQPRIME_FOLDER := coqprime
ifneq ($(filter 8.5%,$(COQ_VERSION)),) # 8.5
else
ifneq ($(PROFILE),)
OTHERFLAGS += -profile-ltac -w "-notation-overridden"
else
OTHERFLAGS += -w "-notation-overridden"
endif
endif

COQPATH?=${CURDIR}/$(COQPRIME_FOLDER)
export COQPATH

coqprime:
	$(MAKE) --no-print-directory -C $(COQPRIME_FOLDER)

clean-coqprime:
	$(MAKE) --no-print-directory -C $(COQPRIME_FOLDER) clean

install-coqprime:
	$(MAKE) --no-print-directory -C $(COQPRIME_FOLDER) install

Makefile.coq: Makefile _CoqProject
	$(SHOW)'COQ_MAKEFILE -f _CoqProject > $@'
	$(HIDE)$(COQBIN)coq_makefile -f _CoqProject INSTALLDEFAULTROOT = $(INSTALLDEFAULTROOT) -o Makefile-old && cat Makefile-old | sed s'/^printenv:$$/printenv::/g' > $@ && rm -f Makefile-old

$(DISPLAY_NON_JAVA_VO:.vo=.log) : %Display.log : %.vo %Display.v src/Compilers/Z/CNotations.vo src/Specific/IntegrationTestDisplayCommon.vo
	$(SHOW)"COQC $*Display > $@"
	$(HIDE)$(COQC) $(COQDEBUG) $(COQFLAGS) $*Display.v | sed s'/\r\n/\n/g' > $@.tmp && mv -f $@.tmp $@

c: $(DISPLAY_NON_JAVA_VO:Display.vo=.c) $(DISPLAY_NON_JAVA_VO:Display.vo=.h)

$(DISPLAY_NON_JAVA_VO:Display.vo=.c) : %.c : %Display.log extract-function.sh
	./extract-function.sh $(patsubst %Display.log,%,$(notdir $<)) < $< > $@

$(DISPLAY_NON_JAVA_VO:Display.vo=.h) : %.h : %Display.log extract-function-header.sh
	./extract-function-header.sh $(patsubst %Display.log,%,$(notdir $<)) < $< > $@

$(DISPLAY_JAVA_VO:.vo=.log) : %JavaDisplay.log : %.vo %JavaDisplay.v src/Compilers/Z/JavaNotations.vo src/Specific/IntegrationTestDisplayCommon.vo
	$(SHOW)"COQC $*JavaDisplay > $@"
	$(HIDE)$(COQC) $(COQDEBUG) $(COQFLAGS) $*JavaDisplay.v | sed s'/\r\n/\n/g' > $@.tmp && mv -f $@.tmp $@

DISPLAY_X25519_C64_VO := $(filter src/Specific/X25519/C64/%,$(DISPLAY_NON_JAVA_VO))

src/Specific/X25519/C64/measure: src/Specific/X25519/C64/compiler.sh measure.c $(DISPLAY_X25519_C64_VO:Display.vo=.c) $(DISPLAY_X25519_C64_VO:Display.vo=.h) src/Specific/X25519/C64/scalarmult.c
	src/Specific/X25519/C64/compiler.sh -o src/Specific/X25519/C64/measure -I src/Specific/X25519/C64/ measure.c $(DISPLAY_X25519_C64_VO:Display.vo=.c) src/Specific/X25519/C64/scalarmult.c -D TIMINGS=2047 -D UUT=crypto_scalarmult_bench

src/Specific/X25519/C64/measurements.txt: src/Specific/X25519/C64/measure capture.sh etc/machine.sh etc/freq.sh
	./capture.sh src/Specific/X25519/C64

third_party/openssl-nistz256/measure:  third_party/openssl-nistz256/compiler.sh third_party/openssl-nistz256/bench_madd.c third_party/openssl-nistz256/cpu_intel.c third_party/openssl-nistz256/ecp_nistz256-x86_64.s third_party/openssl-nistz256/nistz256.h
	third_party/openssl-nistz256/compiler.sh -o third_party/openssl-nistz256/measure measure.c third_party/openssl-nistz256/bench_madd.c third_party/openssl-nistz256/cpu_intel.c third_party/openssl-nistz256/ecp_nistz256-x86_64.s src/Specific/X25519/C64/scalarmult.c -I third_party/openssl-nistz256 -D TIMINGS=2047 -D UUT=bench_madd

third_party/openssl-nistz256/measurements.txt: third_party/openssl-nistz256/measure
	./capture.sh third_party/openssl-nistz256

src/Specific/NISTP256/AMD64/measure: src/Specific/NISTP256/AMD64/compiler.sh src/Specific/NISTP256/AMD64/p256.h src/Specific/NISTP256/AMD64/p256_jacobian_add_affine.c src/Specific/NISTP256/AMD64/bench_madd.c
	src/Specific/NISTP256/AMD64/compiler.sh -o src/Specific/NISTP256/AMD64/measure src/Specific/NISTP256/AMD64/p256_jacobian_add_affine.c src/Specific/NISTP256/AMD64/bench_madd.c -I src/Specific/NISTP256/AMD64 measure.c -D TIMINGS=2047 -D UUT=bench_madd

src/Specific/NISTP256/AMD64/measurements.txt: src/Specific/NISTP256/AMD64/measure
	./capture.sh src/Specific/NISTP256/AMD64

src/Specific/NISTP256/AMD64/icc/measure: src/Specific/NISTP256/AMD64/compiler.sh src/Specific/NISTP256/AMD64/p256.h src/Specific/NISTP256/AMD64/icc/icc17_p256_jacobian_add_affine.s src/Specific/NISTP256/AMD64/bench_madd.c
	src/Specific/NISTP256/AMD64/icc/compiler.sh -o src/Specific/NISTP256/AMD64/icc/measure src/Specific/NISTP256/AMD64/icc/icc17_p256_jacobian_add_affine.s src/Specific/NISTP256/AMD64/bench_madd.c -I src/Specific/NISTP256/AMD64 measure.c -D TIMINGS=2047 -D UUT=bench_madd

src/Specific/NISTP256/AMD64/icc/measurements.txt: src/Specific/NISTP256/AMD64/icc/measure
	./capture.sh src/Specific/NISTP256/AMD64/icc

bench: src/Specific/X25519/C64/measurements.txt third_party/openssl-nistz256/measurements.txt src/Specific/NISTP256/AMD64/measurements.txt src/Specific/NISTP256/AMD64/icc/measurements.txt
	head -999999 $?

clean::
	rm -f Makefile.coq

cleanall:: clean clean-coqprime

install: coq install-coqprime

printenv::
	@echo "COQPATH =        $$COQPATH"

printdeps::
	$(HIDE)$(foreach vo,$(filter %.vo,$(MAKECMDGOALS)),echo '$(vo): $(call vo_closure,$(vo))'; )

printreversedeps::
	$(HIDE)$(foreach vo,$(filter %.vo,$(MAKECMDGOALS)),echo '$(vo): $(call vo_reverse_closure,$(VOFILES),$(vo))'; )
