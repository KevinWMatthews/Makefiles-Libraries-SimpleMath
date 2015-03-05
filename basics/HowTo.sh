#The basics of how to compile and link to a static library.
#This example is hard-coded to these specific files and directories!
#This is done to simplify the example.

#To explore the basics, run these commands fromt the root directory (not basics)

#Our test program can be compiled and run by directly using the object file:
gcc basics/main.c src/SampleMath.c -Iinc -o basics/main_src
./basics/main_src


#To clean things and start fresh,
rm -rf basics/main_src basics/main_lib obj build

#Create the static library
#First generate the library's object files
mkdir obj
gcc -c src/SampleMath.c -Iinc -o obj/SampleMath.o

#Then create the archive file
mkdir build
ar rcvs build/libSampleMath.a obj/SampleMath.o

#Verify the contents of the library
nm build/libSampleMath.a

#Now link our basic test program with the library
gcc basics/main.c -Iinc -o basics/main_lib -Lbuild -lSampleMath
# -I gives the location of the library's include files
# -L gives the path to the library archive file
# -l gives the name of the library without the lib prefix or .a suffix
# You might need to add in the static keyword

#Run our test program!
./basics/main_lib
