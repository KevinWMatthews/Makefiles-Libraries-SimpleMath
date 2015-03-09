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

// TEST(SampleMathTest, Wiring)
// {
//   FAIL("SampleMathTest wired properly!");
// }

TEST(SampleMathTest, Add)
{
  LONGS_EQUAL(7+5, SampleMath_Add(7, 5))
  LONGS_EQUAL(-7-5, SampleMath_Add(-7, -5))
}

TEST(SampleMathTest, Divide)
{
  DOUBLES_EQUAL(7/5, SampleMath_Divide(7, 5), 6)
  DOUBLES_EQUAL(-7/-5, SampleMath_Divide(-7, -5), 6)
}

TEST(SampleMathTest, Multiply)
{
  LONGS_EQUAL(7*5, SampleMath_Multiply(7, 5))
  LONGS_EQUAL(-7*-5, SampleMath_Multiply(-7, -5))
}

TEST(SampleMathTest, Subtract)
{
  LONGS_EQUAL(7-5, SampleMath_Subtract(7, 5))
  LONGS_EQUAL(-7-(-5), SampleMath_Subtract(-7, -5))
}
