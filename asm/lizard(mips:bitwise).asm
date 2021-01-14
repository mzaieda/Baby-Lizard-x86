.data
	board: .space 100 	#for the result of the board
	col: .space 100		#column bitwise
	d1: .space 100  	#left diagonal bitwise
	d2:.space 100		#right diagonal bitwise
	
	ask: .asciiz "Enter the number of n: "
	newLine: .asciiz "\n"
	space: .asciiz " "
	Firstrow: .asciiz "First Row: "
	rows: .asciiz "Next Row: "
.text

	#print the enter the number of n
	li $v0, 4
	la $a0, ask
	syscall
	
	#read from the user the n
	li $v0, 5
	syscall
	
	#preparing before going to the function
	move $t1, $v0	#n is stored in t1
	move $t2, $zero   #the number of solutions is stored in t2
	move $t0, $zero  #the r
	
	
	#storing them in the stack
	sub $sp, $sp, 12
	sw $t0, 0($sp)		#store the r value in the stack
	sw $t1, 4($sp)		#store the n value in the stack
	sw $t2, 8($sp)		#store the ans value in the stack
	
	
	fill:
	#retreiving the values from the stack
	lw $s0, 0($sp) #s0 contains the variable indicative (row)
	lw $s1, 4($sp) #s1 contains the n 
	lw $s2, 8($sp) #s2 the number of solutions
	beq $s0, $s1, solve1  #first condition which is the base case
	beq $s0, $zero, firstRow
	j fillNewRows
	cont:
	li $t0, 0 #counter for loop2
	li $t4, 4 #the variable to multiply with 
	mult $s1, $t4  	#multiply the s1 with the 4
	mflo $t5	#retreive the value in t5
	mult $s0, $t4	#same here but with s0
	mflo $t6	#retreive the value in the t6
	
	#loop to store in the col, d1, and d2
	loop2:
	li $v0, 5	#syscall to read from the user
	syscall
	#storing the user input wheter it is 0 or 2 in t1
	move $t1, $v0
	#checks if the user input is 2 hence a tree
	checkIfLizard:
	li $a1, 2
	beq $t1, $a1, lizardLogic
	sw $t1, col($t0)	#if it is not a tree we will store the value in col
	move $t7, $t6 		#these are copies only
	move $t8, $t0		#these are copies onl
	sub $t6, $t6, $t0	#subtracting the t6, by t0
	add $t5, $t6, $t5	#adding the t5 by t6 
	sub $t5, $t5, $t4 	#subtracting the t5 by t4
	sw $t1, d1($t5)		#then store the t1 in the offset of t5 in d1
	add $t8, $t8, $t7 	#doing the same here with t8 with the other copy of t0
	sw $t1, d1($t8)		#storing the value in the offset of t8
	add $t0, $t0, 4		#incementing the counter by 4 for the loop (disgned this way)
	bne $t0, $s1, loop2	#jump to the loop again if the t0 and s1 are still equal
	
	add $s0, $s0, 1		#adding to the row 1 for the recursive call
	sw $s0, 0($sp) #s0 contains the variable indicative (row)
	sw $s1, 4($sp) #s1 contains the n 
	sw $s2, 8($sp) #s2 the number of solutions
	j fill			#recursive call
	
	
	
	#this is designed to insert 1 and 2 in the board and solve it in the following logic
	solve:
	#retreiving the values from the stack
	lw $s0, 0($sp) #s0 contains the variable indicative
	lw $s1, 4($sp) #s1 contains the n 
	lw $s2, 8($sp) #s2 the number of solutions
	beq $s0, $s1, printDone
	li $t0, 0	#counter
	li $t1, 4	#the value to multiply with just like in fill
	#multiply the s1 and the s0 by 4 just like in the fill subroutine
	mult $s1, $t1
	mflo $t5
	mult $s0, $t1
	mflo $t6
	
	loop3:
	lw $t2, col($t0)	#retreiving what is in col
	move $t7, $t6		#getting copies of t6 and t0 just like fill
	move $t8, $t0
	#same logic in fill to retrevice the values only
	sub $t6, $t6, $t0
	add $t5, $t6, $t5
	sub $t5, $t5, $t1
	lw $t3, d1($t5)		#loading the value in d1 in t3
	add $t7, $t7, $t8
	lw $t4, d2($t7)		#storing the value in the offset of t8
	#this logic is for checking if it can have a one or not
	nor $s3, $t2, $zero	#noring the values of s3 with t2
	nor $s4, $t3, $zero	#same here with s4 and t3
	nor $s5, $t4, $zero	#same here with s5 and t4
	and $s6, $s3, $s4	#then anding them all 
	and $s6, $s6, $s5
	add $t0, $t0, 4
	beqz $s6, loop3		#check if the result is zero if so then go to the loop3
	#else
	li $t9, 1
	li $s7, 0
	sw $t9, col($t0)	#storing the value in t9 into col of offset of t0
	sw $t9, d1($t5)		#storing the value in t9 into d1 of offset of t5	
	sw $t9, d2($t7)		#storing the value in t9 into d2 of offset of t7
	#getting a pointer to the board
	la $a1, board
	sw $t9, ($a1)		#storing the value of t9 in board as well
	add $a1, $a1, 4		#increment the pointer by 4 (int)
	j solve2		#then call solve
	#storing the values back in the array
	sw $s7, col($t0)	
	sw $s7, d1($t5)
	sw $s7, d2($t7)
	sw $t9, ($a1)
	add $a1, $a1, 4		#increment the pointer by four 
	j loop3			#loop again
	
	
	
printDone:
add $s2, $s2, 1			#increment the asnwer number
la $t0, board			#pointer to the board
li $t8, 0
reset:				#label to reset the line to show case a matrix
add $t8, $t8, 1
li $v0, 4
la $a0, newLine
syscall
	#loop to print the stuff in the board
	loop1:
	li $t9, 0
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, space	#have a space for cosmetics
	syscall
	add $t0, $t0, 4
	add $t9, $t9, 1
	beq $t9, $s1, reset	#if the pointer has reached to the end then add a line
	beq $t8, $s1, exit	#exit when done
	j loop1			#else loop again
	
	
#syscall for exit	
exit:
li $v0, 10
syscall

#printing the first row word
firstRow:
li $v0, 4
la $a0, Firstrow
syscall
j cont

#printing the new rows word
fillNewRows:
li $v0, 4
la $a0, rows
syscall
j cont



solve1:
li $s0, 0	#reset s0 by zero
sw $s0, 0($sp) #s0 contains the variable indicative (row)
sw $s1, 4($sp) #s1 contains the n 
sw $s2, 8($sp) #s2 the number of solutions
j solve




solve2:
add $s0, $s0, 1 #increment the s0 hence the r
sw $s0, 0($sp) #s0 contains the variable indicative (row)
sw $s1, 4($sp) #s1 contains the n 
sw $s2, 8($sp) #s2 the number of solutions
j solve




#logic of lizard  in bitwise
lizardLogic:
beqz $t1, return 
li $t9, 1
move $t1, $t9
and $t9, $t9, $t1	#bitwise and between the t9 and t1 which is one
and $s6, $s0, $s1	#and again between s0 and s2
and $s7, $s1, $s2	#and between s2 and s1
or $t9, $s6, $s7	#then doing an or between them all
not $t9, $zero		#getting the not of t9
beqz $t9, store_zero	#check if the t9 is equal to zero if so then the first case of it is being a zero
j store_one		#else store a one
#label to continue
cont3:
sw $t3, col($s0)	#storing the value of t3 in col with the offset of s0
add $t0, $t0, 4		#increment the counter
sub $t1, $t1, 1		#decrement the t1
j lizardLogic		



#storing a zero in the three arrays with the offset of s0
store_zero:
li $a2, 0	
sw $a2, col($s0)
sw $a2, d1($s0)
sw $a2, d2($s0)
j cont3 	#then jump to cont3 again


#storing one in the three arrays with the offset of s0
store_one:
li $a2, 1
sw $a2, col($s0)
sw $a2, d1($s0)
sw $a2, d2($s0)
j store_diag	#then continue with store diag



#this fixes things before going on and checking for another solutions
return:
li $a1, 2
beq $t1, $a1, lizardLogic	#checking if t1 is equal to 2 then we will preform the lizard logic again
#this is the loop to retreive the data from the three arrays
#these data will be restored for the next solution
loop4:
lw $t1, col($t0)	#loading the value in col with offset of t0 in t1
#getting the copies of t6 and t0	
move $t7, $t6 
move $t8, $t0
#same logic as the fill and solve
sub $t6, $t6, $t0
add $t5, $t6, $t5
sub $t5, $t5, $t4 
#loading the value in t1
lw $t4, d1($t5)
add $t8, $t8, $t7
#same here
lw $t7, d1($t8)
add $t0, $t0, 4
bne $t0, $s1, loop4
add $s0, $s0, 1
li $t9, 0
move $a0, $t0
syscall
li $v0, 4
la $a0, space
syscall
add $t0, $t0, 4
add $t9, $t9, 1
beq $t9, $s1, reset	#reset call if t9 and s1 are equal
beq $t8, $s1, exit	#else exit if needed
j lizardLogic




store_diag:
add $t0, $t0, 26	#increment the t0 by 26 which was the counter to get the end of the matrix
#the proper logic to implement a tree 
nor $s3, $t2, $zero	#noring the s3 with tt2
nor $s4, $t3, $zero	#noring the s4 with t3
nor $s5, $t4, $zero	#noring the s5 with t4
srl $s5, $t4, 4		#perforimg a shift right logical operation to get the further bits in s5
srl $s4, $t4, 4		#perforimg a shift right logical operation to get the further bits in s4
and $s6, $s3, $s4	#performing an and between the s3 and s4
and $s6, $s6, $s5	#doing another and 
move $s1, $s6		#moving the value in s1 to be stored in the array
sw $a1, col($t0)	#storing the element at the end of the matrix
#copies of t4 and t2
move $t3, $t4		
move $t5, $t2
#same logic in solve and fill to retrwive the values in d1 and d2 of their appropriate offsets
sub $t6, $t6, $t0
add $t5, $t6, $t5
sub $t5, $t5, $t1
sw $t3, d1($t5)		#storing the element at the end of the matrix
add $t7, $t7, $t8
sw $t4, d2($t7)		#storing the element at the end of the matrix
j cont3

