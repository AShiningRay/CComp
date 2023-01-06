// Array test file in C (NOT WORKING - ARRAY ERROR)

#include <stdio.h>

#define ARRAY_SIZE 10

int main() {
  // Declare and initialize an array of integers
  int array[ARRAY_SIZE] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

  // Print the elements of the array
  for (int i = 0; i < ARRAY_SIZE; i++) {
    printf("%d ", array[i]);
  }
  printf("\n");

  // Modify the elements of the array
  for (int i = 0; i < ARRAY_SIZE; i++) {
    array[i] *= 2;
  }

  // Print the modified elements of the array
  for (int i = 0; i < ARRAY_SIZE; i++) {
    printf("%d ", array[i]);
  }
  printf("\n");

  return 0;
}