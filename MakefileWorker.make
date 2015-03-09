# For basic info on this makefile, run
# make help
#
# This makefile should auto-detect all source code in the given directory structure,
# which is set up in makefile.
# It contains compiler options, flags, functions for detecting source code and libraries,
# rules for compiling source code into a library, and running unit tests on the library.
#
# MCU-specifid code is not yet supported.
#
# Use of libraries is not yet supported. Think about it before you do it.


### Generate target name ###
target=$(TARGET_DIR)/$(TARGET_NAME)
TARGET=$(addsuffix .a,$(target))


### Generate and set flags ###
#Flags for archive tool
ifdef SILENCE
	ARCHIVER_FLAGS=rcs
else
	ARCHIVER_FLAGS=rcvs
endif

# Production code
COMPILER_FLAGS = -c
INCLUDE_FLAGS=$(addprefix -I,$(INC_DIRS))
# LINKER_FLAGS=$(addprefix -L,$(LIB_DIRS))
# LINKER_FLAGS+=$(addprefix -l,$(LIB_LIST))

# Test code using CppUTest test harness
#Flags for user unit tests
TEST_COMPILER_FLAGS=
TEST_INCLUDE_FLAGS=$(addprefix -I,$(TEST_INC_DIR))
#Link to any other libraries utilized by user tests
TEST_LINKER_FLAGS=$(addprefix -L,$(TEST_LIB_DIR))
TEST_LINKER_FLAGS+=$(addprefix -l,$(TEST_LIB_LIST))
#Link to production source code library is included as a prerequisite in rule for building TEST_TARGET
# TEST_LINKER_FLAGS+=$(addprefix -L,$(TEST_TARGET_DIR))
# TEST_LINKER_FLAGS+=$(addprefix -l,$(TARGET_NAME))

#Flags for CppUTest test harness source code
CPPUTEST_COMPILER_FLAGS=
CPPUTEST_INCLUDE_FLAGS+=$(addprefix -I,$(CPPUTEST_INC_DIR))
CPPUTEST_LINKER_FLAGS=$(addprefix -L,$(CPPUTEST_LIB_DIR))
CPPUTEST_LINKER_FLAGS+=$(addprefix -l,$(CPPUTEST_LIB_LIST))


### Auto-detect source code and generate object files ###
# Production source code
SRC=$(call get_src_from_dir_list,$(SRC_DIRS))
#nest calls so we don't get a repetition of .c and .cpp files
src_obj=$(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(SRC)))
SRC_OBJ=$(addprefix $(OBJ_DIR)/,$(src_obj))
INC=$(call get_inc_from_dir_list,$(INC_DIRS))
LIBS=$(addprefix lib,$(addsuffix .a,$(LIB_LIST)))

# Test code using CppUTest test harness
# User unit tests
TEST_TARGET=$(TEST_TARGET_DIR)/$(TARGET_NAME)_test
#Production code is compiled into a library
TARGET_LIB=$(TEST_TARGET_DIR)/$(addsuffix .a,$(addprefix lib,$(TARGET_NAME)))

TEST_SRC=$(call get_src_from_dir_list,$(TEST_SRC_DIRS))
test_obj=$(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(TEST_SRC)))
TEST_OBJ=$(addprefix $(TEST_OBJ_DIR)/,$(test_obj))
TEST_INC=$(call get_inc_from_dir,$(TEST_INC_DIR))
TEST_LIBS=$(addprefix lib,$(addsuffix .a,$(TEST_LIB_LIST)))

# CppUTest test harness source code
CPPUTEST_INC=$(call get_inc_from_dir_list,$(call get_subdirs,$(CPPUTEST_INC_DIR)/))
CPPUTEST_LIBS=$(addprefix lib,$(addsuffix .a,$(CPPUTEST_LIB_LIST)))


### Helper functions ###
get_subdirs = $(patsubst %/,%,$(sort $(dir $(wildcard $1*/))))
get_src_from_dir = $(wildcard $1/*.c) $(wildcard $1/*.cpp)
get_src_from_dir_list = $(foreach dir, $1, $(call get_src_from_dir,$(dir)))
get_inc_from_dir = $(wildcard $1/*.h)
get_inc_from_dir_list = $(foreach dir, $1, $(call get_inc_from_dir,$(dir)))
#"test" echo; used for checking makefile parameters
techo=@echo "${BoldPurple}  $1:${NoColor}"; echo $2; echo;


### Makefile targets ###
.PHONY: all rebuild check clean cleanp
.PHONY: test rebuildt cleant
.PHONY: dirlist filelist flags colortest help


### Production code rules ###
all: $(TARGET)

rebuild:
	@echo "${Blue}"
	make clean
	@echo "${Blue}"
	make all

check: $(TARGET)
	@echo "${BoldCyan}Contents of archive:${NoColor}"
	nm $(TARGET)

$(TARGET): $(SRC_OBJ)
	@echo "\n${Yellow}Archiving $(notdir $@)...${NoColor}"
	@echo "${DarkGray}Production${NoColor}"
	$(SILENCE)mkdir -p $(dir $@)
	$(SILENCE)$(ARCHIVER) $(ARCHIVER_FLAGS) $(TARGET) $(SRC_OBJ)
	@echo "${Green}...Archive created!\n${NoColor}"

$(OBJ_DIR)/%.o: %.c
	@echo "\n${Yellow}Compiling $(notdir $<)...${NoColor}"
	@echo "${DarkGray}Production${NoColor}"
	$(SILENCE)mkdir -p $(dir $@)
	$(SILENCE)$(COMPILER) $(COMPILER_FLAGS) $< $(INCLUDE_FLAGS) -o $@

clean:
	@echo "${Yellow}Cleaning project...${NoColor}"
	$(SILENCE)rm -rf $(TARGET_DIR)
	$(SILENCE)rm -rf $(OBJ_DIR)
	$(SILENCE)rm -rf $(TEST_OBJ_DIR)
	$(SILENCE)rm -rf $(TEST_TARGET_DIR)
	@echo "${Green}...Clean finished!${NoColor}\n"

cleanp:
	@echo "${Yellow}Cleaning production code...${NoColor}"
	$(SILENCE)rm -rf $(TARGET_DIR)
	$(SILENCE)rm -rf $(OBJ_DIR)
	@echo "${Green}...Clean finished!${NoColor}\n"


### Test code rules ###
test: $(TEST_TARGET)
	@echo "\n${Yellow}Executing $(notdir $<)...${NoColor}"
	@echo
	$(SILENCE)$(TEST_TARGET)
	@echo "\n${Green}...Tests executed!${NoColor}\n"

rebuildt:
	@echo "${Blue}"
	make clean
	@echo "${Blue}"
	make test

cleant:
	@echo "${Yellow}Cleaning test code...${NoColor}"
	$(SILENCE)rm -rf $(TEST_OBJ_DIR)
	$(SILENCE)rm -rf $(TEST_TARGET_DIR)
	@echo "${Green}...Clean finished!${NoColor}\n"

# Be SURE to link the test objects before the source code library!!
# This is what enables link-time substitution
$(TEST_TARGET): $(TEST_OBJ) $(TARGET)
	@echo "\n${Yellow}Linking $(notdir $@)...${NoColor}"
	@echo "${DarkGray}test${NoColor}"
	$(SILENCE)mkdir -p $(dir $@)
	$(SILENCE)$(TEST_LINKER) -o $@ $^ $(LINKER_FLAGS) $(TEST_LINKER_FLAGS) $(CPPUTEST_LINKER_FLAGS)

$(TEST_OBJ_DIR)/%.o: %.c
	@echo "\n${Yellow}Compiling $(notdir $<)...${NoColor}"
	$(SILENCE)mkdir -p $(dir $@)
	@echo "${DarkGray}test${NoColor}"
	$(SILENCE)$(TEST_COMPILER) $(COMPILER_FLAGS) $< -o $@ $(INCLUDE_FLAGS) $(TEST_INCLUDE_FLAGS) $(CPPUTEST_INCLUDE_FLAGS)

$(TEST_OBJ_DIR)/%.o: %.cpp
	@echo "\n${Yellow}Compiling $(notdir $<)...${NoColor}"
	$(SILENCE)mkdir -p $(dir $@)
	@echo "${DarkGray}test${NoColor}"
	$(SILENCE)$(TEST_COMPILER) $(COMPILER_FLAGS) $< -o $@ $(INCLUDE_FLAGS) $(TEST_INCLUDE_FLAGS) $(CPPUTEST_INCLUDE_FLAGS)


### Targets for debugging this makefile ###
dirlist:
	@echo "\n${BoldCyan}Build results:"
	$(call techo,TARGET_DIR,$(TARGET_DIR))
	$(call techo,OBJ_DIR,$(OBJ_DIR))

	@echo "\n${BoldCyan}Library code:${NoColor}"
	$(call techo,SRC_DIRS,$(SRC_DIRS))
	$(call techo,INC_DIRS,$(INC_DIRS))

	@echo "\n${BoldCyan}Test code:${NoColor}"
	$(call techo,TEST_SRC_DIRS,$(TEST_SRC_DIRS))
	$(call techo,TEST_INC_DIR,$(TEST_INC_DIR))
	$(call techo,TEST_LIB_DIRS,$(TEST_LIB_DIRS))

	@echo "\n${BoldCyan}CppUTest code:${NoColor}"
	$(call techo,CPPUTEST_PATH,"$(CPPUTEST_PATH)\c")
	$(call shell_search_for_dir,$(CPPUTEST_PATH))
	@if [ "`ls $(CPPUTEST_PATH)/.. | grep $(CPPUTEST_DIR)`" = $(CPPUTEST_DIR) ]; then \
    echo "${Green}$(CPPUTEST_DIR) directory found!${NoColor}\n"; \
  else\
    echo "${Red}$(CPPUTEST_DIR) directory not found!${NoColor}\n";\
  fi
	$(call techo,CPPUTEST_INC_DIR,$(CPPUTEST_INC_DIR))
	$(call techo,CPPUTEST_LIB_DIR,$(CPPUTEST_LIB_DIR))

filelist:
	$(call techo,TARGET,$(TARGET))
	@echo "\n${BoldCyan}Library code:${NoColor}"
	$(call techo,SRC,$(SRC))
	$(call techo,SRC_OBJ,$(SRC_OBJ))
	$(call techo,INC,$(INC))

	@echo "\n${BoldCyan}Test code:${NoColor}"
	$(call techo,TARGET_LIB,$(TARGET_LIB))
	$(call techo,TEST_TARGET,$(TEST_TARGET))
	$(call techo,TEST_SRC,$(TEST_SRC))
	$(call techo,TEST_OBJ,$(TEST_OBJ))
	$(call techo,TEST_INC,$(TEST_INC))
	$(call techo,TEST_LIBS,$(TEST_LIBS))

	@echo "\n${BoldCyan}CppUTest code:${NoColor}"
# This is a very lengthy list
	@echo "$(Yellow) Suppresed CPPUTEST_INC list due to its length.\n"
#	$(call techo,CPPUTEST_INC,$(CPPUTEST_INC))
	$(call techo,CPPUTEST_LIBS,$(CPPUTEST_LIBS))

flags:
	@echo "\n${BoldCyan}Library code${NoColor}"
	$(call techo,COMPILER_FLAGS,$(COMPILER_FLAGS))
	$(call techo,INCLUDE_FLAGS,$(INCLUDE_FLAGS))
	$(call techo,ARCHIVER_FLAGS,$(ARCHIVER_FLAGS))

	@echo "\n${BoldCyan}Test code${NoColor}"
	$(call techo,TEST_COMPILER_FLAGS,$(TEST_COMPILER_FLAGS))
	$(call techo,TEST_INCLUDE_FLAGS,$(TEST_INCLUDE_FLAGS))
	$(call techo,ARCHIVER_FLAGS,$(ARCHIVER_FLAGS))
	$(call techo,TEST_LINKER_FLAGS,$(TEST_LINKER_FLAGS))

	@echo "\n${BoldCyan}CppUTest code${NoColor}"
	$(call techo,CPPUTEST_COMPILER_FLAGS,$(CPPUTEST_COMPILER_FLAGS))
	$(call techo,CPPUTEST_INCLUDE_FLAGS,$(CPPUTEST_INCLUDE_FLAGS))
	$(call techo,CPPUTEST_LINKER_FLAGS,$(CPPUTEST_LINKER_FLAGS))

help:
	@echo "${BoldCyan}Production code options:${NoColor}"
	@echo "all:\t\tArchive all updated production code"
	@echo "rebuild:\tClean and re-archive all production code"
	@echo "check:\t\tInspect the contents of the archive (create archive if necessary)"
	@echo "clean:\t\tClean all production (and test) code"
	@echo "cleanp:\t\tClean production code only"
	@echo
	@echo "${BoldCyan}Test code options:${NoColor}"
	@echo "test:\t\tCompile all updated test code and run all tests"
	@echo "rebuildt:\tClean and recompile all test code, run all tests"
	@echo
	@echo "${BoldCyan}Makefile debugging options:${NoColor}"
	@echo "dirlist:\tList all directories detected and used by the project"
	@echo "filelist:\tList all files detected and used by the project"
	@echo "flags:\t\tList all flags"
	@echo "colortest:\tEcho text in every color"
	@echo "help:\t\tThis"

colortest:
	@echo "${Blue}Blue${NC}\t\tdefault"
	@echo "${BoldBlue}BoldBlue${NC}\tdefault"
	@echo "${Gray}Gray${NC}\t\tdefault"
	@echo "${DarkGray}DarkGray${NC}\tdefault"
	@echo "${Green}Green${NC}\t\tdefault"
	@echo "${BoldGreen}BoldGreen${NC}\tdefault"
	@echo "${Cyan}Cyan${NC}\t\tdefault"
	@echo "${BoldCyan}BoldCyan${NC}\tdefault"
	@echo "${Red}Red${NC}\t\tdefault"
	@echo "${BoldRed}BoldRed${NC}\t\tdefault"
	@echo "${Purple}Purple${NC}\t\tdefault"
	@echo "${BoldPurple}BoldPurple${NC}\tdefault"
	@echo "${Yellow}Yellow${NC}\t\tdefault"
	@echo "${BoldYellow}BoldYellow${NC}\tdefault"
	@echo "${BoldWhite}BoldWhite${NC}\tdefault"
	@echo "${NoColor}NoColor${NC}\t\tdefault"

### Color codes ###
Blue       =\033[0;34m
BoldBlue   =\033[1;34m
Gray       =\033[0;37m
DarkGray   =\033[1;30m
Green      =\033[0;32m
BoldGreen  =\033[1;32m
Cyan       =\033[0;36m
BoldCyan   =\033[1;36m
Red        =\033[0;31m
BoldRed    =\033[1;31m
Purple     =\033[0;35m
BoldPurple =\033[1;35m
Yellow     =\033[0;33m
BoldYellow =\033[1;33m
BoldWhite  =\033[1;37m
NoColor    =\033[0;0m
NC         =\033[0;0m


### Documentation ###
# $@	the name of the target
# $<	the name of the first prerequisite
# $^	the names of all prerequisites separated by a space

#ar [-]p [mod] <archive> <members ...>
#p:
#r  Add files into archive with replacement
#[mod]:
#v  Verbose mode
#c  Create the archive if it does not already exist.
#s  Add an index to the archive. Helps with linking. Equivalent to ranlib [?].
#[Use nm-s to display this index]

# $(call <function>,<param>,<param>,...)
# make sure you put a comma directly after <function>. If you don't it won't work.

# $(foreach <varname>,<list>,<body>)

# $(wildcard <pattern ...>)
# is replaced with a space-separated list of names that match the pattern.

# $(patsubst <pattern>,<replacement>,<text_to_search>)

# $(addprefix <prefix>,<names_to_edit>)

# $(notdir <names ...>)
# extract the non-directory part of each filename

# mkdir -p
# make parent directories as needed

#Order from LPCXpresso
#{COMMAND} ${FLAGS} ${OUTPUT_FLAG} ${OUTPUT_PREFIX}${OUTPUT} ${INPUTS}

# get_subdirs
# Be sure to include a trailing '/' when calling get_subdirs!
# wildcard $1*/        returns all files and folders within the path $1
# dir                  limits this result to only directories
# sort                 sorts this list
# patsubst %/,%,<list>  removes an unneeded trailing '/'
