#include <stdio.h>

__declspec(dllexport) void hello(int a, int b) {
    printf("hello: %d\n", a + b);
}
