#Anthony Bisgood
#This program creates a turtle object with a name and coordinate on 
# a plane with an odometer and x and y values
.data 
	Turtle: .asciiz "Turtle "
	pos:  	.asciiz "  pos "
	dir: 	.asciiz "  dir "
	North:  .asciiz "North"
	South:  .asciiz "South"
	East:   .asciiz "East"
	West:   .asciiz "West"
	odo: 	.asciiz "  odometer "

.text
# void turtle init(Turtle *obj, char *name)
# initialize turtle with x,y,dir,odom = 0 and name = name
.globl turtle_init
turtle_init:
	#standard prologue
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller�s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20 	# setup main�s frame pointer
	
	#a0 is the pointer to the front of the array
	#a1 is the name of the turtle
	sb $zero, 0($a0)	# turtle[0] = 0 = x
	sb $zero, 1($a0)	# turtle[1] = 0 = y
	sb $zero, 2($a0)	# turtle[2] = 0 = dir
	#3($a0) = pad
	sw $a1, 4($a0)		# turtle[3] = name
	sw $zero, 8($a0)	# turtle[4] = 0 = odom
	
	#standard epilouge
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller?s frame pointer
	addiu $sp, $sp, 24 	# restore the caller?s stack pointer
	jr $ra 			# return to caller's code
	
#void turtle debug(Turtle *obj)
.globl turtle_debug
turtle_debug:
	#standard prologue
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller�s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20 	# setup main�s frame pointer
	
	lw $t0, 4($a0)		# t0 = name
	lb $t1, 0($a0) 		# t1 = x
	lb $t2, 1($a0) 		# t2 = y
	lb $t3, 2($a0)		# t3 = dir
	lw $t4, 8($a0)		# t4 = odom
	#print('Turtle "name" \n') 
	addi $v0, $zero, 4	# print("Turtle")
	la $a0, Turtle
	syscall
	addi $v0, $zero, 11	# print('"')
	addi $a0, $zero, 34
	syscall
	addi $v0, $zero, 4	# print(name)
	add $a0, $t0, $zero
	syscall
	addi $v0, $zero, 11	# print('"')
	addi $a0, $zero, 34
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	#print("  pos x,y \n")
	addi $v0, $zero, 4	# print("  pos")
	la $a0, pos
	syscall
	addi $v0, $zero, 1	# print(x)
	add $a0, $t1, $zero
	syscall
	addi $v0, $zero, 11	# print(",")
	addi $a0, $zero, ','
	syscall
	addi $v0, $zero, 1	# print(y)
	add $a0, $t2, $zero
	syscall
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	# print("  dir Direction \n")
	addi $v0, $zero, 4	# print("  dir ")
	la $a0, dir
	syscall
	# logic for printing directions
	# if dir == t0, goto
	addi $t0, $zero, 0	# t0 = 0
	beq $t3, $t0, printNorth
	addi $t0, $t0, 1	# t0 += 1
	beq $t3, $t0, printEast 
	addi $t0, $t0, 1	# t0 += 1
	beq $t3, $t0, printSouth
	addi $t0, $t0, 1	# t0 += 1
	beq $t3, $t0, printWest
	printNorth:
	addi $v0, $zero, 4	# print("North")
	la $a0, North
	syscall
	j printOdometer
	printSouth:
	addi $v0, $zero, 4	# print("South")
	la $a0, South
	syscall
	j printOdometer
	printEast:
	addi $v0, $zero, 4	# print("East")
	la $a0, East
	syscall
	j printOdometer
	printWest:
	addi $v0, $zero, 4	# print("West")
	la $a0, West
	syscall
	j printOdometer
	# print("  odometer x[3]\n")
	printOdometer:
	# print("\n")
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	addi $v0, $zero, 4	# print("  odometer ")
	la $a0, odo
	syscall
	addi $v0, $zero, 1	# print(x[3])
	add $a0, $t4, $zero
	syscall
	# print("\n")
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	# print("\n")
	addi	$v0, $zero,11	#print(\n)
	addi	$a0, $zero,0xa
	syscall
	
	#standard epilouge
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller's frame pointer
	addiu $sp, $sp, 24 	# restore the caller's stack pointer
	jr $ra 			# return to caller's code

#void turtle turnLeft(Turtle *obj)
.globl turtle_turnLeft
turtle_turnLeft:
	#standard prologue
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller�s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20 	# setup main�s frame pointer
	
	lb $t0, 2($a0)		# t0 = dir
	beq $t0, $zero,leftZero # if dir == 0, jump
	addi $t0, $t0, -1	# dir -= 1
	sb $t0, 2($a0)		
	j leftEnd
	leftZero:
	addi $t1, $zero, 3	# t1 = 3
	sb $t1, 2($a0)		# dir = 3
	leftEnd:
	
	#standard epilouge
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller's frame pointer
	addiu $sp, $sp, 24 	# restore the caller's stack pointer
	jr $ra 	
	
#void turtle turnRight(Turtle*obj)
.globl turtle_turnRight
turtle_turnRight:
	#standard prologue
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller�s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20 	# setup main�s frame pointer
	
	lb $t0, 2($a0)		# t0 = dir
	addi $t1, $zero, 3	# t1 = 3
	beq $t0,$t1, rightThree # if dir == 3, jump
	addi $t0, $t0, 1	# dir += 1
	sb $t0, 2($a0)		
	j rightEnd
	rightThree:
	sb $zero, 2($a0)	# dir = 0
	rightEnd:
	
	#standard epilouge
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller's frame pointer
	addiu $sp, $sp, 24 	# restore the caller's stack pointer
	jr $ra


#def turtle_move(turtle, dist):
#  x = turtle[1]
#   y = turtle[2]
#   dir = turtle[3]
#   odom = turtle[5]
#   if dir == 1 or dir == 3:
#       if dir == 1:
#            x += dist
#       else:
#           x -= dist 
#       if x > 10:
#           x = 10
#       else:
#           x = -10 
#   else:
#       if dir == 0:
#            x += dist
#       else:
#           x -= dist 
#       if y > 10:
#           y = 10
#       else:
#           y = -10 
#    dist = abs(dist)
#   odom += dist
.globl turtle_move
turtle_move:
	#standard prologue
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller�s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20 	# setup main�s frame 
	
	lb $t0, 0($a0) 		# t0 = x
	lb $t1, 1($a0) 		# t1 = y
	lb $t2, 2($a0)		# t2 = dir
	lw $t3, 8($a0)		# t3 = odom
	addi $t4, $zero, 1	# t4 = 1
	addi $t6, $zero, 10	# t6 = 10
	beq $t2, $t4, moveX	# if dir == 1, jump
	addi $t4, $zero, 3	# t4 = 3
	beq $t2, $t4, moveX 	# if dir == 3, jump
	j moveY
moveX:
	addi $t4, $zero, 1	# t4 = 1
	beq $t2, $t4, addX	# if dir == east, x += dist
	sub $t0, $t0, $a1	# x -= dist
	j moveXNext
addX:
	add $t0, $t0, $a1	#x += dist
moveXNext:
	slti $t4, $t0, -10	# t4 = x < -10 == 1
	slt $t5, $t6, $t0	# t5 = x > 10 == 1
	bne $t4,$zero,setXToNTen# if x < -10, x = -10
	bne $t5,$zero,setXToTen # if x > 10, x = 10
	j turtle_moveNEXT
	setXToTen:
	addi $t0, $zero, 10	# x = 10
	j turtle_moveNEXT
	setXToNTen:
	addi $t0, $zero, -10	# x = -10
	j turtle_moveNEXT
moveY:
	addi $t4, $zero, 0	# t4 = 0
	beq $t2, $t4, addY	# if dir == North, x += dist
	sub $t1, $t1, $a1	# y -= dist
	j moveYNext
addY:
	add $t1, $t1, $a1	# y += dist
moveYNext:
	slti $t4, $t1, -10	# t4 = y < -10 == 1
	slt $t5, $t6, $t1	# t5 = y > 10 == 1
	bne $t4,$zero,setYToNTen# if y < -10, y = -10
	bne $t5,$zero,setYToTen # if y > 10, y = 10
	j turtle_moveNEXT
	setYToTen:
	addi $t1, $zero, 10	# y = 10
	j turtle_moveNEXT
	setYToNTen:
	addi $t1, $zero, -10	# y = -10
	j turtle_moveNEXT
turtle_moveNEXT:
	sra $t4,$a1,31   	#abs(dist)
	xor $a1,$a1,$t4   
	sub $a1,$a1,$t4
turtleEND:
	add $t3, $t3, $a1	# odom += dist
	# set values back to turtle
	sb $t0, 0($a0) 		# t0 = x
	sb $t1, 1($a0) 		# t1 = y
	sb $t2, 2($a0)		# t2 = dir
	sw $t3, 8($a0)		# t3 = odom
	
	#standard epilouge
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller's frame pointer
	addiu $sp, $sp, 24 	# restore the caller's stack pointer
	jr $ra 			# return to caller's code

#int turtle searchName(Turtle *arr, int arrLen, char *needle)
# for (int i = 0: i < arrLen; i++){
#	if (arr[i][4] == char){
#		return i;}
# }
.globl turtle_searchName
turtle_searchName:
	#standard prologue
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller�s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20	# setup main�s frame 
	
	addiu $sp, $sp, -16	# store i and &arr for funct call
	sw $s0, 0($sp)		# stores any previous s registers
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	addi $s0, $zero, 0	# s0 = i = 0
	add $s1, $zero, $a0	# s1 = temp &arr
	add $s2, $zero, $a1	# s2 = arrLen
	add $s3, $zero, $a2	# s3 = needle
	
	turtle_searchLoop:
	slt $t0, $s0, $s2	# i < arrLen
	beq $t0, $zero, retNeg 	# if i >= arrLen, return -1
	lw $a0, 4($s1)		# a0 = Turtle[4] = name
	add $a1, $zero, $s3	# a1 = needle
	jal strcmp		
	beq $v0, $zero,retIndex # if strcmp == 0, return index
	
	addi $s1, $s1, 12	# next Turtle object
	addi $s0, $s0, 1	# i++
	j turtle_searchLoop
retNeg:
	addi $v0, $zero, -1	# return -1
	j turtleSearchEnd
retIndex:
	add $v0, $zero, $s0	# return i
	j turtleSearchEnd
turtleSearchEnd:
	# restore all s registers and move pointer back
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addiu $sp, $sp, 16	
	
	#standard epilouge
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller's frame pointer
	addiu $sp, $sp, 24 	# restore the caller's stack pointer
	jr $ra 			# return to caller's code

# for i in range(arrLen):
#    for j in range(arrLen):
#        if arr[j] > arr[j+1]:
#            temp = arr[j+1]
#            arr[j] = arr[j+1]
#            arr[j] = temp
#void turtle sortByX indirect(Turtle **arr, int arrLen)
.globl turtle_sortByX_indirect
turtle_sortByX_indirect:
	#standard prologue
	addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 		# save caller�s frame pointer
	sw $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20	# setup main�s frame 
	
	add $t0, $zero, $a0	# t0 = Turtle **arr
	add $t1, $zero, $a1	# t1 = arrLen
	add $t2, $zero, $zero	# t2 = i = 0
outerSortLoop:
	beq $t2, $t1, sortEnd	# if i == arrLen, sorting finished
	add $t3, $zero, $zero	# t3 = j = 0, j must reset to 0 every outer loop
	add $t4, $zero, $a0	# t4 = j pointer for arr
innerSortLoop:
	addi $t5, $a1, -1	# t5 = arrLen - 1
	beq $t3,$t5,incrementI  # if j == arrLen, i += 1 
	lw $t5, 0($t4)		# t5 = arr[j]
	lb $t6, 0($t5)		# t6 = arr[j].x
	lw $t7, 4($t4)		# t7 = arr[j+1]
	lb $t8, 0($t7)		# t9 = arr[j+1].x
	slt $t9, $t6, $t8	
	beq $t9, $zero, doSort	# if arr[j] < arr[j+1], sort
	j incrementJ
doSort:
	sw $t5, 4($t4)		# arr[j+1] = arr[j]
	sw $t7, 0($t4)		# arr[j] = arr[j + 1]
	j incrementJ
incrementJ:
	addi $t4, $t4, 4		# increments to the next turtle obj
	addi $t3, $t3, 1	# j += 1
	j innerSortLoop
incrementI:
	addi $t2, $t2, 1		# i += 1
	j outerSortLoop
	
sortEnd:
	#standard epilouge
	lw $ra, 4($sp) 		# get return address from stack
	lw $fp, 0($sp) 		# restore the caller's frame pointer
	addiu $sp, $sp, 24 	# restore the caller's stack pointer
	jr $ra 	
	
	
