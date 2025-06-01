/**
 * @author: Mitul Tyagi
 * @description: This code demonstrates the use of a custom section in C.
 */
#define my_section __attribute__((section(".mysection")))

int my_section val = 10;
int my_section ret = 20;
static int g = 123;
int fval = 34;
extern int test(char);
extern char b;
int foo()
{
    return (fval * g) + 3;
}

int sample()
{
    int char_ascii = test(b);
}