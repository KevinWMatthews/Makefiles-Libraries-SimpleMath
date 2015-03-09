# Set this to @ to keep the makefile quiet
ifndef SILENCE
	SILENCE =
endif

### Directory structure ###
# Output file
TARGET_NAME=libSampleMath
TARGET_DIR=build

# Production code
SRC_DIRS=src
INC_DIRS=inc
#LIB_DIRS=
#Static library names without lib prefix and .a suffix
#LIB_LIST=Careful...
OBJ_DIR=obj

# CppUTest test harness source code
CPPUTEST_DIR=cpputest-3.6
CPPUTEST_PATH=../../../$(CPPUTEST_DIR)
CPPUTEST_INC_DIR=$(CPPUTEST_PATH)/include
CPPUTEST_LIB_DIR=$(CPPUTEST_PATH)/lib
CPPUTEST_LIB_LIST=CppUTest CppUTestExt

# User unit tests
TEST_DIR=test
TEST_SRC_DIRS=$(TEST_DIR)/src $(TEST_DIR)/mocks
TEST_INC_DIR=$(TEST_DIR)/inc
TEST_LIB_DIRS=$(TEST_DIR)/lib
#Static library names without lib prefix and .a suffix
TEST_LIB_LIST=
TEST_TARGET_DIR=$(TEST_DIR)/build
TEST_OBJ_DIR=$(TEST_DIR)/$(OBJ_DIR)


### Compiler tools ###
COMPILER=gcc
LINKER=gcc
ARCHIVER=ar
TEST_COMPILER=g++
TEST_LINKER=g++


# Do the real work
include MakefileWorker.make
