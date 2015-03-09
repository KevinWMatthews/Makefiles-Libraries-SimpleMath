extern "C"
{
  // #includes with C linkage
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

TEST(SampleMathTestExt, Wiring)
{
  FAIL("SampleMathTestExt wired properly!");
}
