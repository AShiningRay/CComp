#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) 
{
    char argvdummy[10], test[2];

    for (int i = 0; i < argc; i++)
    {
        printf("argv[%d] = %s\n", i, argv[i]);
        argvdummy[i] = argv[i];
    }

    return 0;
}