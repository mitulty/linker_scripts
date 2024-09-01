/**
 * @Author: Mitul Tyagi
 * @Date:   2024-09-01 14:21:48
 * @Description: defintion of test()
 * @Last Modified time: 2024-09-01 15:20:49
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

int init_global = 145;
int uninit_global[2];

static char static_init_global = 'a';
static int static_uninit_global;

char b = 'b';

int test(char a)
{
    return (int)a;
}

void data_func(void)
{
    int local_var = 5;
    static int static_init_local = 'a';
    static int static_uninit_local;
    return;
}