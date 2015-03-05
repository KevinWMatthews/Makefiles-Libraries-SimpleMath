// A simple program that uses all of the functions without compiling them into a library.
// Gotta make sure the C code actually works.
// Replace with TDD

#include <stdio.h>
#include "SampleMath.h"

int main(int argc, char * argv[])
{
  int res;
  float fres;

  res = SampleMath_Add(2, 3);
  printf("Add: %d\n", res);
  res = SampleMath_Subtract(2, 3);
  printf("Subtract: %d\n", res);
  res = SampleMath_Multiply(2, 3);
  printf("Multiply: %d\n", res);
  fres = SampleMath_Divide(2, 3);
  printf("Divide: %f\n", fres);
  printf("\n");

  return 0;
}
