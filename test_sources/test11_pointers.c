#include <stdio.h>

int main () 
{
	int a=2, b=3, *aa = &a, *ba = &a;

	*a = *b;
	b = a;
	&a = b;

	printf("a val: %d", *a);

	return 0;
}
