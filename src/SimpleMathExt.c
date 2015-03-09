#include "SampleMathExt.h"

int SampleMathExt_Power(int base, unsigned int exponent)
{
  unsigned int i = 0;
  int result;

  result = 1;
  while (i < exponent)
  {
    result *= base;
    i++;
  }
  return result;
}
