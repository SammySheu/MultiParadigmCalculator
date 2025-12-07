#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define MAX_MODES 100  /* Maximum number of modes to track */

/* Structure to hold mode results (can have multiple modes) */
typedef struct {
    int values[MAX_MODES];
    int count;
    int frequency;
} ModeResult;

/* ============================================================================
 * UTILITY FUNCTIONS
 * ============================================================================ */

/**
 * Comparison function for qsort - sorts integers in ascending order
 * 
 * @param a Pointer to first integer
 * @param b Pointer to second integer
 * @return Negative if a < b, positive if a > b, zero if equal
 */
int compare_ints(const void *a, const void *b) {
    return (*(int *)a - *(int *)b);
}

/**
 * Prints an array of integers
 * 
 * @param arr Array of integers to print
 * @param size Number of elements in the array
 */
void print_array(int arr[], int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]\n");
}

/**
 * Creates a copy of an array (to preserve original during sorting)
 * 
 * @param src Source array
 * @param size Number of elements
 * @return Pointer to newly allocated copy (caller must free)
 */
int* copy_array(int src[], int size) {
    int *copy = (int *)malloc(size * sizeof(int));
    if (copy == NULL) {
        fprintf(stderr, "Error: Memory allocation failed\n");
        exit(1);
    }
    memcpy(copy, src, size * sizeof(int));
    return copy;
}

/**
 * Calculates the arithmetic mean (average) of an array of integers
 * 
 * The mean is computed by summing all elements and dividing by the count.
 * 
 * @param arr Array of integers
 * @param size Number of elements in the array
 * @return The mean as a double
 */
double calculate_mean(int arr[], int size) {
    if (size == 0) {
        return 0.0;
    }
    
    long sum = 0;  /* Using long to prevent overflow with large arrays */
    for (int i = 0; i < size; i++) {
        sum += arr[i];
    }
    
    return (double)sum / size;
}

/**
 * Calculates the median of an array of integers
 * 
 * The median is the middle value when the data is sorted. For an even number
 * of elements, it's the average of the two middle values.
 * 
 * @param arr Array of integers (will not be modified)
 * @param size Number of elements in the array
 * @return The median as a double
 */
double calculate_median(int arr[], int size) {
    if (size == 0) {
        return 0.0;
    }
    
    /* Create a sorted copy to preserve original array */
    int *sorted = copy_array(arr, size);
    qsort(sorted, size, sizeof(int), compare_ints);
    
    double median;
    if (size % 2 == 0) {
        /* Even number of elements: average of two middle values */
        int mid1 = sorted[size / 2 - 1];
        int mid2 = sorted[size / 2];
        median = (mid1 + mid2) / 2.0;
    } else {
        /* Odd number of elements: middle value */
        median = sorted[size / 2];
    }
    
    free(sorted);  /* Clean up allocated memory */
    return median;
}

/**
 * Calculates the mode(s) of an array of integers
 * 
 * The mode is the most frequently occurring value(s). This function handles
 * multiple modes (multimodal data) by returning all values with the highest
 * frequency.
 * 
 * @param arr Array of integers
 * @param size Number of elements in the array
 * @param result Pointer to ModeResult structure to store results
 */
void calculate_mode(int arr[], int size, ModeResult *result) {
    result->count = 0;
    result->frequency = 0;
    
    if (size == 0) {
        return;
    }
    
    /* Create a sorted copy for efficient counting */
    int *sorted = copy_array(arr, size);
    qsort(sorted, size, sizeof(int), compare_ints);
    
    /* First pass: find the maximum frequency */
    int max_freq = 1;
    int current_freq = 1;
    
    for (int i = 1; i < size; i++) {
        if (sorted[i] == sorted[i - 1]) {
            current_freq++;
        } else {
            if (current_freq > max_freq) {
                max_freq = current_freq;
            }
            current_freq = 1;
        }
    }
    if (current_freq > max_freq) {
        max_freq = current_freq;
    }
    
    result->frequency = max_freq;
    
    /* Second pass: collect all values with maximum frequency */
    current_freq = 1;
    for (int i = 1; i <= size; i++) {
        if (i < size && sorted[i] == sorted[i - 1]) {
            current_freq++;
        } else {
            if (current_freq == max_freq && result->count < MAX_MODES) {
                result->values[result->count++] = sorted[i - 1];
            }
            current_freq = 1;
        }
    }
    
    free(sorted);  /* Clean up allocated memory */
}

/* ============================================================================
 * DISPLAY FUNCTIONS
 * ============================================================================ */

/**
 * Prints the mode result in a formatted way
 * 
 * @param result Pointer to ModeResult structure
 */
void print_mode_result(ModeResult *result) {
    if (result->count == 0) {
        printf("Mode: No mode (empty dataset)\n");
        return;
    }
    
    if (result->count == 1) {
        printf("Mode: %d (appears %d time%s)\n", 
               result->values[0], 
               result->frequency,
               result->frequency == 1 ? "" : "s");
    } else {
        printf("Modes: [");
        for (int i = 0; i < result->count; i++) {
            printf("%d", result->values[i]);
            if (i < result->count - 1) {
                printf(", ");
            }
        }
        printf("] (each appears %d times)\n", result->frequency);
    }
}

/* ============================================================================
 * MAIN PROGRAM
 * ============================================================================ */

int main() {
    printf("This program uses the StatisticsCalculator class to calculate the mean, median, and mode of a dataset.");
    
    while (1) {
        char dataset[100];
        printf("Enter a dataset (comma separated. e.g. 1,2,3,4,5):  or 'q' to quit): ");
        fgets(dataset, sizeof(dataset), stdin);
        dataset[strcspn(dataset, "\n")] = 0;
        if (strcmp(dataset, "q") == 0) {
            break;
        }
        int dataset_int[100];
        int size = strlen(dataset);
        int j = 0;
        for (int i = 0; i < size; i++) {
            if (dataset[i] == ',' || dataset[i] == ' ') {
                continue;
            }
            dataset_int[j] = dataset[i] - '0';
            j++;
        }
        size = j;
        printf("Data: ");
        print_array(dataset_int, size);
        printf("Size: %d elements\n", size);
        
        /* Calculate and display mean */
        double median = calculate_median(dataset_int, size);
        printf("Median: %.2f\n", median);
        
        /* Calculate and display mode */
        ModeResult mode_result;
        calculate_mode(dataset_int, size, &mode_result);
        print_mode_result(&mode_result);
    }
    
    return 0;
}

