.globl studentMain

studentMain:
	addiu $sp, $sp, -24 # allocate stack space -- default of 24 here
	sw $fp, 0($sp) # save caller’s frame pointer
	sw $ra, 4($sp) # save return address
	addiu $fp, $sp, 20 # setup main’s frame pointer
	
.data 
	FIB_STRING: .asciiz "Fibonacci Numbers:\n"
	ZERO_FIB_STRING: .asciiz "  0: 1\n"
	ONE_FIB_STRING: .asciiz "  1: 1\n"
	ASCENDING: .asciiz "ASCENDING"
	DESCENDING: .asciiz "DESCENDING"
	NEITHER: .asciiz "NEITHER"
	BOTH: .asciiz "BOTH"
	PRINT_RUN_CHECK: .asciiz "Run Check: "
	PRINT_SWAP: .asciiz "String successfully swapped!\n"
	
	
	
.text
#Fibonacci
la $s0, fib			# s0 = &fib
lw $s0, 0($s0)			# s0 = fib
beq $s0, $zero , SQUARE		# if (fib == 0) goto Square

addi	$v0, $zero, 4		#print("Fibonacci Numbers:\n")
la	$a0, FIB_STRING
syscall
addi	$v0, $zero, 4		#print("  0: 1\n")
la	$a0, ZERO_FIB_STRING
syscall		
addi	$v0, $zero, 4		#print("  1: 1\n")
la	$a0, ONE_FIB_STRING
syscall

addi $s1, $zero, 1		#s1 = prev = 1
addi $s2, $zero, 1		#s2 = beforeThat = 1
addi $s3, $zero, 2		#s3 = n = 2

FIB_WHILE_LOOP:

slt $t0, $s0, $s3		#t0 = n > fib
bne $t0, $zero, FIB_END		#if (n <= fib) FIB_END
	add $t1, $zero, $zero	#cur = t1 = 0
	add $t1, $s1, $s2	#cur = prev + beforeThat
	
	addi	$v0, $zero,11   #print(" ")
	addi	$a0, $zero,0x20
	syscall
	addi	$v0, $zero,11   #print(" ")
	addi	$a0, $zero,0x20
	syscall
	addi	$v0, $zero, 1   #print(n)
	add	$a0, $s3, $zero
	syscall
	addi	$v0, $zero,11   #print(":")
	addi	$a0, $zero,0x3a
	syscall
	addi	$v0, $zero,11   #print(" ")
	addi	$a0, $zero,0x20
	syscall
	addi	$v0, $zero, 1   #print(cur)
	add	$a0, $t1, $zero
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall

	addi $s3, $s3, 1	#n = n + 1
	add $s2, $zero, $zero	#beforeThat = 0
	add $s2, $zero, $s1	#beforeThat = prev
	add $s1, $zero, $zero	#prev = 0
	add $s1, $zero, $t1	#prev = cur
	j FIB_WHILE_LOOP
	
FIB_END:
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall

add $s0, $zero, $zero 		#Clear used registers
add $s1, $zero, $zero
add $s2, $zero, $zero
add $s3, $zero, $zero
add $t0, $zero, $zero
add $t1, $zero, $zero

SQUARE:
#SQUARE

la $t0, square			#t0 = square
lw $t0, 0($t0)

beq $t0, $zero, RUN_CHECK	#if(square = 0) goto RUN_CHECK

la $s0, square_fill		#s0 = square_fill
lw $s0, 0($s0)
la $s1, square_size		#s1 = square_size
lw $s1, 0($s1)

addi $s4, $zero, 0		#s4 = row = 0
SQUARE_FOR_LOOP:
slt $t0, $s4, $s1		#t0 = row < square_size
beq $t0, $zero, SQUARE_END	#if (row >= square_size) goto SQUARE_END

bne $s4, $zero, SQUARE_IF	#if row !=0 goto SQUARE_IF
add $t2, $zero, '+'		#t2 = lr = '+'
add $t3, $zero, '-'		#t3 = mid = '-'
j AFTER_ELSE

SQUARE_IF:
subi $t1, $s1, 1		#t1 = squareSize -1

bne $s4, $t1, SQUARE_ELSE	#if squareSize-1 != row goto SQUARE_ELSE
addi $t2, $zero, '+'		#t2 = lr = '+'
addi $t3, $zero, '-'		#t3 = mid = '-'

j AFTER_ELSE

SQUARE_ELSE:			#else t2 = lr = '|'
addi $t2, $zero, '|'		
add $t3, $zero, $s0 		#mid = 0 + squarefill
AFTER_ELSE:
addi	$v0, $zero, 11   	#print(lr)
add	$a0, $t2, $zero
syscall

addi $t4, $zero, 1		#t4 = i = 1
subi $t1, $s1, 1		#t1 = squareSize -1
SQUARE_INSIDE_4_LOOP:
slt $t5, $t4, $t1 		#t5 = i < squareSize - 1
beq $t5, $zero, SQUARE_AFTER_FOR#if i >= squareSize - 1 goto  Square after 4
	addi	$v0, $zero, 11  #print(mid)
	add	$a0, $t3, $zero
	syscall
	addi $t4, $t4, 1	#i++
j SQUARE_INSIDE_4_LOOP

SQUARE_AFTER_FOR:
addi	$v0, $zero, 11   	#print(lr)
add	$a0, $t2, $zero
syscall
addi	$v0, $zero,11		#print(\n)
addi	$a0, $zero,0xa
syscall
addi $s4, $s4, 1		#row ++
j SQUARE_FOR_LOOP		
SQUARE_END:
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall

RUN_CHECK:
add $s0, $zero, $zero 		#Clear used registers
add $s1, $zero, $zero
add $s2, $zero, $zero
add $s3, $zero, $zero
add $s4, $zero, $zero
add $t0, $zero, $zero
add $t1, $zero, $zero
add $t2, $zero, $zero
add $t3, $zero, $zero
add $t4, $zero, $zero

la $t0, runCheck		#t0 = &runCheck
lw $t0, 0($t0)			#t0 = runCheck
addi $t1, $zero, 1		#t1 = 1
bne $t0, $t1, COUNT_WORDS 	#if runcheck != 1 goto COUNTWORDS
la $s1, intArray_len		#s1 = &intArray_len
lw $s1, 0($s1)				#s1 = intArray_len
la $s0, intArray			#s0 = &intArray

#make sure array length is > han 1
slt $t0, $t1, $s1		#if 1 < len; t0 = 1
bne $t0, $zero, TO_RUNCHECK_FOR_LOOP	#if (1 < len) goto RUN_CHECK_END
	addi	$v0, $zero, 4	#print("BOTH")
	la	$a0, BOTH
	syscall
	j RUN_CHECK_END
	

TO_RUNCHECK_FOR_LOOP:
subi $t6 , $s1, 1	#t6 = len - 1
addi $t1, $zero, 0	#t1 = i = 0

addi $s2, $zero, -1	#s2 = signal = - 1
addi $t7, $zero, -1	#t7 = -1

RUNCHECK_FOR_LOOP:
slt $t0, $t1, $t6		#t0 = i < (len-1) = 1
#if (i >= len) goto RUNCHECK_PRINTER
beq $t0, $zero, RUNCHECK_PRINTER

lw $t4, 0($s0) 			#t4 = array[i]
addi $s0, $s0, 4		#incraments the address
lw $t5, 0($s0) 			#t5 = array[i+1]

bne $t4,$t5, NOT_EQUALS 	#if equal move to next dont check
addi $t1, $t1, 1		#i++

j RUNCHECK_FOR_LOOP
NOT_EQUALS:

slt $t0, $t4, $t5		#array[i+1] < array[i] = 1
bne $t0, $zero, ascending	#if (array[i+1] >= array[i]) Branch

beq $s2, $t7, set_des_first 	#if not equal to eachother we compare
addi $s3, $zero, 1		#set temp val to 1(descending
j RUNCHECK_NEXT
set_des_first:
addi $s2, $zero, 1		#signal =+1
add $s3, $zero, $s2		#sig2 = signal
j RUNCHECK_NEXT

ascending:
beq $s2, $t7, set_asc_first 	#if not equal to eachother we compare
addi $s3, $zero, 0		#set temp val to 0(ascending
j RUNCHECK_NEXT
set_asc_first:
addi $s2, $zero, 0
add $s3, $zero, $s2

RUNCHECK_NEXT:
bne $s3, $s2, PRINT_NEITHER	#if signal != sig2 then neither
addi $t1, $t1, 1		#i++
j RUNCHECK_FOR_LOOP

RUNCHECK_PRINTER:
addi $t0, $zero, 0
addi $t1, $zero, 1
addi	$v0, $zero,4
la	$a0, PRINT_RUN_CHECK
syscall
beq $s2, $t7,PRINT_ASCENDING_DESCENDING #if s2 = -1 (doesnt change) print 
beq $s2, $t0, PRINT_ASCENDING		#if s2 = 0 (ascending)
beq $s2, $t1, PRINT_DESCENDING	#if s2 = 1 (descending)
PRINT_ASCENDING:
	addi	$v0, $zero,4
	la	$a0, ASCENDING
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	j RUN_CHECK_END
PRINT_ASCENDING_DESCENDING:
	addi	$v0, $zero,4
	la	$a0, ASCENDING
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	addi	$v0, $zero,4
	la	$a0, PRINT_RUN_CHECK
	syscall
	addi	$v0, $zero,4
	la	$a0, DESCENDING
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	j RUN_CHECK_END	
PRINT_DESCENDING:
 	addi	$v0, $zero,4
	la	$a0, DESCENDING
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	j RUN_CHECK_END
PRINT_NEITHER:
	addi	$v0, $zero,4
	la	$a0, PRINT_RUN_CHECK
	syscall
	addi	$v0, $zero,4
	la	$a0, NEITHER
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	j RUN_CHECK_END
RUN_CHECK_END:
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	

#COUNT_WORDS
COUNT_WORDS:
la $s0, countWords		#S0 = countWords
lw $s0, 0($s0)
addi $t0, $zero, 1
bne $s0, $t0, REV_STRING 	#if countWords != 1 goto REV_STRING

la $s0, str			#s0 = str
addi $t3, $zero, ' '		#t3 = space
addi $t4, $zero, 0		#num of words

#if 1st char is a letter add one
lb $t0, 0($s0)			#t0 = string[i]
bne $t0, $t3, ADD1
COUNT_WORDS_LOOP:
lb $t0, 0($s0)			#t0 = string[i]
addi $s0,$s0,1			#i++
lb $t1, 0($s0)			#t1 =  string[i+1]
beq $t1, 0, COUNT_WORDS_END	#if string[i+1] = null end
beq $t1, $t3, COUNT_WORDS_LOOP	#if string[i+1] = space loop
bne $t0, $t3, COUNT_WORDS_LOOP	#if string[i] != space loop
ADD1:
addi $t4, $t4, 1		#nums ++
j COUNT_WORDS_LOOP

COUNT_WORDS_END:
	addi	$v0, $zero, 1   #print(num of words)
	add	$a0, $t4, $zero
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall


REV_STRING:
addi $t0, $zero, 1		#t0 = 1
la $t1, revString		#t1 = revString
lw $t1, 0($t1)
bne $t0, $t1, END		#if revString = 1
addi $s0, $zero, 0			#s0 = head = 0
addi $s1, $zero, 0			#s1 = tail = 0
la $s2, str				#s2 =&str

add $t1, $s2, $zero		#t1 = temp = &str
addi $t0, $zero, '\0'		#t0 = ’\0’
FIRST_REV_WHILE:
lb $t2, 0($t1)			#t2 = string[i]
beq $t2, $t0, AFTER_FIRST_REV_WHILE #if string[tail] == '\0' goto
addi $t1,$t1,1			#i++
addi $s1,$s1,1			#tail++
j FIRST_REV_WHILE
AFTER_FIRST_REV_WHILE:
subi $s1, $s1, 1		#tail--

SECOND_REV_WHILE:
slt $t0, $s0, $s1		#head < tail
beq $t0, $zero, REV_END		#head >= tail REV_END
#load addresses of str[head] ann str[tail]
#swap the addresses
add $t1, $s2, $s0		#t1 = &s1 + head
add $t2, $s2, $s1		#t2 = &s1 + tail

lb $t3, 0($t1)			#t3 = char at t1
lb $t4, 0($t2)			#t4 = char at t2

sb $t3, 0($t2)			#&t2 = t3
sb $t4, 0($t1)			#&t1 = t4

addi $s0, $s0, 1		#head++
subi $s1, $s1, 1		#tail--
j SECOND_REV_WHILE

REV_END:
addi	$v0, $zero, 4		#print("String successfully swapped!\n")
la	$a0, PRINT_SWAP
syscall	
addi	$v0, $zero,11	#print(\n)
addi	$a0, $zero,0xa
syscall
END:


lw $ra, 4($sp) # get return address from stack
lw $fp, 0($sp) # restore the caller?s frame pointer
addiu $sp, $sp, 24 # restore the caller?s stack pointer
jr $ra # return to caller?s code
