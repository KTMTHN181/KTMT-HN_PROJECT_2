.data
	inputLabel: .asciiz "Oops. We do not have any thing about you. Let's introduction with each other, I'm the one who try to hang you and you is: "
	conditionalLabel: .asciiz "\n\nAh, don't forget the first rule in this game: Your name must containt only: A-Z, a-z, 0-9. Ok, your name is: "
	wrongInputLabel: .asciiz "\nOh no, your name have some characters out of: A-Z, a-z, 0-9. Don't worry, just input again ;)"
	inputOkLabel: .asciiz "Welcome "
	welcomeLabel: .asciiz "The stage is yours now!"
	theWrongIs: .asciiz "\nThis one is wrong: "
	downLine: .asciiz "\n"
	username: .space 50
	test: .asciiz "."
	#$a2 giu bool cua ham CheckName
	#$a3 giu bool cua ham CheckChar

	

.text

	jal _InputName

#Thuat toan: 1. Nhap ten 2.L?p qua tung char. moi char lai truyen vao ham kiem tra, neu dung di tiep(ket thuc ham), neu sai thong bao sai,
# quay lai 1
# 3. Neu dung het thi ket thuc lap, tra ve ra.
	li $v0,10
	syscall
Wrong:
	
#Print wrongInputLabel
	addi $v0, $zero, 4 
	la $a0, wrongInputLabel
	syscall

	#Print theWrongIs
	addi $v0, $zero, 4 
	la $a0, theWrongIs
	syscall

	#print the normal char
	addi $v0, $zero, 11
	#addi $s0,$s0,32
	add $a0, $s0, $zero
	syscall

	#Print downLine
	addi $v0, $zero, 4 
	la $a0, downLine
	syscall

	addi $a3, $zero, 0
	addi $a2, $zero, 0
	
	j _CheckChar.End
	jal _CheckName.End
	#jal InputName1


_InputName:
	
	addi $sp, $sp, -4
	sw $ra, ($sp)

	#Print inputLabel
	addi $v0, $zero, 4 
	la $a0, inputLabel
	syscall

	#Print conditionalLabel
	addi $v0, $zero, 4 
	la $a0, conditionalLabel
	syscall

InputName1:

	#input username
	addi $v0, $zero, 8
	la $a0, username
	la $a1, 50
	#add $t0,$a0, $zero
	syscall

	#sw $a0, username
	la $a0, username

#Lap qua tung char
	jal _CheckName

	bne $a2, $zero, _InputName.End
	jal InputName1
_InputName.End:
	#Print inputOkLabel
	addi $v0, $zero, 4 
	la $a0, inputOkLabel
	syscall

	#Print username
	addi $v0, $zero, 4 
	la $a0, username
	syscall

	#Print welcomeLabel
	addi $v0, $zero, 4 
	la $a0, welcomeLabel
	syscall


	lw $ra, ($sp)
	addi $sp, $sp, 4
	
	jr $ra


_CheckName:


	#48-57: 0->9
	#65->90: A->Z
	#97->122: a->z

#Prepare

	addi $sp, $sp,-16
	sw $ra, ($sp)
	sw $t0, 4($sp) #t0 will be iterator
	sw $s0, 8($sp) #s0 hold the char
	sw $s1, 12($sp) #s1 hold the string

#Body

	li $t0, 0 
	move $s1, $a0



	j _CheckName.Loop

#End

_CheckName.End:

	#addi $a2, $zero, 1

	lw $ra, ($sp)
	lw $t0, 4($sp) #t0 will be iterator
	lw $s0, 8($sp) #t1 hold the char
	lw $s1, 12($sp) #s1 hold the string

	addi $sp, $sp,16

	jr $ra
#

_CheckName.Loop:

#test
	#addi $v0, $zero, 1
	#move $a0, $t0
	#syscall
#end test

   	lb $s0, ($s1) # $s0 hold the char is iteratoring
    	
	move $a1, $s0
	jal _CheckChar

	bne $a3, $zero, _CheckName.Loop.Iterator
	j _CheckName.End

_CheckName.Loop.Iterator:
	addi $t0, $t0, 1    #i++
	addi $s1,$s1,1 # tang dia chi

	#beq $s0, $zero, _CheckName.Right
	bne $s0, $zero, _CheckName.Loop 
	#j _CheckName.End

	_CheckName.Right:
	addi $a2, $zero, 1
	j _CheckName.End
#Check Char

   
_CheckChar:

	#48-57: 0->9
	#65->90: A->Z
	#97->122: a->z

#Prepare

	addi $sp, $sp,-16
	sw $ra, ($sp)
	sw $t0, 4($sp) #t0 use to compare slt
	sw $s0, 8($sp) #s0 hold the char
	sw $s1, 12($sp) #s1 hold ASCII code
#Body 
	
	beq $s0,'\n',_CheckChar.Right
	j ContinueCheckChar
	
ContinueCheckChar:
	beq $s0,'\0',_CheckChar.Right
	j ContinueCheckChar1
ContinueCheckChar1:
#Test
	#print the normal char
#	addi $v0, $zero, 11
	#addi $s0,$s0,32
#	add $a0, $s0, $zero
#	syscall

	#Print test
#	addi $v0, $zero, 4 
#	la $a0, test
#	syscall
#EndTest

	move $s0, $a1
	#If code <= 57
	addi $s1, $zero, 57
	slt $t0, $s1, $s0
	beq $t0, $zero, Number
	
	# else if code> 57 and <=90
	addi $s1, $zero, 90
	slt $t0, $s1, $s0
	beq $t0, $zero, AZ

	addi $s1, $zero, 122
	slt $t0, $s1, $s0
	beq $t0, $zero, az
	j Wrong
Number:

	#If code >= 48
	addi $s1, $zero, 48
	slt $t0, $s0, $s1
	beq $t0, $zero, _CheckChar.Right
	#Else code <48:Wrong
	j Wrong

AZ:
	#If code >= 65
	addi $s1, $zero, 65
	slt $t0, $s0, $s1
	beq $t0, $zero, _CheckChar.Right
	#Else code <65:Wrong
	j Wrong

az:
	#If code >= 97
	addi $s1, $zero, 97
	slt $t0, $s0, $s1
	beq $t0, $zero, _CheckChar.Right
	#Else code <97:Wrong
	j Wrong

	
#End
_CheckChar.Right:
	addi $a3, $zero, 1
	j _CheckChar.End

_CheckChar.End:
	

	lw $ra, ($sp)
	lw $t0, 4($sp) #t0 to compare slt
	lw $s0, 8($sp) #s0 hold the char
	lw $s1, 12($sp) #s1 hold ASCII code

	addi $sp, $sp,16

	jr $ra


	
