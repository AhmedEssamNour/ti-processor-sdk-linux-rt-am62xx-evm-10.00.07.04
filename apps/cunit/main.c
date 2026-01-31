#include "Basic.h"
#include "TestDB.h"

void test_addition(void)
{
    CU_ASSERT(1 + 1 == 2);
}

void test_subtraction(void)
{
    CU_ASSERT(1 - 1 == 0);
}

int main(void)
{
    printf("Hello from the other side!\n");

    CU_initialize_registry();

    CU_pSuite suite = CU_add_suite("basic_suite", NULL, NULL);
    CU_add_test(suite, "addition test", test_addition);
    CU_add_test(suite, "subtraction test", test_subtraction);

    CU_basic_run_tests();
    CU_cleanup_registry();

    return 0;
}
