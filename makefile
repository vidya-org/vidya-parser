#   =======================
#  ||    ROOT MAKEFILE    ||
#   =======================
#

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Some helpers:
#--------------------------------------------------------------------------
empty =
tab = $(empty)$(shell printf '\t')$(empty)

define execute-command
$(tab)$(1)

endef

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Compiler:
#--------------------------------------------------------------------------
CC = g++

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Directories for linking
#--------------------------------------------------------------------------
# ======== GERAL ========
LIBDIR = -L/usr/lib
# LOCALLIBDIR =  -L/usr/local/lib

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Compilation flags
#--------------------------------------------------------------------------
#PGFLAG = -lpq
#ALLBOOSTFLAGS = -lboost_locale -lpthread -lboost_thread -lboost_filesystem -lboost_system -lboost_regex -lboost_serialization -lboost_random
#ALLENDFLAGS = -lssl -lcrypto -lz -ldl -lmhash -lcurl
#GOOGLETESTFLAGS = -lgmock_main -lgmock -lgtest
#STACKTRACEFLAGS = -rdynamic
#PTHREADFLAG = -lpthread

GENERALSTARTFLAGS = -Wall -std=c++14

LIBRARYDIRS = -I./vendor

ALLCOMPFLAGS = $(GENERALSTARTFLAGS) $(LIBRARYDIRS)

#LINKFLAGS = -lboost_filesystem -lboost_system
ifeq ($(MAKECMDGOALS),test)
	TESTFLAGS =
endif

LINKFLAGS = $(TESTFLAGS)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Sources directories
#--------------------------------------------------------------------------
# ======== main ========
MAINDIR = src
UTILSDIR = utils
MODSECLOGDIR = src/modseclog

ifeq ($(MAKECMDGOALS),test)
	TESTSDIR = tests
	_ALLSRCDIRLIST = $(MAINDIR) $(MODSECLOGDIR) $(UTILSDIR) $(TESTSDIR)
else
	_ALLSRCDIRLIST = $(MAINDIR) $(MODSECLOGDIR) $(UTILSDIR)
endif

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Dependencies and object directories
#--------------------------------------------------------------------------
DEPDIR = deps

DEPDIRLIST = $(addsuffix /$(DEPDIR),$(_ALLSRCDIRLIST))

DEPSUFFIX = _dep

#----====----====----====----====----
OBJDIR = objs

OBJDIRLIST = $(addsuffix /$(OBJDIR),$(_ALLSRCDIRLIST))

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Sources list
#--------------------------------------------------------------------------
# ALLSRCFILES = $(foreach dir,$(_ALLSRCDIRLIST),$(wildcard $(dir)/*.cpp))

ifeq ($(MAKECMDGOALS),test)
	ALLSRCFILES = $(filter-out $(foreach dir,$(_ALLSRCDIRLIST),$(wildcard $(dir)/*.cpp)) , $(MAINDIR)/main.cpp)
	MAINFILES = $(filter-out $(MAINDIR)/main.cpp , $(wildcard $(MAINDIR)/*.cpp) )
	TESTSFILES = $(wildcard $(TESTSDIR)/*.cpp)
endif

ifeq ($(MAKECMDGOALS),exec)
	ALLSRCFILES = $(foreach dir,$(_ALLSRCDIRLIST),$(wildcard $(dir)/*.cpp))
	MAINFILES = $(wildcard $(MAINDIR)/*.cpp)
endif

UTILSFILES = $(wildcard $(UTILSDIR)/*.cpp)
MODSECLOGFILES = $(wildcard $(MODSECLOGDIR)/*.cpp)
HELPERSFILES = $(wildcard $(HELPERSDIR)/*.cpp)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Dependencies Lists
#--------------------------------------------------------------------------
#   Dependencias dos .o
MAINDEPS := $(addprefix $(MAINDIR)/$(DEPDIR)/,$(patsubst %.cpp,%.d,$(notdir $(MAINFILES))))
UTILSDEPS := $(addprefix $(UTILSDIR)/$(DEPDIR)/,$(patsubst %.cpp,%.d,$(notdir $(UTILSFILES))))
MODSECLOGDEPS := $(addprefix $(MODSECLOGDIR)/$(DEPDIR)/,$(patsubst %.cpp,%.d,$(notdir $(MODSECLOGFILES))))
TESTSDEPS := $(addprefix $(TESTSDIR)/$(DEPDIR)/,$(patsubst %.cpp,%.d,$(notdir $(TESTSFILES))))

#   Dependencias dos .d
MAINDEPDEPS := $(subst .d,$(DEPSUFFIX).d,$(MAINDEPS))
UTILSDEPDEPS := $(subst .d,$(DEPSUFFIX).d,$(UTILSDEPS))
MODSECLOGDEPDEPS := $(subst .d,$(DEPSUFFIX).d,$(MODSECLOGDEPS))
TESTSDEPDEPS := $(subst .d,$(DEPSUFFIX).d,$(TESTSDEPS))

ALLDEPDEPS :=	$(MAINDEPDEPS) $(MODSECLOGDEPDEPS) $(UTILSDEPDEPS) $(TESTSDEPDEPS)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Object Lists
#--------------------------------------------------------------------------
MAINOBJS := $(addprefix $(MAINDIR)/$(OBJDIR)/,$(patsubst %.cpp,%.o,$(notdir $(MAINFILES))))
UTILSOBJS := $(addprefix $(UTILSDIR)/$(OBJDIR)/,$(patsubst %.cpp,%.o,$(notdir $(UTILSFILES))))
MODSECLOGOBJS := $(addprefix $(MODSECLOGDIR)/$(OBJDIR)/,$(patsubst %.cpp,%.o,$(notdir $(MODSECLOGFILES))))
TESTSOBJS := $(addprefix $(TESTSDIR)/$(OBJDIR)/,$(patsubst %.cpp,%.o,$(notdir $(TESTSFILES))))

ALLOBJS := $(TESTSOBJS) $(MAINOBJS) $(MODSECLOGOBJS) $(UTILSOBJS)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Executable
#--------------------------------------------------------------------------
EXEC := vidya-parser
TESTEXEC := test

BINDIR := bin

export CC
export ALLCOMPFLAGS
export LOCALLIBDIR
export DEPDIR
export OBJDIR
export DEPSUFFIX
export ALLDEPDEPS
export ALLOBJS

all:
	@echo -e '\n\n==================== ERROR ===================='
	@echo -e '   --------------------------------------------'
	@echo "   |        There's no default rule!           |"
	@echo -e '   --------------------------------------------'
	@echo -e '   Choose an option:\n'
	@echo -e '\texec\t    [compiles main executable]'
	@echo -e '\tclean\t\t    [erases all files]'
	@echo -e '===============================================\n\n'

exec: rmexec allobjs FORCE | $(BINDIR)
	$(CC) $(ALLOBJS) $(ALLCOMPFLAGS) -o $(BINDIR)/$(EXEC) $(LINKFLAGS)
	@echo -e '=----------------------------------------------------='
	@echo -e '=           $(EXEC) generated/updated       ='
	@echo -e '=           Executable: $(BINDIR)/$(EXEC)  \t     ='
	@echo -e '=----------------------------------------------------=\n\n'

test: compiletest
	@echo -e '$(ALLOBJS)'
	@echo -e 'Executing tests...\n'
	@set -e;./$(BINDIR)/$(TESTEXEC)
# @set -e;./$(BINDIR)/$(TESTEXEC) --log_level=message --build_info=yes --show_progress=true

compiletest: rmtest allobjs FORCE | $(BINDIR)
	$(CC) $(ALLOBJS) $(ALLCOMPFLAGS) -o $(BINDIR)/$(TESTEXEC) $(LINKFLAGS)
	@echo -e '=----------------------------------------------------='
	@echo -e '=           TESTS generated/updated                  ='
	@echo -e '=           Executable: $(BINDIR)/$(TESTEXEC)  \t\t     ='
	@echo -e '=----------------------------------------------------=\n\n'

allobjs: objdirs alldeps
	@set -e; $(MAKE) --no-print-directory -f makeobjs allobjs

#aobjsdebian: objdirs adeps
#	@set -e; $(MAKE) --no-print-directory -f makeobjs allobjs PGINCDIR=$(PGDEBIANINCDIR) PGLIBDIR=$(PGDEBIANLIBDIR)

#aobjscentos: objdirs adeps
#	@set -e; $(MAKE) --no-print-directory -f makeobjs allobjs PGINCDIR=$(PGCENTOSINCDIR) PGLIBDIR=$(PGCENTOSLIBDIR)

alldeps: depdirs
	@set -e; $(MAKE) --no-print-directory -f makedeps alldeps

depdirs: | $(DEPDIRLIST)
	@echo -e '------------------------------------------------------'
	@echo -e '\tDependencies directories created/checked!\n'

objdirs: | $(OBJDIRLIST)
	@echo -e '------------------------------------------------------'
	@echo -e '\tObjects directories created/checked!\n'

$(DEPDIRLIST) $(OBJDIRLIST) $(BINDIR):
	mkdir $@

clean: rmdeps rmobjs rmexec FORCE
	rm -rf $(BINDIR)
	@echo -e '------------------------------------------------------'
	@echo -e '\tAll files removed!\n\n'

rmexec:
	rm -f $(BINDIR)/$(EXEC)
	@echo -e '------------------------------------------------------'
	@echo -e '\tExecutables removed!'

rmtest:
	rm -f $(BINDIR)/$(TESTEXEC)
	@echo -e '------------------------------------------------------'
	@echo -e '\tTest executable removed!'

rmdeps: FORCE
	$(foreach dir, $(DEPDIRLIST) tests/$(DEPDIR), $(call execute-command, rm -rf $(dir) ) )

rmobjs: FORCE
	$(foreach dir, $(OBJDIRLIST) tests/$(OBJDIR), $(call execute-command, rm -rf $(dir) ) )

FORCE:

#  ===========================
#  ||    MAKEFILE >END<      ||
#  ===========================
