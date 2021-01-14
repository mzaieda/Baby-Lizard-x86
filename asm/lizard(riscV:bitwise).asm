.data
	board: .space 100 	#for the result of the board
	col: .space 100		#column bitwise
	d1: .space 100  	#left diagonal bitwise
	d2:.space 100		#right diagonal bitwise
	
	ask: .ascii "Enter the number of n: \0"
	newLine: .ascii "\n\0"
	space: .ascii " \0"
	Firstrow: .ascii "First Row: \0"
	rows: .ascii "Next Row: \0"
.text

	#print the enter the number of n
	li a7, 4
	la a0, ask
	ecall
	
	#read from the user the n
	li a7, 5
	ecall
	
	#preparing before going to the function
	add t1, a0, zero	#n is stored in t1
	add t2, zero, zero   #the number of solutions is stored in t2
	add t0, zero, zero  #the r
	
	
	#storing them in the stack
	li s11, 12
	sub sp, sp, s11
	sw t0, 0(sp)		#store the r value in the stack
	sw t1, 4(sp)		#store the n value in the stack
	sw t2, 8(sp)		#store the ans value in the stack
	
	
	fill:
	#retreiving the values from the stack
	lw s0, 0(sp) #s0 contains the variable indicative (row)
	lw s1, 4(sp) #s1 contains the n 
	lw s2, 8(sp) #s2 the number of solutions
	beq s0, s1, solve1  #first condition which is the base case
	beq s0, zero, firstRow
	j fillNewRows
	cont:
	li t0, 0 #counter for loop2
	li t4, 4 #the variable to multiply with 
	mul t5, s1, t4  	#multiply the s1 with the 4
	mul t6, s0, t4	#same here but with s0

	
	#loop to store in the col, d1, and d2
	loop2:
	li a7, 5	#ecall to read from the user
	ecall
	#storing the user input wheter it is 0 or 2 in t1
	add t1, a0, zero
	#checks if the user input is 2 hence a tree
	checkIfLizard:
	li a1, 2
	beq t1, a1, lizardLogic
	sw t1, col, t0	#if it is not a tree we will store the value in col
	add s8, t6, zero 		#these are copies only
	add s9, t0, zero		#these are copies onl
	sub t6, t6, t0	#subtracting the t6, by t0
	add t5, t6, t5	#adding the t5 by t6 
	sub t5, t5, t4 	#subtracting the t5 by t4
	sw t1, d1, t5		#then store the t1 in the offset of t5 in d1
	add s9, s9, s8 	#doing the same here with s9 with the other copy of t0
	sw t1, d1, s9		#storing the value in the offset of s9
	li s11, 4
	add t0, t0, s11		#incementing the counter by 4 for the loop (disgned this way)
	bne t0, s1, loop2	#jump to the loop again if the t0 and s1 are still equal
	
	li s11, 1
	add s0, s0, s11		#adding to the row 1 for the recursive call
	sw s0, 0(sp) #s0 contains the variable indicative (row)
	sw s1, 4(sp) #s1 contains the n 
	sw s2, 8(sp) #s2 the number of solutions
	j fill			#recursive call
	
	
	
	#this is designed to insert 1 and 2 in the board and solve it in the following logic
	solve:
	#retreiving the values from the stack
	lw s0, 0(sp) #s0 contains the variable indicative
	lw s1, 4(sp) #s1 contains the n 
	lw s2, 8(sp) #s2 the number of solutions
	beq s0, s1, printDone
	li t0, 0	#counter
	li t1, 4	#the value to multiply with just like in fill
	#multiply the s1 and the s0 by 4 just like in the fill subroutine
	mul t5, s1, t1
	mul t6, s0, t1

	
	loop3:
	lw t2, %lo(col)(t0)	#retreiving what is in col
	add s8, t6, zero		#getting copies of t6 and t0 just like fill
	add s9, t0, zero
	#same logic in fill to retrevice the values only
	sub t6, t6, t0
	add t5, t6, t5
	sub t5, t5, t1
	lw t3, %lo(d1)(t5)		#loading the value in d1 in t3
	add s8, s8, s9
	lw t4, %lo(d2)(s8)		#storing the value in the offset of s9
	#this logic is for checking if it can have a one or not
	or s3, t2, zero	#noring the values of s3 with t2
	not s3, zero
	or s4, t3, zero	#same here with s4 and t3
	not s4, zero
	or s5, t4, zero	#same here with s5 and t4
	not s5, zero
	and s6, s3, s4	#then anding them all 
	and s6, s6, s5
	li s11, 4
	add t0, t0, s11
	beqz s6, loop3		#check if the result is zero if so then go to the loop3
	#else
	li s10, 1
	li s7, 0
	sw s10, col, t0	#storing the value in s10 into col of offset of t0
	sw s10, d1, t5 	#storing the value in s10 into d1 of offset of t5	
	sw s10, d2, s8	#storing the value in s10 into d2 of offset of s8
	#getting a pointer to the board
	la a1, board
	sw s10, (a1)	#storing the value of s10 in board as well
	add a1, a1, s11		#increment the pointer by 4 (int)
	j solve2		#then call solve
	#storing the values back in the array
	sw s7, col, t0	
	sw s7, d1, t5
	sw s7, d2, s8
	sw s10, (a1)
	add a1, a1, s11		#increment the pointer by four 
	j loop3			#loop again
	
	
	
printDone:
li s11, 1
add s2, s2, s11			#increment the asnwer number
la t0, board			#pointer to the board
li s9, 0
reset:				#label to reset the line to show case a matrix
add s9, s9, s11
li a7, 4
la a0, newLine
ecall
	#loop to print the stuff in the board
	loop1:
	li s10, 0
	li a7, 1
	add a0, t0, zero
	ecall
	li a7, 4
	la a0, space	#have a space for cosmetics
	ecall
	add s10, s10, s11
	li s11, 4
	add t0, t0, s11
	beq s10, s1, reset	#if the pointer has reached to the end then add a line
	beq s9, s1, exit	#exit when done
	j loop1			#else loop again
	
	
#ecall for exit	
exit:
li a7, 10
ecall

#printing the first row word
firstRow:
li a7, 4
la a0, Firstrow
ecall
j cont

#printing the new rows word
fillNewRows:
li a7, 4
la a0, rows
ecall
j cont



solve1:
li s0, 0	#reset s0 by zero
sw s0, 0(sp) #s0 contains the variable indicative (row)
sw s1, 4(sp) #s1 contains the n 
sw s2, 8(sp) #s2 the number of solutions
j solve




solve2:
li s11, 1
add s0, s0, s11 #increment the s0 hence the r
sw s0, 0(sp) #s0 contains the variable indicative (row)
sw s1, 4(sp) #s1 contains the n 
sw s2, 8(sp) #s2 the number of solutions
j solve




#logic of lizard  in bitwise
lizardLogic:
beqz t1, return 
li s10, 1
add t1, s10, zero
and s10, s10, t1	#bitwise and between the s10 and t1 which is one
and s6, s0, s1	#and again between s0 and s2
and s7, s1, s2	#and between s2 and s1
or s10, s6, s7	#then doing an or between them all
not s10, zero		#getting the not of s10
beqz s10, store_zero	#check if the s10 is equal to zero if so then the first case of it is being a zero
j store_one		#else store a one
#label to continue
cont3:
sw t3, col, s0	#storing the value of t3 in col with the offset of s0
li s11, 4
add t0, t0, s11		#increment the counter
li s11, 1
sub t1, t1, s11		#decrement the t1
j lizardLogic		



#storing a zero in the three arrays with the offset of s0
store_zero:
li a2, 0	
sw a2, col, s0
sw a2, d1, s0
sw a2, d2, s0
j cont3 	#then jump to cont3 again


#storing one in the three arrays with the offset of s0
store_one:
li a2, 1
sw a2, col, s0
sw a2, d1, s0
sw a2, d2, s0
j store_diag	#then continue with store diag



#this fixes things before going on and checking for another solutions
return:
li a1, 2
beq t1, a1, lizardLogic	#checking if t1 is equal to 2 then we will preform the lizard logic again
#this is the loop to retreive the data from the three arrays
#these data will be restored for the next solution
loop4:
lw t1, %lo(col)(t0)	#loading the value in col with offset of t0 in t1
#getting the copies of t6 and t0	
add s8, t6, zero
add s9, t0, zero
#same logic as the fill and solve
sub t6, t6, t0
add t5, t6, t5
sub t5, t5, t4 
#loading the value in t1
lw t4, %lo(d1)(t5)
add s9, s9, s8
#same here
lw s8, %lo(d1)(s9)
li s11, 4
add t0, t0, s11
bne t0, s1, loop4
li s11, 1
add s0, s0, s11
li s10, 0
add a0, t0, zero
ecall
li a7, 4
la a0, space
ecall
li s11, 4
add t0, t0, s11
li s11, 1
add s10, s10, s11
beq s10, s1, reset	#reset call if s10 and s1 are equal
beq s9, s1, exit	#else exit if needed
j lizardLogic




store_diag:
li s11, 26
add t0, t0, s11	#increment the t0 by 26 which was the counter to get the end of the matrix
#the proper logic to implement a tree 
or s3, t2, zero	#noring the s3 with tt2
not s3, zero
or s4, t3, zero	#noring the s4 with t3
not s4, zero
or s5, t4, zero	#noring the s5 with t4
not s5, zero
li s11, 4
srl s5, t4, s11		#perforimg a shift right logical operation to get the further bits in s5
srl s4, t4, s11		#perforimg a shift right logical operation to get the further bits in s4
and s6, s3, s4	#performing an and between the s3 and s4
and s6, s6, s5	#doing another and 
add s1, s6, zero		#moving the value in s1 to be stored in the array
sw a1, col, t0	#storing the element at the end of the matrix
#copies of t4 and t2
add t3, t4, zero		
add t5, t2, zero
#same logic in solve and fill to retrwive the values in d1 and d2 of their appropriate offsets
sub t6, t6, t0
add t5, t6, t5
sub t5, t5, t1
sw t3, d1, t5		#storing the element at the end of the matrix
add s8, s8, s9
sw t4, d2, s8		#storing the element at the end of the matrix
j cont3

