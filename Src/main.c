/**
 ******************************************************************************
 * @project        : EE2028 Assignment 1 Program Template
 * @file           : main.c
 * @author         : Ni Qingqing, ECE, NUS
 * @brief          : Main program body
 ******************************************************************************
 * @attention
 *
 * <h2><center>&copy; Copyright (c) 2021 STMicroelectronics.
 * All rights reserved.</center></h2>
 *
 * This software component is licensed by ST under BSD 3-Clause license,
 * the "License"; You may not use this file except in compliance with the
 * License. You may obtain a copy of the License at:
 *                        opensource.org/licenses/BSD-3-Clause
 *
 ******************************************************************************
 */

#include "stdio.h"

#define M 8	 // No. of numbers in array


// Insertion sort implementation in C
int insertion_sort_C(int arr[ ], int n) {
	/*tracking no. of swaps performed.*/
	int swaps = 0;

	for( int i = 0 ;i < n ; i++ ) {
    	 /*storing current element whose left side is checked for its correct position.*/
    	 int temp = arr[ i ];
         int j = i;

       /* check if the adjacent element to the left is greater than the current element. */
          while(  j > 0  && temp < arr[ j-1 ]) {
           // moving the left side element to one position forward.
                arr[ j ] = arr[ j-1 ];
                j = j - 1;
                swaps++;
           }
         // moving current element to its  correct position.
           arr[ j ] = temp;
     }
	return swaps;
}

// function to print an array
void printArray(int arr[], int size, int swaps) {
	printf("With %d swaps, the array is sorted as: \n{ ", swaps);
	for (int i = 0; i < size; ++i) {
		printf("%d  ", arr[i]);
	}
	printf("}\n");
}


// Necessary function to enable printf() using semihosting
extern void initialise_monitor_handles(void);

// Functions to be written
extern int insertion_sort(int* arg1, int arg2);

int main(void)
{
	// Necessary function to enable printf() using semihosting
	initialise_monitor_handles();

	int arr[M] = {-23, -50, -99, 0, -120, 33, 12, 5};
	int swaps;

	// sort with insertion_sort.s
	swaps = insertion_sort((int*)arr, (int)M);
	printf("output from insertion_sort.s: \n");
	printArray(arr, M, swaps);



	//sort with insertion_sort_C:
	int arr_C[M] = {-23, -50, -99, 0, -120, 33, 12, 5};
	swaps = insertion_sort_C(arr_C, M);
	printf("\n \noutput from insertion_sort_C: \n");
	printArray(arr_C, M, swaps);

}



