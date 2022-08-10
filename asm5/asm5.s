# Anthony Bisgood
# This program asks the user to input an array on integers, does bubble
# sort and prints out the sorted array and the time it took to sort the array
# Also does a final check to see if the array is actually sorted correctly
.data
	array:		.space 400
	InputHowMuch: 	.asciiz "Type how many numbers you would like to sort (max 100).\n"
	InputNumbers: 	.asciiz "Type one number on a line and press enter.\n"
	SortedArray:  	.asciiz "Sorted Array: "
	totalTime: 	.asciiz "Time taken: "
	milliseconds:	.asciiz " milliseconds"
	step:		.asciiz "Sort "
	isIncorrect:	.asciiz "Sort is incorrect"
	isCorrect:	.asciiz "Sort is Correct"
	
.text
.globl main
main:
	li $v0, 4		# print(InputHowMuch)
    	la $a0,InputHowMuch
    	syscall
    	li $v0, 5		# takes input, stores into v0
    	syscall
    	addi $s0, $v0, 0	# s0 = num of inputs
 	li $v0, 4		# print(InputNumbers)
    	la $a0, InputNumbers
    	syscall
    	addi $a0, $s0, 0	# takeInput(int numOfInputs)
    	jal takeInput
    	li $v0, 30		# syscall that takes in the current system time
    	syscall
    	addi $s1, $a0, 0	# s1 = system start time (low order)
    	addi $a0, $s0, 0	# a0 = numOfInputs
    	jal bubbleSort
    	li $v0, 30		# syscall that takes in the end system time
    	syscall
    	addi $s2, $a0, 0	# s2 = system end time (low order)
    	addi $a0, $s0, 0	# numOfInputs
    	jal testIfCorrect	# j testIfCorrect(numOfInputs)
    	beq $v0, $zero, isWrong # if $testIfCorrect == 0, print is Wrong
    	li $v0, 4		# print(InputNumbers)
    	la $a0, isCorrect
    	syscall
    	j printresults
isWrong:
	li $v0, 4		# print(InputNumbers)
    	la $a0, isIncorrect
    	syscall
printresults:
	addi	$v0, $zero,11	# print(\n)
	addi	$a0, $zero,0xa
	syscall
    	li $v0, 4		# print(SortedArray)
    	la $a0, SortedArray
    	syscall
    	addi $a0, $s0, 0	# a0 = numOfInputs
    	jal printSortedArray
	addi	$v0, $zero,11	# print(\n)
	addi	$a0, $zero,0xa
	syscall
    	abs $t0, $s1		# starting time for our sort
    	abs $t1, $s2		# end time for our sort
    	sub $t2, $t0, $t1	# t2 = endTime - startTime
	li $v0, 4		# print(Time taken)
    	la $a0, totalTime
    	syscall
    	addi $v0, $zero, 1	#print(endTime - startTime)
	add $a0, $t2, $zero
	syscall
	li $v0, 4		# print(Time taken)
    	la $a0, milliseconds
    	syscall
	j exit
# takeInput(int numOfInputs)
# runs through a loop taking a number of integers equal to 
# the numOfInputs and adds it the the array
takeInput:
	#standard prologue
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller’s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20 	# setup main’s frame pointer
	addi $t0, $zero, 0	# t0 = 0 = i
	takeInputLoop:
	beq $a0,0,takeInputExit	# if numOfInputs == 0 return
    	li $v0, 5		# takes input
    	syscall
    	sw $v0,array($t0)	# store the read integer into array
    	addi $t0, $t0, 4	# increments i by one space in array
    	subi $a0, $a0, 1	# numOfInputs -= 1
    	j takeInputLoop
    	takeInputExit:
	#standard epilouge
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 24 	# restore the caller?s stack pointer
	jr $ra 			# return to caller's code
# for i in range(arrLen):
#    for j in range(arrLen):
#        if arr[j] > arr[j+1]:
#            temp = arr[j+1]
#            arr[j] = arr[j+1]
#            arr[j] = temp
# Runs through the array and does bubble sort on it
bubbleSort:
	#standard prologue
	addiu $sp, $sp, -32 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller’s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 28 	# setup main’s frame pointer
	la $t0, array		# t0 = &array
	addi $t1, $a0, 0	# t1 = numOfInputs
	addi $t2, $zero, 0	# t2 = 0 = i
	addi $t8, $zero, 0	# t8 = 0 = num of steps
outerSortLoop:
	beq $t2, $t1, sortEnd	# if i == arrLen, sorting finished
	add $t3, $zero, $zero	# t3 = j = 0, j must reset to 0 every outer loop
	addi $t4, $t0, 0	# t4 = j pointer for arr
innerSortLoop:
	addi $t5, $t1, -1	# t5 = arrLen - 1
	beq $t3,$t5,incrementI  # if j == arrLen, i += 1 
	lw $t5, 0($t4)		# t5 = arr[j]
	lw $t7, 4($t4)		# t7 = arr[j+1]
	slt $t9, $t5, $t7	
	beq $t9, $zero, doSort	# if arr[j] < arr[j+1], sort
	j incrementJ
doSort:
	sw $t5, 4($t4)		# arr[j+1] = arr[j]
	sw $t7, 0($t4)		# arr[j] = arr[j+1]
	li $v0, 4		# print(Step )
    	la $a0, step
    	syscall
    	addi $v0, $zero, 1	#prints the number step were on
	add $a0, $t8, $zero
	syscall
	addi	$v0, $zero,11	#print(:)
	addi	$a0, $zero,0x3a
	syscall
	sw $t0, 8($sp)		# stores all our temp values
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	addi $a0, $s0, 0	# a0 = num of nums
	jal printSortedArray
	lw $t0, 8($sp)		# retreives all our temp values
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	lw $t3, 20($sp)
	addi	$v0, $zero,11	# print(\n)
	addi	$a0, $zero,0xa
	syscall
	addi $t8, $t8, 1	#t8 += 1
	j incrementJ
incrementJ:
	addi $t4, $t4, 4	# increments to the next turtle obj
	addi $t3, $t3, 1	# j += 1
	j innerSortLoop
incrementI:
	addi $t2, $t2, 1	# i += 1
	j outerSortLoop
sortEnd:
	#standard epilouge
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 32 	# restore the caller?s stack pointer
	jr $ra 			# return to caller's code
# prints the array in sorted order
# printSortedArray(arrLen)	
printSortedArray:
	#standard prologue
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller’s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20 	# setup main’s frame pointer
	addi $t0, $zero, 0	# t0 = 0 = i
	la $t1, array		# t1 = &array
	addi $t2, $a0, 0	# t2 = len(array)
printLoop:
	beq $t2, 0, printEnd	# if (arrLen == 0) {return}
	lw $t3, 0($t1)		# t3 = arr[i]
	addi $v0, $zero, 1	# print(array[i])
	add $a0, $t3, $zero
	syscall
	li $a0, 32
	li $v0, 11  		# print(" ")
	syscall
	sub $t2, $t2, 1		# arrLen -= arrLen
	addi $t1, $t1, 4	# &array += 4	
	j printLoop
printEnd:
	#standard epilouge
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 24 	# restore the caller?s stack pointer
	jr $ra 			# return to caller's code
	
# Tests if the final sort is correct, if incorrect, will return 0, else 1
testIfCorrect:
	#standard prologue
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller’s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20 	# setup main’s frame pointer
	addi $t0, $zero, 0	# t0 = 0 = i
	la $t1, array		# t1 = &array
	addi $t2, $a0, 0	# t2 = len(array)
	subi $t2, $t2, 1	# t2 -=1
testCorrectLoop:
	beq $t2,0,testCorrectEnd# if (arrLen == 0) {return}
	lw $t3, 0($t1)		# t3 = arr[i]
	lw $t4, 4($t1)		# t4 = arr[i+1}
	slt $t5, $t4, $t3	# t5 = t4 < t3
	bne $t5, $zero, false	# if t4 < t3
	sub $t2, $t2, 1		# arrLen -= arrLen
	addi $t1, $t1, 4	# i += 1
	j testCorrectLoop
false:
	addi $v0, $zero, 0	# return 0
	#standard epilouge
	addi $v0, $zero, 1	# print(array[i])
	add $a0, $t3, $zero
	syscall
	addi $v0, $zero, 1	# print(array[i])
	add $a0, $t4, $zero
	syscall
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 24 	# restore the caller?s stack pointer
	jr $ra 			# return to caller's code
testCorrectEnd:
	addi $v0, $zero, 1	# return 1
	#standard epilouge
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 24 	# restore the caller?s stack pointer
	jr $ra 			# return to caller's code
exit:





