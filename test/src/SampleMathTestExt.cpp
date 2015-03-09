extern "C"
{
  // #includes with C linkage
  #include "SampleMathExt.h"
  #include <math.h>
}

// #include with C++ linkage
#include "CppUTest/TestHarness.h"
#include "SampleMathTestExt.h"

TEST_GROUP(SampleMathTestExt)
{
  void setup()
  {
  }
  void teardown()
  {
  }
};

// TEST(SampleMathTestExt, Wiring)
// {
//   FAIL("SampleMathTestExt wired properly!");
// }

TEST(SampleMathTestExt, Power)
{
  LONGS_EQUAL(pow(2, 3), SampleMathExt_Power(2, 3));
}
