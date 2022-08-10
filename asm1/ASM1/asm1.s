
.globl studentMain

studentMain:
	addiu $sp, $sp, -24 # allocate stack space -- default of 24 here
	sw $fp, 0($sp) 	    # save caller�s frame pointer
	sw $ra, 4($sp) 	    # save return address
	addiu $fp, $sp, 20  # setup main�s frame pointer
	la $s1, one
	lw $s1,0($s1) 		# int s1 = one
	la $s2, two
	lw $s2,0($s2) 		# int s2 = two
	la $s3, three
	lw $s3,0($s3) 		# int s3 = three
	addi $t0, $zero, 1 	# int t0 = 1
	j MEDIAN
	MEDIAN_BACK:
	j ABSVAL
	ABSVAL_BACK:
	j SUM
	SUM_BACK:
	j ROTATE
	ROTATE_BACK:
	j DUMP
	
	
.data
	MEDIAN_STR: .asciiz "median: "
	COMPARISONS_STR: .asciiz "Comparisons: "
	SPACE_STR: .asciiz " "
	ONE_WAS_NEGATIVE: .asciiz "'one' was negative"
	TWO_WAS_NEGATIVE: .asciiz "'two' was negative"
	THREE_WAS_NEGATIVE: .asciiz "'three' was negative"
	SUM_STR: .asciiz "sum: "
	ONE_STR: .asciiz "one: "
	TWO_STR: .asciiz "two: "
	THREE_STR: .asciiz "three: "

.text	

MEDIAN:

	la $s0, median
	lw $s0,0($s0)			# int s0 = median

	bne $s0, $t0, MEDIAN_BACK	# if (median == 1) else end
	bne $s1, $s2, OR_1      	# if (s1 != s2) JUMP_1 else goto next statement
		addi	$v0, $zero, 4
		la	$a0, MEDIAN_STR
		syscall
		
		addi	$v0, $zero, 1
		la	$a0, one
		lw	$a0, 0($a0)
		syscall
		j MEDIAN_END
	OR_1:
	bne $s1, $s2, OR_2 			# if (s1 != s3) JUMP_1 else print
		addi	$v0, $zero, 4
		la	$a0, MEDIAN_STR
		syscall
		# prints one
		addi	$v0, $zero, 1
		la	$a0, one
		lw	$a0, 0($a0)
		syscall
		j MEDIAN_END
	OR_2:
	bne $s2, $s3, JUMP_2 		# else if (two == three)
		addi	$v0, $zero, 1
		la	$a0, two
		lw	$a0, 0($a0)
		syscall
		j MEDIAN_END
	JUMP_2:
	slt $t1,$s1,$s2  	#t1 = s1<s2
	slt $t2,$s1,$s3 	#t2 = s1<s3
	slt $t3,$s2,$s3 	#t3 = s2<s3
	addi	$v0, $zero, 4
	la	$a0, COMPARISONS_STR 
	syscall
	addi	$v0, $zero, 1
	add	$a0, $t1, $zero
	syscall
	addi	$v0, $zero, 4
	la	$a0, SPACE_STR
	syscall
	addi	$v0, $zero, 1
	add	$a0, $t2, $zero
	syscall
	addi	$v0, $zero, 4
	la	$a0, SPACE_STR
	syscall
	addi	$v0, $zero, 1
	add	$a0, $t3, $zero
	syscall
	# prints "\n"
	addi	$v0, $zero,11
	addi	$a0, $zero,0xa
	syscall
	bne $t1,$t3, NEXT_1		# if (t1 = t3)
		addi	$v0, $zero, 4
		la	$a0, MEDIAN_STR
		syscall
		# prints two
		addi	$v0, $zero, 1
		la	$a0, two
		lw	$a0, 0($a0)
		syscall
	NEXT_1:
	beq $t1, $t2, NEXT_2 	# if (t1 != t2)
		addi	$v0, $zero, 4
		la	$a0, MEDIAN_STR
		syscall
		# prints one
		addi	$v0, $zero,1
		la	$a0, one
		lw	$a0, 0($a0)
		syscall
	NEXT_2:
	beq $t2,$t3, MEDIAN_END	# if (t2 != t3)
		addi	$v0, $zero, 4
		la	$a0, MEDIAN_STR
		syscall
		#prints three
		addi	$v0, $zero, 1
		la	$a0, three
		lw	$a0, 0($a0)
		syscall
	MEDIAN_END:
		# prints "\n"
		addi	$v0, $zero,11
		addi	$a0, $zero,0xa
		syscall
		addi	$v0, $zero,11
		addi	$a0, $zero,0xa
		syscall
	j MEDIAN_BACK
	
ABSVAL:
	la $s0, absVal
	lw $s0,0($s0)				# int s0 = absVAL
	bne $s0, $t0, ABSVAL_END		# if absVal == 1
		slt $t1, $zero, $s1		# if zero < s1 t1 = 1
		slt $t2, $zero, $s2
		slt $t3, $zero, $s3
		
		bne $t1, $zero, ABSVAL_NEXT1 	# if t1 != 1 jump
			sub $s1, $zero, $s1  	# s1 = 0 - (-s1)
			la $a1, one		# changes memory
			sw $s1, 0($a1)
			# prints one was neg
			addi	$v0, $zero, 4
			la	$a0, ONE_WAS_NEGATIVE
			syscall	
			# prints newline
			addi	$v0, $zero,11
			addi	$a0, $zero,0xa
			syscall
		ABSVAL_NEXT1:
		bne $t2, $zero, ABSVAL_NEXT2 	#if t2 != 1 jump
			sub $s2, $zero, $s2  	#s2 = 0 - (-s2)
			la $a1, two		#changes memory	
			sw $s2, 0($a1)
			# prints two was neg
			addi	$v0, $zero, 4
			la	$a0, TWO_WAS_NEGATIVE
			syscall
			#prints newline
			addi	$v0, $zero,11
			addi	$a0, $zero,0xa
			syscall
		ABSVAL_NEXT2:
		bne $t3, $zero, ABSVAL_END 	#if t3 != 1 jump
			sub $s3, $zero, $s3 	#s3 = 0 - (-s3)
			la $a1, three		#changes memory
			sw $s3, 0($a1)
			# prints three was neg
			addi	$v0, $zero, 4
			la	$a0, THREE_WAS_NEGATIVE
			syscall
			#prints newline
			addi	$v0, $zero,11
			addi	$a0, $zero,0xa
			syscall
		ABSVAL_END:
		#prints newline
		addi	$v0, $zero,11
		addi	$a0, $zero,0xa
		syscall
	j ABSVAL_BACK

SUM:
	la $s0, sum
	lw $s0,0($s0)			# int s0 = sum
	bne $s0, $t0, SUM_END		#if sum != 1 back
		# prints sum: 
		addi	$v0, $zero, 4
		la	$a0, SUM_STR
		syscall
		add $t4, $s1, $s2 	# t4 = s1 + s2 + s3 + 0
		add $t4, $s3, $zero
		# prints sum
		addi	$v0, $zero, 1
		add	$a0, $t4, $zero
		syscall
		#prints newline
		addi	$v0, $zero,11
		addi	$a0, $zero,0xa
		syscall
		#prints newline
		addi	$v0, $zero,11
		addi	$a0, $zero,0xa
		syscall
	SUM_END:
	j SUM_BACK
	
ROTATE:
	la $s0, rotate
	lw $s0,0($s0)			# int s0 = rotate
	bne $s0, $t0, ROTATE_BACK	# if sum != 1 back
		la $a1, one		# loads addresses
		la $a2, two
		la $a3, three
		sw $s3, 0($a1)		# stores three in one
		sw $s1, 0($a2)		# stores one in 2nd address
		sw $s2, 0($a3)		# stores two in 3rd address
	
	j ROTATE_BACK
	
DUMP:
	la $s0, dump
	lw $s0,0($s0)			# int s0 = rotate
	bne $s0, $t0, END		# if dump != 1 back
		la $s1, one
		lw $s1,0($s1) 		# int s1 = one
		la $s2, two
		lw $s2,0($s2) 		# int s2 = two
		la $s3, three
		lw $s3,0($s3) 		# int s3 = three
		
		# prints one: 
		addi	$v0, $zero, 4
		la	$a0, ONE_STR
		syscall
		# prints one value
		addi	$v0, $zero, 1
		add	$a0, $s1, $zero
		syscall
		#prints newline
		addi	$v0, $zero,11
		addi	$a0, $zero,0xa
		syscall
		
		# prints two: 
		addi	$v0, $zero, 4
		la	$a0, TWO_STR
		syscall
		# prints one value
		addi	$v0, $zero, 1
		add	$a0, $s2, $zero
		syscall
		# prints newline
		addi	$v0, $zero,11
		addi	$a0, $zero,0xa
		syscall
		# prints three: 
		addi	$v0, $zero, 4
		la	$a0, THREE_STR
		syscall
		# prints one value
		addi	$v0, $zero, 1
		add	$a0, $s3, $zero
		syscall
		# prints newline
		addi	$v0, $zero,11
		addi	$a0, $zero,0xa
		syscall
		# prints newline
		addi	$v0, $zero,11
		addi	$a0, $zero,0xa
		syscall
	
END:

lw $ra, 4($sp) # get return address from stack
lw $fp, 0($sp) # restore the caller�s frame pointer
addiu $sp, $sp, 24 # restore the caller�s stack pointer
jr $ra # return to caller�s code
