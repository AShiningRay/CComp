// Malloc, calloc and realloc test file in C (NOT WORKING - POINTER ERROR)

#include <stdio.h>
#include <stdlib.h>

int main() {
  // Allocate memory for an array of 10 integers using malloc()
  int *array = malloc(sizeof(int) * 10);
  if (array == NULL) {
    perror("Error allocating memory with malloc()");
    return 1;
  }

  // Initialize the elements of the array to 0 using calloc()
  int *array2 = calloc(10, sizeof(int));
  if (array2 == NULL) {
    perror("Error allocating memory with calloc()");
    return 1;
  }

  // Resize the array using realloc()
  array = realloc(array, sizeof(int) * 20);
  if (array == NULL) {
    perror("Error reallocating memory with realloc()");
    return 1;
  }

  // Free the memory allocated for the arrays
  free(array);
  free(array2);

  return 0;
}