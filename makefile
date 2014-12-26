SILENCE=@

### Name of output file ###
TARGET_NAME=libMyMath
target=$(TARGET_DIR)/$(TARGET_NAME)
TARGET=$(addsuffix .a,$(target))

### Compiler tools ###
CCOMPILER=gcc
#name this better
ARCHIVER=ar

### Directory structure ###
SRC_DIR=src
INC_DIR=inc
OBJ_DIR=obj
TARGET_DIR=build

### Automatically detect source code and create object files ###
SRC=$(wildcard $(SRC_DIR)/*.c)
obj=$(patsubst %.c,%.o,$(SRC))
OBJ=$(addprefix $(OBJ_DIR)/,$(obj))

### Flags ###
CCOMPILER_FLAGS=-c
ifdef SILENCE
ARCHIVER_FLAGS=rcs
else
ARCHIVER_FLAGS=rvcs
endif

.PHONY: all

all: $(TARGET)

$(TARGET): $(OBJ)
	@echo "\n${Yellow}Archiving $(notdir $@)...${NoColor}"
	$(SILENCE)mkdir -p $(dir $@)
	$(SILENCE)$(ARCHIVER) $(ARCHIVER_FLAGS) $(TARGET) $(OBJ)
	@echo "${Green}...Archive created!${NoColor}\n"

$(OBJ_DIR)/%.o: %.c
	@echo "\n${Yellow}Compiling $(notdir $<)...${NoColor}"
	$(SILENCE)mkdir -p $(dir $@)
	$(SILENCE)$(CCOMPILER) $(CCOMPILER_FLAGS) $^ -I$(INC_DIR) -o $@

makefiletest:
	@echo $(TARGET)

clean:
	@echo "${Yellow}Cleaning archive...${NoColor}"
	$(SILENCE)rm -rf $(OBJ_DIR) $(TARGET_DIR)
	@echo "${Green}...Clean finished!${NoColor}"

colortest:
	@echo "${Blue}Blue${NC}"
	@echo "${LightBlue}LightBlue${NC}"
	@echo "${Gray}Gray${NC}"
	@echo "${DarkGray}DarkGray${NC}"
	@echo "${Green}Green${NC}"
	@echo "${LightGreen}LightGreen${NC}"
	@echo "${Cyan}Cyan${NC}"
	@echo "${LightCyan}LightCyan${NC}"
	@echo "${Red}Red${NC}"
	@echo "${LightRed}LightRed${NC}"
	@echo "${Purple}Purple${NC}"
	@echo "${LightPurple}LightPurple${NC}"
	@echo "${Orange}Orange${NC}"
	@echo "${Yellow}Yellow${NC}"
	@echo "${White}White${NC}"
	@echo "${NoColor}NoColor${NC}"

### Color codes ###
Blue       =\033[0;34m
LightBlue  =\033[1;34m
Gray       =\033[0;37m
DarkGray   =\033[1;30m
Green      =\033[0;32m
LightGreen =\033[1;32m
Cyan       =\033[0;36m
LightCyan  =\033[1;36m
Red        =\033[0;31m
LightRed   =\033[1;31m
Purple     =\033[0;35m
LightPurple=\033[1;35m
Yellow     =\033[0;33m
LihtYellow =\033[1;33m
White      =\033[0;37m
NoColor    =\033[0;0m

### Documentation ###
#ar [-]p [mod] <archive> <members ...>
#p:
#r  Add files into archive with replacement

#[mod]:
#v  Verbose mode
#c  Create the archive if it does not already exist.
#s  Add an index to the archive. Helps with linking. Equivalent to ranlib [?].
#[Use nm-s to display this index]
