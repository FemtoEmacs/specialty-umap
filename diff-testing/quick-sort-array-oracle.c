#include <stdio.h>

void swapAt(int data[], int i, int j)
{
    int left = data[i];
    int right = data[j];

    data[i] = right;
    data[j] = left;
}

int partitionIndexed(int data[], int high, int scan, int boundary)
{
    if (scan < high) {
        int pivot = data[high];
        int current = data[scan];

        if (current < pivot) {
            swapAt(data, scan, boundary);
            return partitionIndexed(data, high, scan + 1, boundary + 1);
        } else {
            return partitionIndexed(data, high, scan + 1, boundary);
        }
    } else {
        swapAt(data, boundary, high);
        return boundary;
    }
}

void quicksortIndexedRange(int data[], int low, int high)
{
    if (low < high) {
        int pivotIndex =
            partitionIndexed(data, high, low, low);

        if (pivotIndex != 0)
            quicksortIndexedRange(data, low, pivotIndex - 1);

        quicksortIndexedRange(data, pivotIndex + 1, high);
    }
}

void quicksortIndexed(int data[], int size)
{
    if (size != 0)
        quicksortIndexedRange(data, 0, size - 1);
}

int main(void)
{
    int data[] = {7, 2, 9, 1, 5};
    int size = sizeof(data) / sizeof(data[0]);

    quicksortIndexed(data, size);

    for (int i = 0; i < size; i++)
        printf("%d ", data[i]);

    printf("\n");

    return 0;
}
