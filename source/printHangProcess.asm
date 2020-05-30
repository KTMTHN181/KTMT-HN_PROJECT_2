.data
	fail1: .asciiz "_______\n|/    |\n|\n|\n|\n|\n|\n"
	fail2: .asciiz "_______\n|/    |\n|     O\n|\n|\n|\n|\n"
	fail3: .asciiz "_______\n|/    |\n|     O\n|     |\n|\n|\n|\n"
	fail4: .asciiz "_______\n|/    |\n|     O\n|    /|\n|\n|\n|\n"
	fail5: .asciiz "_______\n|/    |\n|     O\n|    /|\\\n|\n|\n|\n"
	fail6: .asciiz "_______\n|/    |\n|     O\n|    /|\\\n|    /\n|\n|\n"
	fail7: .asciiz "_______\n|/    |\n|     O\n|    /|\\\n|    / \\\n|\n|\n"


.text
	
	#Input how many times user fail

	#inputn
	addi $v0, $zero, 5
	syscall
	
	add $a0, $v0, $zero
	jal _printHangProcess

	

# Thuat toan:
# 1.	Nhap ten
# 2.	Lap qua tung char. moi char lai truyen vao ham kiem tra, neu dung di tiep 
# 	(ket thuc ham), neu sai thong bao sai, quay lai 1
# 3.	Neu dung het thi ket thuc lap, tra ve ra.
	li $v0,10
	syscall

#load so lan doan sai vao $a0
#roi goi _printHangProcess de in ra hinh nhan

_printHangProcess:

	addi $sp, $sp, -4
	sw $ra, ($sp)


	beq $a0, 1, _printHangProcess1
	beq $a0, 2, _printHangProcess2
	beq $a0, 3, _printHangProcess3
	beq $a0, 4, _printHangProcess4
	beq $a0, 5, _printHangProcess5
	beq $a0, 6, _printHangProcess6
	beq $a0, 7, _printHangProcess7	
	j _printHangProcess.End

_printHangProcess1:
	addi $v0, $zero, 4 
	la $a0, fail1
	syscall
	j _printHangProcess.End
_printHangProcess2:
	addi $v0, $zero, 4 
	la $a0, fail2
	syscall
	j _printHangProcess.End
_printHangProcess3:
	addi $v0, $zero, 4 
	la $a0, fail3
	syscall
	j _printHangProcess.End
_printHangProcess4:
	addi $v0, $zero, 4 
	la $a0, fail4
	syscall
	j _printHangProcess.End
_printHangProcess5:
	addi $v0, $zero, 4 
	la $a0, fail5
	syscall
	j _printHangProcess.End
_printHangProcess6:
	addi $v0, $zero, 4 
	la $a0, fail6
	syscall
	j _printHangProcess.End
_printHangProcess7:
	addi $v0, $zero, 4 
	la $a0, fail7
	syscall
	j _printHangProcess.End

_printHangProcess.End:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
