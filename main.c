/**
 * @Author: Mitul Tyagi
 * @Date:   2024-07-16 21:07:59
 * @Description: basic code
 * @Last Modified time: 2024-09-01 16:04:07
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