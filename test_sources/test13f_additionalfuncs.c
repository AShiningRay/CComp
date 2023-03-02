#include <stdio.h>

void test(int n1, int n2);
void empty();

int main()
{
	test(0, 1);
	return 0;
}

void test(int n1, int n2){
	int n3 = n1+n2;
}

void empty() { ; }