
// Writing test file in C (NOT WORKING - POINTER ERROR, parses but semantically it should fail)

#include <stdio.h>

int main()
{
    // Open a file for writing
    FILE *file = fopen("output.txt", "w");

    // Check if the file was opened successfully
    if (file == NULL) {
        perror("Error opening file");
        return 1;
    }

    // Write some text to the file
    fprintf(file, "Hello, world!");

    // Close the file
    fclose(file);

    return 0;
}


