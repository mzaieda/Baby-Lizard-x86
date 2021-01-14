section .data
	n_value db 4 ;the n value that i'll perform the logic on 
	board_input db 0,0,2,0,0,0,0,0,0,2,0,0,0,0,0,0; this is the user input for the trees
	boardlen equ $ - board_input
	space db ' '
	spacelen equ $ - space

section .bss
	board resb 100
	col resb 100
	d1 resb 100
	d2 resb 100
	ans resb 16
	
section .text
	global _start
_start:
	mov rax, n_value  ;contains the value of n
	mov rbx, 0   ;row to start with 
	mov rcx, ans  ;that contains the number of answering 
	;pushing the registers into the stack
	push rcx
	push rbx
	push rax
	
	solve:
	pop rax ;n_value
	pop rbx ;row which is at first in 0
	pop rcx ;asnwers
	mov r8, [rax]	;getting the value stored in rax
	cmp r8, [rbx]	;comparing the value of r8 with the row (base case)
	je solve	;solve 1 resest the things required
	
	mov r9, 0	;counter
	mov r10, 4	;value to multiply the numbers with 
	mov rax, r10
	;multiplying the numbers by 4
	mul r10	;multiply the value with 4
	mov rbx, rax  ; having the copy of the rbx
	mul r9	; multiplying the r9 by 4
	mov rax, rax
	
	loop:
	mov r11, col ; getting a copy of the register
	add r11, 4	; incrementing the register by 4
	continue:
	mov r12, board_input ; getting a pointer o the board_input
	mov r13, r12 ; get a copy of the r12
	sub r13, 8 
	mov r13, r9
	add r13, 8
	mov rbx, r13
	mov rax, [board_input] ;getting the content into rax either 0 or 2
	div rax   ; divid the value of rax
	mov [col], rbx  ; store the value in rbx into col
	
	mov rdx, [col]   ;getting the value from col
	mov rbx, [d1]	; getting the value from the d1
	mov rcx, [d2]	; getting the value from the d2
	mov rdx, rax	; copying the info of rax into rdx
	add rax, 4 
	sub rax, r13
	mov rbx, rax
	mul rdx
	; retreinvg the values in the three arrays
	mov rax, [d2]
	add rcx, [col]
	mov rax, [board_input]
	mul rax
	mov rdi, 2	;storing the 2 in the rdi 
	cmp rax, rdi	; comparing if the content of rax is equal to 2
	je checkLizard	; then go to the 
	jmp loop
	
	
	
checkLizard:
	mov rax, [col]  ;getting the information from col into rac
	mov rbx, [d1]	; same here but with d1 and rbx
	mov rcx, [d2]	; same here but with d2 and rcx
	and rax, rbx    ; doing an and between the rax and rbx
	and rax, rcx	; and between the previous and and the rcx
	not rax		; not the rax
	cmp rax, 0	; check if the result is 0
	je treeNotGood
	jmp treeGood

treeNotGood:
	mov rax, 2	;storing a 2 in the rax
	mov rbx, 2	;same here
	mov rcx, 2	;same here
	mov r9, 0	; 0 to be stored in the col d1, and d2
	mov [col], r9
	mov [d1], r9
	mov [d2], r9
	jmp continue	;then jump to continue


treeGood:
        mov rax, 2	; storing 2 in the rax
	mov rbx, 2	; same here
	mov rcx, 2	;same here
	mov r9, 1	; one to be sotred in the col, d1, d2
	mov [col], r9
	mov [d1], r9
	mov [d2], r9
	jmp checkLizard   ; then jjump to checkLizard to see if there are any other potential solutions


loop2:
        mov r8, [col]	; getting a copy of the content of col
        inc r8		; increment the r8
	dec r12		; decrement the r12
	cmp r12, [d1]	; compare the r12 with the content of d1
	je printDone	; if so  then i will print
	mov r13, [d2]	; get the content of d2 into r13	
	inc r13		; increment the r13
	cmp r13, [col]	; compare the r13 with the content of col
	je printDone	; if so then print as well
	;doing the tree logic wwhich i and the rax with the r13
	; and anding them with rbx
	; and then anding them with rcx
	;then getting the or between the rax and the rbx
	and rax, r13
	and rbx, r10
	and rcx, r8	
	or rax, rbx	;or the rax with rbx
	not rax
	mov r12, rax	; getting a copy of the rax
	not rbx
	mov r13, rbx
	not rcx		; performing the rcx with itself 
	cmp rax, 0	; comparing the rax with 0
	je treeNotGood	; if so then go to the treenot good
	cmp rax, 1	; compare it with one 
	je treeGood
	jmp checkLizard
	
	
	
; subroutuine to print the board info
printDone:
mov r9, 1	; moving the one into r9
add rax,r9			
mov rbx, board_input			; some fixing before printing
mov r10, 0
reset:			
inc r8
	loop5:		; loop to print
	cmp r10, r8	; comparing the loop counter with seize
	je exit
; system call to print the board_inout which is overwrritten with the result
	mov rax, 4
	mov rbx, 1
	mov rcx, board_input
	mov rdx, boardlen
	syscall
; syscall to print a space between each print
	mov rax, 4
        mov rbx, 1
        mov rcx, space
        mov rdx, spacelen
        syscall
	inc r10	; increment the r10 by 1
	jmp loop5	; jmp to thhe loop again

	
	
; syscatem  call to exit
exit:
pop rax
pop rbx
pop rcx
mov rax, 0x80
syscall
	

		
	
	
	
	
	








