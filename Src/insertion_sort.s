/*
 * insertion_sort.s
 *
 *  Created on: 10/08/2023
 *      Author: Ni Qingqing
 */
   .syntax unified
	.cpu cortex-m4
	.fpu softvfp
	.thumb

		.global insertion_sort

@ Start of executable code
.section .text

@ EE2028 Assignment 1, Sem 1, AY 2023/24
@ (c) ECE NUS, 2023
@ Insertion Sort Array in Ascending Order

@ Write Student 1’s Name here: Li Zheng Ting (A0252496W)
@ Write Student 2’s Name here: Artem Moshnin (A0266642Y)

@ Note: In the comments of this code, we will be frequently referring to the next unsorted number in the array as "new number"

@ Initial Values of Registers:
@ - R0 => stores the (memory address) of (1st element) in the (input array)
@ - R1 => stores the (number of elements) in the (input array) (= length of the input array)

@ Future Values of Registers:
@ - R2 => (left number of array) when comparing (two adjacent numbers)
@ - R3 => (right number of array) when comparing (two adjacent numbers)

@ - R4 => to store (memory address) of ("new number"), to jump back to it, after swapping (current number) to its (correct location in array)
@ - R5 => to store (memory address) of the (first element in the array) (to mark the start of the array) (always constant)
@ - R8 => register that stores the (memory address) of the (number we're currently looking at)


insertion_sort:
	PUSH {R14} @ E: Pushing Register (R14) to save memory address of LR to return to C
	PUSH {R4-R11} @ E: Pushing Registers (R4-R11) onto the Stack to Save its contents when the Assembly Program finishes

	BL SUBROUTINE
	@ CHECKPOINT(P)

	POP {R4-R11} @ E: Popping the Values of Registers to Return the Pre-Assembly Values
	POP {R14} @ E: Popping Register (R14) to Overwrite the (Value of Link Register) with the (Address of the code in C to which to return to) when executing (BX LR) below
	BX LR

SUBROUTINE:
	@ E: R8 => register that stores the (memory address) of the (number we're currently looking at)
	MOV R8, R0 @ Move (memory address of 1st element of array) from R0 into R8
	@ E: R0 => register that stores the (number of swaps performed by our program to sort the array) (counter)
	MOV R0, #0 @ Move (constant 0) into R0

	@ E: R4 => to store (memory address) of (next number to check), to jump back to it, after swapping (current number) to its (correct location in array)
	MOV R4, R8 @ Move (memory address of 1st element of array) from R8 into R4
	@ E: R5 => to store (memory address) of the (first element in the array) (to mark the start of the array) (always constant)
	MOV R5, R4 @ Move (memory address of 1st element of array) from R4 into R5

	@ E: Branch into the 'check' label
	B check

check:
	@ End-Iteration Condition (matches when (element currently looked at = first element in the array))
	@ This check accounts for the edge-case where the correct position of an element turns out to be the (fist position in the array)
  @ So, after (correct positioning of element into the 1st array position), with this check we ensure that we don't check elements outside of array from left side
  @ By (moving R4 onto the next element and assigning it to R8 to begin the new iteration to sort the next unsorted number) and (decrement by 1 the number of elements left to sort - bcs we've just finished sorting one number)
	CMP R5, R8
	ITTT EQ @ (Since we've just correctly positioned one number (in this case at first position of the array), we move on to sorting the next "new number", by doing the following: )
	SUBEQ R1, #1 @ Decrement (by 1) the number of elements left to check
	ADDEQ R4, #4 @ Move to Sorting the Next Element in the Array (by pointing R4 at next word) (by R4 = R4 + 4)
	MOVEQ R8, R4 @ Set the (element currently looked at (R8) = element we're currently sorting (R4))

	@ End-Program Condition (matches when (number of elements left to check = 0))
	CMP R1, #0
	IT EQ
	BXEQ LR @ Branch-back to CHECKPOINT(P) (exit from program as array is fully sorted)

	LDR R2, [R8, #-4] @ Load value of the (left number) of the (two adjacent numbers we're currently comparing) into (R2)
	LDR R3, [R8] @ Load value of the (right number) of the (two adjacent numbers we're currently comparing) into (R3)

	@ Performs (R3 < R2) Check whether there's a Need to Swap the Two Adjacent Numbers Around
	@ If (TRUE) => (right element) is (smaller) than (left element), hence they're unsorted, therefore swapping them around
	@ If (FALSE) => (right element) is (larger or equal) than (left element), hence they're sorted, therefore no need to swap them around
	CMP R3, R2
	BLT swap

	@ This block of code gets runs whenever the following three conditions are ALL met:
  @ - ([R5 != R8] => it's not the edge case where the sorted position of a number turns out to be the 1st position in the array)
  @ - AND ([R1 != 0] => we still have elements left to sort / the unsorted array is not empty)
	@ - AND ([R3 >= R2] => the number currently being checked (R3) is in its correct position within the sorted array because (R3 >= R2) (right number >= left number)
	SUB R1, #1 @ Decrement (by 1) the number of elements left to check
	ADD R4, #4 @ Move to Sorting the "new number" (by pointing R4 at next word) (by R4 = R4 + 4)
	MOV R8, R4 @ Set the (element currently looked at (R8) = element we're currently sorting (R4))

	B check

swap:
	STR R2, [R8] @ Store the value of (R2 = [R8, #-4]) into ([R8]) (hence, swapping around)
	STR R3, [R8, #-4]! @ Store the value of (R3 = [R8]) into ([R8, [#-4]]) (hence, swapping around) (and move R8 address backwards by 1 word to continue swapping the number downwards until finding its correct position within the sorted array)
	ADD R0, #1 @ Increment the (number of swaps performed) to (sort the array)
	B check
