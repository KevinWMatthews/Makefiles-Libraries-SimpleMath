#include "SampleMathExt.h"

int SampleMathExt_Power(int base, unsigned int exponent)
{
  unsigned int i;
  int result;

  result = 1;
  while (i < exponent)
  {
    result *= base;
  }
  return result;
}
