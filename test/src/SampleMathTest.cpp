extern "C"
{
  // #includes with C linkage
  #include "SampleMath.h"
}

// #include with C++ linkage
#include "CppUTest/TestHarness.h"
#include "SampleMathTest.h"

TEST_GROUP(SampleMathTest)
{
  void setup()
  {
  }
  void teardown()
  {
  }
};

TEST(SampleMathTest, Wiring)
{
  FAIL("SampleMathTest wired properly!");
}
