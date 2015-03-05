# Set this to @ to keep the makefile quiet
ifndef SILENCE
	SILENCE =
endif

# Run unit tests
ifndef USE_CPPUTEST
	USE_CPPUTEST = N
endif


### Directory structure ###
# Output file
TARGET_NAME=libSampleMath
TARGET_DIR=build

# Production code
#Only supports a single directory
SRC_DIRS=src
INC_DIRS=inc
#LIB_DIRS=
#Static library names without lib prefix and .a suffix
#LIB_LIST=Careful...
OBJ_DIR=obj


### Compiler tools ###
COMPILER=gcc
LINKER=gcc
ARCHIVER=ar

# Do the real work
include MakefileWorker.make
