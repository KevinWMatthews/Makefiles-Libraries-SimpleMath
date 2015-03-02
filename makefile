SILENCE=

### Name of output file ###
TARGET_NAME=libSampleMath
target=$(TARGET_DIR)/$(TARGET_NAME)
TARGET=$(addsuffix .a,$(target))

### Compiler tools ###
COMPILER=gcc
#name this better
ARCHIVER=ar

### Directory structure ###
SRC_DIR=src
INC_DIR=inc
OBJ_DIR=obj
TARGET_DIR=build

### Automatically detect source code and create object files ###
SRC=$(call get_src_from_dir,$(SRC_DIR))
#nest calls so we don't get a repetition of .c and .cpp files
src_obj=$(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(SRC)))
SRC_OBJ=$(addprefix $(OBJ_DIR)/,$(src_obj))
INC=$(call get_inc_from_dir,$(INC_DIR))

### Helper functions ###
get_src_from_dir = $(wildcard $1/*.c) $(wildcard $1/*.cpp)
get_inc_from_dir = $(wildcard $1/*.h)
#"test" echo; used for checking makefile parameters
techo=@echo "${BoldPurple}  $1:${NoColor}"; echo $2; echo;


### Flags ###
COMPILER_FLAGS=-c
ifdef SILENCE
ARCHIVER_FLAGS=rcs
else
ARCHIVER_FLAGS=rvcs
endif

.PHONY: rebuild all
.PHONY: dirlist filelist flags

rebuild:
	@echo "${Blue}"
	make clean
	@echo "${Blue}"
	make all

all: $(TARGET)

$(TARGET): $(SRC_OBJ)
	@echo "\n${Yellow}Archiving $(notdir $@)...${NoColor}"
	$(SILENCE)mkdir -p $(dir $@)
	$(SILENCE)$(ARCHIVER) $(ARCHIVER_FLAGS) $(TARGET) $(SRC_OBJ)
	@echo "${Green}...Archive created!${NoColor}"

$(OBJ_DIR)/%.o: %.c
	@echo "\n${Yellow}Compiling $(notdir $<)...${NoColor}"
	$(SILENCE)mkdir -p $(dir $@)
	$(SILENCE)$(COMPILER) $(COMPILER_FLAGS) $^ -I$(INC_DIR) -o $@

clean:
	@echo "${Yellow}Cleaning archive...${NoColor}"
	$(SILENCE)rm -rf $(OBJ_DIR) $(TARGET_DIR)
	@echo "${Green}...Clean finished!${NoColor}"


### Targets for debugging this makefile ###
dirlist:
	@echo "${BoldCyan}Library code:${NoColor}"
	$(call techo,SRC_DIR,$(SRC_DIR))
	$(call techo,INC_DIR,$(INC_DIR))

	@echo "\n${BoldCyan}Build results:"
	$(call techo,TARGET_DIR,$(TARGET_DIR))
	$(call techo,OBJ_DIR,$(OBJ_DIR))

filelist:
	$(call techo,TARGET,$(TARGET))
	@echo "\n${BoldCyan}Library code:"
	$(call techo,SRC,$(SRC))
	$(call techo,SRC_OBJ,$(SRC_OBJ))
	$(call techo,INC,$(INC))

flags:
	@echo "${BoldCyan}Library code${NoColor}"
	$(call techo,COMPILER_FLAGS,$(COMPILER_FLAGS))
	$(call techo,ARCHIVER_FLAGS,$(ARCHIVER_FLAGS))

colortest:
	@echo "${Blue}Blue${NC}"
	@echo "${BoldBlue}BoldBlue${NC}"
	@echo "${Gray}Gray${NC}"
	@echo "${DarkGray}DarkGray${NC}"
	@echo "${Green}Green${NC}"
	@echo "${BoldGreen}BoldGreen${NC}"
	@echo "${Cyan}Cyan${NC}"
	@echo "${BoldCyan}BoldCyan${NC}"
	@echo "${Red}Red${NC}"
	@echo "${BoldRed}BoldRed${NC}"
	@echo "${Purple}Purple${NC}"
	@echo "${BoldPurple}BoldPurple${NC}"
	@echo "${Yellow}Yellow${NC}"
	@echo "${BoldYellow}BoldYellow${NC}"
	@echo "${BoldWhite}BoldWhite${NC}"
	@echo "${NoColor}NoColor${NC}"

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
# $@	the name of the target of the rule
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
