# Anthony Bisgood
# asm3.s
# This file is a collection of functions that use parameters and return values.
# Some functions use recursion while others use for loops.
.globl strlen
strlen:
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller’s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20 	# setup main’s frame pointer

addi $t0, $zero, 0		#t0 = num of bits = 0
COUNT_WORDS_LOOP:
lb $t1, 0($a0)			#t1 = string[i]
beq $t1, $zero, COUNT_WORDS_END	#if string[i] = null end
addi $t0, $t0, 1		#numOfBits++
addi $a0, $a0, 1		#i++
j COUNT_WORDS_LOOP
COUNT_WORDS_END:
add $v0, $zero, $t0		# return t0
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 24 	# restore the caller?s stack pointer
	jr $ra 			# return to caller?s code

.globl gcf
gcf:
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller’s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20 	# setup main’s frame pointer
	
slt $t0, $a0, $a1		#t0 = a < b
beq $t0, $zero, GCF_FIRST_IF	#if a >= b jump
addi $t3, $a0, 0		#t3 = tempA
addi $a0, $a1, 0		#a = b
addi $a1, $t3, 0		#b = tempA
GCF_FIRST_IF:
addi $t1, $zero, 1		# t1 = 1
bne $a1, $t1, GCF_SECOND_IF	# if b != 1 jump
addi $v0, $zero, 1		# return 1
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 24 	# restore the caller?s stack pointer
	jr $ra 			# return to caller?s code
GCF_SECOND_IF:
div $a0, $a1			# lo =(a/b), hi =(a%b)
mfhi $t2			# t2 = hi =(a%b)
bne $t2, $zero, GCF_THIRD_IF	# if t2 !=0 jump
addi $v0, $a1, 0		# return b
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 24 	# restore the caller?s stack pointer
	jr $ra 			# return to caller?s code
GCF_THIRD_IF:
div $a0, $a1			# lo =(a/b), hi =(a%b)
mfhi $t2			# t2 = hi =(a%b)
addi $a0, $a1, 0		# a0 = b
addi $a1, $t2, 0		# a1 = a%b
jal gcf
	lw $ra, 4($sp) # get return address from stack
	lw $fp, 0($sp) # restore the caller?s frame pointer
	addiu $sp, $sp, 24 # restore the caller?s stack pointer
	jr $ra # return to caller?s code


.globl bottles
.data
	bottlesOf: .asciiz " bottles of "
	onTheWallExcelemation: .asciiz " on the wall!\n"
	onTheWall: .asciiz " on the wall, "
	onTheWallPeriod: .asciiz " on the wall.\n"
	takeOneDown: .asciiz "Take one down, pass it around, "
	noMoreBottlesOf: .asciiz "No more bottles of "
.text
bottles:
	addiu $sp, $sp, -24 # allocate stack space -- default of 24 here
	sw $fp, 0($sp) # save caller’s frame pointer
	sw $ra, 4($sp) # save return address
	addiu $fp, $sp, 20 # setup main’s frame pointer
addi $t0, $a0, 0		#t0 = i = count
addi $t2, $zero, 1		#t2 = 1
# Runs through a loop, for (int i=count; i>0; i--) and 
# prints i bottles of param2, doesnt return anything
BottlesLoop:
slt $t1, $zero, $t0		#t1 = i>0
beq $t1,$zero,BOTTLES_END	#if i<=0 Jump
addi	$v0, $zero, 1  		#print(i)
add	$a0, $t0, $zero
syscall
	addi	$v0, $zero,4	#print( bottles of )
	la	$a0, bottlesOf
	syscall
addi	$v0, $zero, 4  		#print(a1 char*thing)
add	$a0, $a1, $zero
syscall
	addi	$v0, $zero,4	#print( on the wall, )
	la	$a0, onTheWall
	syscall
addi	$v0, $zero, 1  		#print(i)
add	$a0, $t0, $zero
syscall
	addi	$v0, $zero,4	#print( bottles of )
	la	$a0, bottlesOf
	syscall
addi	$v0, $zero, 4  		#print(a1 char*thing)
add	$a0, $a1, $zero
syscall
	addi	$v0, $zero,11	#print(!)
	addi	$a0, $zero,0x21
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
sub $t0, $t0, $t2
	addi	$v0, $zero,4	#print(Take on down, pass it around, )
	la	$a0, takeOneDown
	syscall
addi	$v0, $zero, 1  		#print(i)
add	$a0, $t0, $zero
syscall
	addi	$v0, $zero,4	#print( bottles of )
	la	$a0, bottlesOf
	syscall
addi	$v0, $zero, 4  		#print(a1 char*thing)
add	$a0, $a1, $zero
syscall
	addi	$v0, $zero,4	#print( on the wall.\n )
	la	$a0, onTheWallPeriod
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
j BottlesLoop
BOTTLES_END:
	addi	$v0, $zero,4	#print( "No more bottles of ")
	la	$a0, noMoreBottlesOf
	syscall
addi	$v0, $zero, 4  		#print(a1 char*thing)
add	$a0, $a1, $zero
syscall
	addi	$v0, $zero,4	#print( on the wall.\n )
	la	$a0, onTheWallExcelemation
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	lw $ra, 4($sp) # get return address from stack
	lw $fp, 0($sp) # restore the caller?s frame pointer
	addiu $sp, $sp, 24 # restore the caller?s stack pointer
	jr $ra # return to caller?s code
	
# Principle behind longestSorted Method
#def longestSorted(array, len)
#    i = 0
#    max = 0
#    currMax = 1
#    if (len(array) == 1):
#        return 1;
#    while (i < len-1):
#        if (array[i] <= array[i+1]):
#            currMax += 1
#            if (max < currMax):
#                max = currMax
#        else:
#            currMax = 1
#        i+=1
#    return max
.globl longestSorted
longestSorted:
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller’s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20 	# setup main’s frame pointer
addi $t0, $zero, 0		#t0 = max = 0
addi $t1, $zero, 0		#t1 = i = 0
addi $t2, $zero, 1		#t2 = currMax = 1
sub $t3, $a1, $t2		#t3 = len(array)-1
addi $t4, $a0, 0		#t4 = &a0
beq $a1, $t2, arrayLenOne 	#if len == 1 return 1
longestSortedLoop:
slt $t5, $t1, $t3		#t5 = i < len-1
beq $t5, $zero,longestSortedEnd #while (i<(len-1))

lw $t6, 0($t4)			#t6 = array[i]
addi $t4, $t4, 4		#increments &Array by 4
lw $t7, 0($t4)			#t7 = array[i+1]

slt $t8, $t7, $t6		#t8 = array[i] > array[i+1]
bne $t8, $zero,longestSortedElse#if array[i] > array[i+1] Jump
addi $t2, $t2, 1		#currMax += 1
slt $t9, $t0, $t2		#t9 = Max < currMax
beq $t9, $zero, goNext		#if max >= currMax Jump
addi $t0, $t2, 0		#Max = currMax
j goNext
longestSortedElse:
addi $t2, $zero, 1		#currMax = 1
goNext:
addi $t1, $t1, 1		#i++
j longestSortedLoop

arrayLenOne:
	addi $v0, $t2, 0	#return 1
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 24 	# restore the caller?s stack pointer
	jr $ra 			# return to caller?s code

longestSortedEnd:
	addi $v0, $t0, 0	#reutrn max
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 24 	# restore the caller?s stack pointer
	jr $ra 			# return to caller?s code

#Rotates all values in an array over by 1 and call another function
#returns the sum of the function calls
.globl rotate
rotate:
	addiu $sp, $sp, -44 	# allocate stack space -- new of 44 here
	sw $fp, 0($sp) 		# save caller’s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 40 	# setup main’s frame pointer
	
lw $t2, 0($fp)			#t2 = f
lw $t1, -4($fp)			#t1 = e
lw $t0, -8($fp)			#t0 = d
addi $t3, $zero, 0		#t3 = retval = 0
addi $t4, $zero, 0		# t4 = i = 0
sw $ra, 36($sp)
rotateLoop:
slt $t5, $t4, $a0		#i < count
beq $t5, $zero, rotateEnd	#if i >= count, jump

#stores all values
sw $a0, 8($sp)			#store counter
sw $a1, 12($sp)			#store a
sw $a2, 16($sp)			#store b
sw $a3, 20($sp)			#store c
sw $t0, 24($sp)			#store d
sw $t1, 28($sp)			#store e	
sw $t2, 32($sp)			#store f
sw $t3, 36($sp)			#store retVal
sw $t4, 40($sp)			#store i

#function call
add $a0,$a1, $zero		#a0 = a
add $a1,$a2, $zero		#a1 = b
add $a2,$a3, $zero		#a2 = c
add $a3, $t0, $zero		#a4 = d
sw   $t1, -8($sp)		#-8(sp) = e
sw   $t2, -4($sp)		#-8(sp) = f
jal util

#loads all values
lw $a0, 8($sp)			#load counter
lw $a1, 12($sp)			#load a
lw $a2, 16($sp)			#lead b
lw $a3, 20($sp)			#load c
lw $t0, 24($sp)			#load d
lw $t1, 28($sp)			#load e
lw $t2, 32($sp)			#load f
lw $t3, 36($sp)			#load retVal
lw $t4, 40($sp)			#load i

add $t3, $t3, $v0		#retval += util(a,b,c,d,e,f)

#rotates all values by 1
addi $t6, $a1, 0		#t6 = tmpA
addi $a1, $a2, 0		#a = b
addi $a2, $a3, 0		#b = c
addi $a3, $t0, 0		#c = d
addi $t0, $t1, 0		#d = e
addi $t1, $t2, 0		#e = f
addi $t2, $t6, 0		#f = tempA

addi $t4, $t4, 1		#i++
j rotateLoop
rotateEnd:
	addi $v0, $t3, 0 
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 44 	# restore the caller?s stack pointer
	jr $ra 			# return to caller?s code
