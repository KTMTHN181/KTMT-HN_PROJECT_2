.data 
	u: .asciiz "*" #ki tu quy dinh
	enter: .asciiz "\n" #enter
	strTBturn: .asciiz "\nBan muon: \n1. Doan ki tu \n2. Doan dap an \n -----> Chon:"
	strTBNhap1: .asciiz "Nhap ki tu:"
	strTBNhap2: .asciiz "Nhap dap an:"
	strTBDung: .asciiz "DUNG ROI!!!"
	strTBSai: .asciiz "SAI ROI!!!"
	guessWord: .asciiz "element"# de truyen vao bien nay
	length: .word 7 #do dai de truyen vao bien nay
	
	guessedAnswer: .asciiz""
	guessedString: .asciiz""
.text
###########################################################
##               HAM XU LI 1 TURN GAME                   ##
###########################################################
_reset:#khoi tao game
	j init_GuessString
_mainTurn:# vong lap game
	li $v0, 4
	la $a0, strTBturn
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0
	beq $t0, 1, get_Char 
	beq $t0, 2, get_Answer
	j _mainTurn
print_GuessedString:#print chuoi co dau sao
	li $v0, 4
	la $a0, enter
	syscall
	li $v0, 4
	la $a0, guessedString
	syscall
	j _exitTurn #ket thuc turn game
###########################################################
##          HAM KHOI TAO CHUOI BAT DAU GAME              ##
###########################################################
init_GuessString:
	#gan guessedString = '*'s
	la $t0, guessedString
	li $t1, 0
	lb $t2, u #*
	lw $t3, length
while_GuessString:
	beq $t1, $t3, exit_GuessString	#$t1 dem so lan lap 
	sb $t2, 0($t0)		#luu '*' -> guessedString
	addi $t0, $t0, 1	#
	addi $t1, $t1, 1	#tang dem
	j while_GuessString
	
exit_GuessString:
	j _mainTurn
###########################################################
##             HAM NHAN VA DUYET MOT KI TU               ##
###########################################################
get_Char:
	li $v0, 4
	la $a0, strTBNhap1
	syscall
	
	li $v0, 12
	syscall
	move $t4, $v0
	
set_Char:
	la $t0, guessWord
	la $t1, guessedString
	li $t2, 0
	lw $t3, length	
	lb $t5, u

while_Char:
	
	beq $t2, $t3, exit_Char	#dieu kien ngung lap
	lb $t6, 0($t0)			
	lb $t7, 0($t1)		 
	bne $t7, $t5 dontSet	#khong phai dau * thi k set ki tu
	beq $t6, $t4, set	#giong ki tu goc thi set
	j dontSet
	
	set:#co ki tu thi chay qua ham set, neu khong chay qua ham set -> ki tu do sai
	sb $t4, 0($t1)		#gan ki tu dung vao guessedString

	dontSet:
	addi $t0, $t0, 1	#tang chuoi
	addi $t1, $t1, 1
	addi $t2, $t2, 1	#tang bien dem
	j while_Char		
exit_Char:
	j print_GuessedString
###########################################################
##               HAM NHAN VA DUYET DAP AN                ##
###########################################################
get_Answer:#Nhap chuoi dap an
	li $v0, 4
	la $a0, strTBNhap2
	syscall
	
	li $v0, 8
	la $a0, guessedAnswer
	li $a1 60
	syscall
	la $t3, guessedAnswer
	
set_Answer:#set vong lap
	la $t0, guessWord
	li $t1, 0
	lw $t2, length	
	
while_Answer: 
	lb $t5, 0($t0)			
	lb $t6, 0($t3)
	beq $t6, 10, end_Answer #cuoi dap an duoc nhap (ktra /n)
	bne $t5, $t6, exit_Answer_False	 #ki tu khac nhau
										
	addi $t0, $t0, 1	#tang chuoi
	addi $t3, $t3, 1	
	addi $t1, $t1, 1	#tang bien dem
	
	j while_Answer
end_Answer:
	beq $t1, $t2, exit_Answer_True #chuoi dap an ket thuc ma co do dai chuoi bang nhau thi dung
	j exit_Answer_False
exit_Answer_True:
	li $v0, 4
	la $a0, strTBDung
	syscall
	j _exitTurn
exit_Answer_False:
	li $v0, 4
	la $a0, strTBSai
	syscall
	j _exitTurn
###########################################################
##                        HET TURN                       ##
########################################################### 
_exitTurn:

