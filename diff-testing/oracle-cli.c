#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

#define main preserved_oracle_demo_main
#include "quick-sort-array-oracle.c"
#undef main

int main(int argc, char **argv)
{
    int size = argc - 1;
    int *data = size ? malloc((size_t)size * sizeof(*data)) : NULL;
    if (size && !data)
        return 2;

    for (int i = 0; i < size; ++i) {
        char *end = NULL;
        errno = 0;
        long value = strtol(argv[i + 1], &end, 10);
        if (errno || *end != '\0' || value < INT_MIN || value > INT_MAX) {
            free(data);
            return 2;
        }
        data[i] = (int)value;
    }

    quicksortIndexed(data, size);
    for (int i = 0; i < size; ++i)
        printf(i ? " %d" : "%d", data[i]);
    putchar('\n');
    free(data);
    return 0;
}
