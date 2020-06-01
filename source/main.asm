###################MACRO(NHO CHEP PHAN NAY)###############
.macro 	strlen (%str)  #puts length of string in $t3
	.text
la $t0 %str
loop_strlen:
	lb   $t1 0($t0)
	beq  $t1 $zero end

	addi $t0 $t0 1
	j loop_strlen
end:

la $t1 %str
sub $t3 $t0 $t1
.end_macro
##########################################################
	.data

### data game
	soLanDoanSai: .space 4
	soKiTuDaDoan: .space 4
### data file
	file_debai:	.asciiz "data\\dethi.txt"
	.align 1
	count_debai_old: .space 4
	list_debai:	.space 1024
	debai:		.space 400
	debai_old:	.space 400
	count_debai:	.space 4
	length: .space 4 #do dai de truyen vao bien nay
#### data top 10
	.align 1
	list_pointer_ngchoi:	.space 1024
	list_diemso_ngchoi:	.space 1024
	list_ngchoi:		.space 1024
#### data graph
	fail1: .asciiz "_______\n|/    |\n|\n|\n|\n|\n|\n"
	fail2: .asciiz "_______\n|/    |\n|     O\n|\n|\n|\n|\n"
	fail3: .asciiz "_______\n|/    |\n|     O\n|     |\n|\n|\n|\n"
	fail4: .asciiz "_______\n|/    |\n|     O\n|    /|\n|\n|\n|\n"
	fail5: .asciiz "_______\n|/    |\n|     O\n|    /|\\\n|\n|\n|\n"
	fail6: .asciiz "_______\n|/    |\n|     O\n|    /|\\\n|    /\n|\n|\n"
	fail7: .asciiz "_______\n|/    |\n|     O\n|    /|\\\n|    / \\\n|\n|\n"
### data name
	inputLabel: .asciiz "Oops. We do not have any thing about you. Let's introduction with each other, I'm the one who try to hang you and you is: "
	conditionalLabel: .asciiz "\n\nAh, don't forget the first rule in this game: Your name must containt only: A-Z, a-z, 0-9. Ok, your name is: "
	wrongInputLabel: .asciiz "\nOh no, your name have some characters out of: A-Z, a-z, 0-9. Don't worry, just input again ;)"
	inputOkLabel: .asciiz "Welcome "
	welcomeLabel: .asciiz "The stage is yours now!\n"
	theWrongIs: .asciiz "\nThis one is wrong: "
	downLine: .asciiz "\n"
	username: .space 50
	test: .asciiz "."
### data win-lose
	###############STATIC VARIABLES/STRINGS###################
	file_nguoichoi:	.asciiz "data\\nguoichoi.txt"
	strCorrect: .asciiz "Ban da doan dung tu!\n"
	strIncorrect: .asciiz "Ban da doan sai! \n-----NUOC MAT ANH ROI-----\n----CUOC CHOI KET THUC----\n"
	strIncorrect2: .asciiz "Tu ma ban da doan sai la: "
	strScore: .asciiz "So diem hien tai cua ban la: "
	strLose: .asciiz "So diem cuoi cung cua ban la: "
	strHighScore: .asciiz "Chuc mung! Ban vua xac lap ki luc diem cao moi nhat!\n"	
	strContinue: .asciiz "Ban co muon choi tiep luot moi khong? (Y/N) \n(Bat ki gia tri nao khac Y/y se ket thuc tro choi)"
	strGoodbye: .asciiz "\nGoodnight."
	star: .asciiz "*"
	dash: .asciiz "-"
	uppercaseAffirm: .asciiz "Y"
	lowercaseAffirm: .asciiz "y"
	strTop: .asciiz "\n==================== TOP 10 ====================\n"
	strLine: .asciiz "\n------------------------------------------------------------------------------------------\n"
	###########UNIQUE VARIABLES (trong main chua co)############
	currentScore: .word 0		#moi lan thang + diem = do dai cua tu
	correctGuesses: .word 0
	buffer: .space 128
### data turn
	u: .asciiz "*" #ki tu quy dinh
	enter: .asciiz "\n" #enter
	strTBturn: .asciiz "\nBan muon: \n1. Doan ki tu \n2. Doan dap an \n -----> Chon: "
	strTBNhap1: .asciiz "Nhap ki tu: "
	strTBNhap2: .asciiz "Nhap dap an: "
	strTBDung: .asciiz "DUNG ROI!!!"
	strTBSai: .asciiz "SAI ROI!!!"
	chuoiDoanDapAn: .asciiz""
	chuoiKiTu: .asciiz""	
	.text
	.globl main
main:

_game.Login:
	jal _InputName
_game.Restart:
	# Khoi tao trang thai game
	sw $0, currentScore
	sw $0, correctGuesses
		
	# Khoi tao count_debai_old = 0
	sw $0, count_debai_old
	
	# Doc va count so de thi
	la $a0, list_debai
	jal _ReadDeThi
	sw $v0, count_debai
	
	# Test lay random de thi
	la $a0, list_debai
	la $a1, count_debai_old
	la $a2, debai_old
	lw $a3, count_debai
	jal _GetDeThi
	
	
	la $a0, debai
	jal _GetLength
	sw $v0, length #luu length
########################### TEST - DEBAI ############################	
	###in length
	#li $v0, 1
	#lw $a0, length
	#syscall
	
	#li $v0, 4
	#la $a0, debai
	#syscall
########################### TEST - DEBAI ############################	
	#khoi tao bien dem so lan sai
	sw $0, soLanDoanSai
	sw $0, soKiTuDaDoan
	j _reset
####### Ham main cua game	  	
_game.Main:
	lw $t0, length
	lw $t1, soKiTuDaDoan
	beq $t0, $t1, _game.EndWin
	#####test so lan doan####
	#li $v0, 1
	#lw $a0, soLanDoanSai
	#syscall
	#########################
	
	lw $t1, soLanDoanSai
	slti $t0, $t1, 7
	beq $t0, 1, _inputHangProcess
	j _game.EndLose
####### Vong lap game	  
_game.Loop:
	li $v0, 4
	la $a0, strLine
	syscall
	j _mainTurn
	
####### Xu li thang	  
_game.EndWin:
	j _game.correctGuess	
####### Xu li thua	  	
_game.EndLose:
	j _game.incorrectGuess
###################################################### HANGMAN - DEBAI ####################################################			
# -------------------------------- Get Length --------------------------------
# Truyen vao tham so a0 = Dia chi debai
# Ket qua tra ve la length/so ki tu
_GetLength:
# Dau thu tuc
	addi $sp, $sp, -12
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	
# Than thu tuc
	# Truyen tham so
	move $s0, $a0 # Dia chi debai
	
	# Tien hanh dem so ki tu
	li $t0, 0 # Khoi tao count = 0
_GetLength_Loop0:
	lb $t1, ($s0)
	beqz $t1, _GetLength_Exit # Kiem tra t1 == '\0' thi exit
	# Khong thi tang dem va tiep tuc loop
	addi $t0, $t0, 1
	addi $s0, $s0, 1
	j _GetLength_Loop0
_GetLength_Exit:

	# Tra ket qua la length/so ki tu
	move $v0, $t0
	
# Cuoi thu tuc
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	addi $sp, $sp, 12
	jr $ra

# ---------------- Read De Thi ----------------
# Truyen vao tham so a0 = Dia chi list_debai
# Ket qua tra ve so luong de bai
_ReadDeThi:
# Dau thu tuc
	addi $sp, $sp, -32
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $t0, 8($sp)
	sw $s3, 12($sp)
	
# Than thu tuc
	# Truyen tham so
	move $s0, $a0 # Dia chi list_debai

	# Thao tac xu li file	
	# Mo file
	li $v0, 13
	la $a0, file_debai
	li $a1, 0
	li $a2, 0
	syscall # File descriptor dc luu vao $v0
	move $s3, $v0
	
	# Doc file
	li $v0, 14
	move $a0, $s3
	move $a1, $s0
	li $a2, 1024
	syscall
	move $a0, $s0
	add $a0, $a0, $v0
	sb $zero, 0($a0)
	
	# Dong file
	li $v0, 16
	move $a0, $s3
	syscall
	
	# Dem so de bai
	li $s3, 0 # Khoi tao count = 0
_ReadDeThi.Loop0:	
	lb $t0, ($s0)
	beqz $t0, _ReadDeThi.Exit_Count # Kiem tra t0 = '\0' thi Exit
	bne $t0, '*', _ReadDeThi.Skip_Count # Kiem tra t0 = '*' thi Skip
	# Khong thi tang dem
	addi $s3, $s3, 1
_ReadDeThi.Skip_Count:	
	addi $s0, $s0, 1
	j _ReadDeThi.Loop0
_ReadDeThi.Exit_Count:
	addi $s3, $s3, 1 # n dau '*' thi co n + 1 de
	
	# Ket qua tra ve la so luong de bai
	move $v0, $s3
	
# Cuoi thu tuc
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $t0, 8($sp)
	lw $s3, 12($sp)
	addi $sp ,$sp, 32
	jr $ra
	
# ---------------------------------------- Get De Thi --------------------------------------
# Truyen vao tham so a0 = Dia chi list_debai
# Truyen vao tham so a1 = Dia chi count_debai_old
# Truyen vao tham so a2 = Dia chi debai_old
# Truyen vao tham so a3 = Gia tri count_debai (so luong de bai)
_GetDeThi:
# Dau thu tuc
	addi $sp, $sp, -36
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $t0, 8($sp)
	sw $s3, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $t1, 24($sp)
	sw $t2, 28($sp)
	sw $t3, 32($sp)
	sw $t4, 36($sp)
	
# Than thu tuc
	# Truyen tham so
	move $s0, $a0 # Dia chi list_debai
	move $s1, $a1 # Dia chi count_debai_old
	move $s2, $a2 # Dia chi debai_old
	move $s3, $a3 # Gia tri count_debai
	
	# Random number 0 <= [int] < a1
	move $t4, $s2 # Back up Dia chi debai_old
_GetDeThi.Loop0:	
	li $v0, 42
	li $a0, 0 # Set seed
	move $a1, $s3
	syscall
	move $t1, $a0
	# Kiem tra xem co trung de bai cu
	lw $t2, ($s1)
	beqz $t2, _GetDeThi.Skip_Repeat # Kiem tra t2 == 0 thi skip
	move $s2, $t4 # Reset Dia chi debai_old
	li $t3, 0 # Khoi tao index i
_GetDeThi.Loop1:	
	lw $t0, ($s2)
	beq $t1, $t0, _GetDeThi.Loop0 # Kiem tra t1 == t0 thi loop
	addi $s2, $s2, 4
	addi $t3, $t3, 1
	bne $t3, $t2, _GetDeThi.Loop1 # Kiem tra t3 != t2 thi loop
_GetDeThi.Skip_Repeat:
	# Tang count_debai_old
	addi $t2, $t2, 1 
	sw $t2, ($s1)
	sw $t1, ($s2) # Luu de bai moi vao debai_old
	
	# Dua mot de bai random tu list_debai vao debai
	la $t3, debai
	li $t2, 0 # Khoi tao count'*' = 0
_GetDeThi.Loop2:
	beq $t2, $t1, _GetDeThi.Copy # Kiem tra count'*' == rand thi Copy
	# rand = 0 -> de 1 -> count'*' = 0
	# rand = 1 -> de 2 -> count'*' = 1 ...
	lb $t0, ($s0)
	bne $t0, '*', _GetDeThi.Skip_CountStar # Kiem tra t0 != '*' thi Skip
	# Khong thi tang dem '*'
	addi $t2, $t2, 1
_GetDeThi.Skip_CountStar:
	addi $s0, $s0, 1
	j _GetDeThi.Loop2
_GetDeThi.Copy:
	lb $t0, ($s0)
	beq $t0, '*', _GetDeThi.Exit_Copy
	beqz $t0, _GetDeThi.Exit_Copy # Kiem tra t0 == '*' hoac '\0' thi Exit
	# Khong thi copy 1 de tu list_debai qua debai
	sb $t0, ($t3)
	addi $s0, $s0, 1
	addi $t3, $t3, 1
	j _GetDeThi.Copy
_GetDeThi.Exit_Copy:
	sb $0, ($t3) # Chen ki tu ket thuc chuoi cho debai
	
# Cuoi thu tuc	
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $t0, 8($sp)
	lw $s3, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $t1, 20($sp)
	lw $t2, 24($sp)
	lw $t3, 28($sp)
	lw $t4, 32($sp)
	addi $sp ,$sp, 32
	jr $ra


########################################### HANGMAN - TURNGAME  ########################################
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
	la $a0, chuoiKiTu
	syscall
	li $v0, 4
	la $a0, enter
	syscall
	j _game.Main #ket thuc turn game
###########################################################
##          HAM KHOI TAO CHUOI BAT DAU GAME              ##
###########################################################
init_GuessString:
	#gan chuoiKiTu = '*'s
	la $t0, chuoiKiTu
	li $t1, 0
	lb $t2, u #*
	lw $t3, length
while_GuessString:
	beq $t1, $t3, exit_GuessString	#$t1 dem so lan lap 
	sb $t2, 0($t0)		#luu '*' -> chuoiKiTu
	addi $t0, $t0, 1	#
	addi $t1, $t1, 1	#tang dem
	j while_GuessString
	
exit_GuessString:
	sb $zero, 0($t0)
	li $v0, 4
	la $a0, enter
	syscall
	li $v0, 4
	la $a0, chuoiKiTu
	syscall
	j _game.Loop
	#j _mainTurn #test ham
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
	la $t0, debai
	la $t1, chuoiKiTu
	li $t2, 0
	lw $t3, length	
	lb $t5, u
	li $s0, 0 #### neu user doan trung thi $s0->1
while_Char:
	
	beq $t2, $t3, exit_Char	#dieu kien ngung lap
	lb $t6, 0($t0)			
	lb $t7, 0($t1)		 
	bne $t7, $t5 dontSet	#khong phai dau * thi k set ki tu
	beq $t6, $t4, set	#giong ki tu goc thi set
	j dontSet
	
	set:#co ki tu thi chay qua ham set, neu khong chay qua ham set -> ki tu do sai
	sb $t4, 0($t1)		#gan ki tu dung vao chuoiKiTu
	addi $s0, $0, 1
	lw $s1, soKiTuDaDoan    #dem so ki tu da doan
	addi $s1, $s1, 1
	sw $s1, soKiTuDaDoan
	
	dontSet:
	addi $t0, $t0, 1	#tang chuoi
	addi $t1, $t1, 1
	addi $t2, $t2, 1	#tang bien dem
	j while_Char		
exit_Char:
	seq $t0, $s0, 1
	beq $t0, 1, print_GuessedString
	lw $t0, soLanDoanSai
	addi $t0, $t0, 1
	sw $t0, soLanDoanSai
	j print_GuessedString
###########################################################
##               HAM NHAN VA DUYET DAP AN                ##
###########################################################
get_Answer:#Nhap chuoi dap an
	li $v0, 4
	la $a0, strTBNhap2
	syscall
	
	li $v0, 8
	la $a0, chuoiDoanDapAn
	li $a1 60
	syscall
	la $t3, chuoiDoanDapAn
	
set_Answer:#set vong lap
	la $t0, debai
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
	j _game.EndWin
exit_Answer_False:
	li $v0, 4
	la $a0, strTBSai
	syscall
	j _game.EndLose
################################################## HANGMAN - GRAPHIC #########################################################	

	#Input how many times user fail

_inputHangProcess:
	lw $a0, soLanDoanSai
	#addi $v0, $zero, 5
	#syscall
	
	#add $a0, $v0, $zero
	jal _printHangProcess
	j _game.Loop
	

#Thuat toan: 1. Nhap ten 2.L?p qua tung char. moi char lai truyen vao ham kiem tra, neu dung di tiep(ket thuc ham), neu sai thong bao sai,
# quay lai 1
# 3. Neu dung het thi ket thuc lap, tra ve ra.
	

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
######################################################### HANGMAN - USERNAME ####################################
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
############################################### HANGMAN - WIN_LOSE FUNCTION ##################################

#####################DOCUMENTATION############################
# KIEM TRA DUNG HET TU HOAC DOAN 1 LAN DUNG NGUYEN TU LUON
# THI GOI label
# _game.correctGuess
# 
# NEU DOAN HET LUOT HOAC DOAN SAI TU 
# THI GOI label
# _game.incorrectGuess
#
# O HAM _game.correctGuess
# THAY LABEL PLACEHOLDER BANG 
# LABEL CHAY LUOT CHOI TIEP THEO
#
# CAN CAC BIEN SAU:
# currentScore: 
# correctGuesses:
# highScore: .word 2 (optional, ko co thi xuong duoi xoa phan highscore la duoc)
# username: .word
# length: .space 4
##############################################################

#tra loi dung goi ham nay
_game.correctGuess:
	#prints + pts
	li $v0, 4
	la $a0, strCorrect
	syscall
	
	#SOUND GOOD
	jal soundGood
	
	# +length pts
	la $a0, currentScore
	lw $a1, currentScore
	lw $a2, length
	add $a1, $a1, $a2
	sw $a1, currentScore
	
	# +1 correct guesses
	la $a0, correctGuesses
	lw $a1, correctGuesses
	addi $a1, $a1, 1
	sw $a1, correctGuesses
	
	
	#prints current score string
	li $v0, 4
	la $a0, strScore
	syscall
	
	li $v0, 1
	lw $a0, currentScore
	syscall
	
	#prints newline
	li $v0, 4
	la $a0, enter
	syscall
	
#	j REPLACE_nextTurn_REPLACE
	j _game.Restart
#thay bang label ham chay turn tiep theo


#tra loi sai goi ham nay
_game.incorrectGuess:
	#prints game over string
	li $v0, 4
	la $a0, strIncorrect
	syscall
	
	#print word
	li $v0, 4
	la $a0, strIncorrect2
	syscall
	
	li $v0, 4
	la $a0, debai
	syscall

	#prints newline
	li $v0, 4
	la $a0, enter
	syscall

	#sound bad
	jal soundBad

	#prints current score string
	li $v0, 4
	la $a0, strLose
	syscall
	
	li $v0, 1
	lw $a0, currentScore
	syscall
	
	#prints newline
	li $v0, 4
	la $a0, enter
	syscall

	#neu implement high score thi uncomment 2 dong nay + highScore o tren .data
#	lw $a1, highScore
#	bgt $a0, $a1, _game.incorrectGuessHighScore
	j _game.incorrectGuess2

#ham dung de no^'i, dung goi truc tiep
#khong implement highscore thi khoi chep
_game.incorrectGuessHighScore:
	li $v0, 4
	la $a0, strHighScore
	syscall
#	j _game.highScoreMusic		#neu co
	j _game.incorrectGuess2

#ham dung de no^'i, dung goi truc tiep
_game.incorrectGuess2:
	#prints newline
	li $v0, 4
	la $a0, enter
	syscall
	j _game.incorrectGuessWriteFile
	
_game.incorrectGuessWriteFile:
	#syscall 13 = open file
	#flag 9 = write append
	li $v0, 13
	la $a0, file_nguoichoi
	li $a1, 9
	li $a2, 0
	syscall
	move $s6, $v0 		#save file descriptor
	
	#print *
	li   $v0, 15		# system call for write to file
	move $a0, $s6		# file descriptor 
	la   $a1, star		# address of buffer from which to write
	addi   $a2, $zero, 1	# hardcoded buffer length
	syscall			# write to file
	
	#print username
	li   $v0, 15		# system call for write to file
	move $a0, $s6		# file descriptor 
	la   $a1, username	# address of buffer from which to write
	strlen(username)	# put strlen in $t3
	addi $t3, $t3, -1
	add   $a2, $zero, $t3	# hardcoded buffer length
	syscall			# write to file
	
	#print -
	li   $v0, 15		# system call for write to file
	move $a0, $s6		# file descriptor 
	la   $a1, dash		# address of buffer from which to write
	addi   $a2, $zero, 1	# hardcoded buffer length
	syscall		
	
	#convert score to string
	lw $a0, currentScore	# $a0 = int to convert
	la $a1, buffer		# $a1 = address of string where converted number will be kept
	jal  int2str		# call int2str
	
	#print score
	li   $v0, 15		# system call for write to file
	move $a0, $s6		# file descriptor 
	la   $a1, buffer	# address of buffer from which to write
	strlen(buffer)		# put strlen in $t3
	add   $a2, $zero, $t3	# hardcoded buffer length
	syscall			# write to file
	
	#print -
	li   $v0, 15		# system call for write to file
	move $a0, $s6		# file descriptor 
	la   $a1, dash		# address of buffer from which to write
	addi   $a2, $zero, 1	# hardcoded buffer length
	syscall	
	
	#convert number of correct words to string
	lw $a0, correctGuesses	# $a0 = int to convert
	la $a1, buffer		# $a1 = address of string where converted number will be kept
	jal  int2str		# call int2str
	
	#print number of correct words
	li   $v0, 15		# system call for write to file
	move $a0, $s6		# file descriptor 
	la   $a1, buffer	# address of buffer from which to write
	strlen(buffer)		# put strlen in $t3
	add   $a2, $zero, $t3	# hardcoded buffer length
	syscall	

	li   $v0, 16		# system call for close file
  	move $a0, $s6		# file descriptor to close
  	syscall			# close file
  	
	j _game.continueQuery

_game.continueQuery:
	#ask if player wants to continue
	li $v0, 4
	la $a0, strContinue
	syscall
	
	
	#get Y/N string
	li $v0, 12
	syscall
	
	lb $a1, uppercaseAffirm		#load "Y"
	lb $a2, lowercaseAffirm		#load "y"
	beq $v0, $a1, _game.newGame	#thay bang label restart
	beq $v0, $a2, _game.newGame	#thay bang label restart
	j _exit

_game.newGame:
	j _game.Restart
_exit:
	j _exitHangMan
	
##############################################
######function chuyen int thanh string########
##############################################
int2str:
	addi $sp, $sp, -4         # to avoid headaches save $t- registers used in this procedure on stack
	sw   $t0, ($sp)           # so the values don't change in the caller. We used only $t0 here, so save that.
	j    next0                # else, goto 'next0'

next0:
	li   $t0, -1
	addi $sp, $sp, -4         # make space on stack
	sw   $t0, ($sp)           # and save -1 (end of stack marker) on MIPS stack

push_digits:
	blez $a0, next1           # num < 0? If yes, end loop (goto 'next1')
	li   $t0, 10              # else, body of while loop here
	div  $a0, $t0             # do num / 10. LO = Quotient, HI = remainder
	mfhi $t0                  # $t0 = num % 10
	mflo $a0                  # num = num // 10  
	addi $sp, $sp, -4         # make space on stack
	sw   $t0, ($sp)           # store num % 10 calculated above on it
	j    push_digits          # and loop

next1:
	lw   $t0, ($sp)           # $t0 = pop off "digit" from MIPS stack
	addi $sp, $sp, 4          # and 'restore' stack

	bltz $t0, neg_digit       # if digit <= 0, goto neg_digit (i.e, num = 0)
	j    pop_digits           # else goto popping in a loop

neg_digit:
	li   $t0, '0'
	sb   $t0, ($a1)           # *str = ASCII of '0'
	addi $a1, $a1, 1          # str++
	j    next2                # jump to next2

pop_digits:
	bltz $t0, next2           # if digit <= 0 goto next2 (end of loop)
	addi $t0, $t0, '0'        # else, $t0 = ASCII of digit
	sb   $t0, ($a1)           # *str = ASCII of digit
	addi $a1, $a1, 1          # str++
	lw   $t0, ($sp)           # digit = pop off from MIPS stack 
	addi $sp, $sp, 4          # restore stack
	j    pop_digits           # and loop

next2:
	sb  $zero, ($a1)          # *str = 0 (end of string marker)
	lw   $t0, ($sp)           # restore $t0 value before function was called
	addi $sp, $sp, 4          # restore stack
	jr  $ra                   # jump to caller	
	
	
	
##############SOUND##################
soundBad:

	li $v0, 31	#Number for syscall
	li $a0, 40	#Pitch
	li $a1, 1000	#Duration
	li $a2, 56	#Instrument
	li $a3, 127	#Volume
	syscall

	jr $31

soundGood:

	li $v0, 33	#Number for syscall
	li $a0, 62	#Pitch
	li $a1, 250	#Duration
	li $a2, 0	#Instrument
	li $a3, 127	#Volume
	syscall

	li $v0, 31	#Number for syscall
	li $a0, 67	#Pitch
	li $a1, 1000	#Duration
	li $a2, 0	#Instrument
	li $a3, 127	#Volume
	syscall

	jr $31
###########################################

###################################################### HANGMAN - IN TOP 10 #########################################################			

# ---------------- Sort Descending ----------------
# Truyen vao tham so a0 = list_diemso_ngchoi.length
# Truyen vao tham so a1 = Dia chi list_diemso_ngchoi
# Truyen vao tham so a2 = Dia chi list_pointer_ngchoi

_SortDesc:
# Dau thu tuc
	addi $sp, $sp, -48
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $t0, 16($sp)
	sw $t1, 20($sp)
	sw $t2, 24($sp)
	sw $s3, 28($sp)
	sw $t3, 32($sp)
	sw $s4, 36($sp)
	sw $t4, 40($sp)
	sw $t5, 44($sp)
	sw $t6, 48($sp)
# Than thu tuc
	# Truyen tham so
	move $s0, $a0 # list_diemso_ngchoi.length
	move $s1, $a1 # Dia chi list_diemso_ngchoi
	move $s2, $a1 # Dia chi list_diemso_ngchoi
	move $s3, $a2 # Dia chi list_pointer_ngchoi
	move $s4, $a2 # Dia chi list_pointer_ngchoi
	
	# Tien hanh sort
	#Khoi tao vong lap 0
	li $t0, 0 # i = 0
	
_SortDesc.Loop0:
	move $s2, $a1 # Reset lai dia chi list_diemso_ngchoi
	move $s4, $a2 # Reset lai dia chi list_pointer_ngchoi
	li $t4, 4
	lw $t2, ($s1) # t2 = list_diemso_ngchoi[i]
	lw $t5, ($s3) # t5 = list_pointer_ngchoi[i]
	#Khoi tao vong lap 1
	addi $t1, $t0, 1 # j = i + 1
	beq $t1, $s0, _SortDesc.End
	mult $t1, $t4
	mflo $t4
	add $s2, $s2, $t4 # Tang dia chi s2
	add $s4, $s4, $t4 # Tang dia chi s4
_SortDesc.Loop1:
	lw $t3, ($s2) # t3 = list_diemso_ngchoi[j]
	lw $t6, ($s4) # t6 = list_pointer_ngchoi[j]
	
	blt $t3, $t2, _SortDesc.Skip # Kiem tra arr[i] > arr[j] thi skip
	# Khong thi swap list_diemso_ngchoi[i] va list_diemso_ngchoi[j]
	# swap list_pointer_ngchoi[i] va list_pointer_ngchoi[j]
	sw $t3, ($s1) # list_diemso_ngchoi[i] = t3
	sw $t2, ($s2) # list_diemso_ngchoi[j] = t2
	lw $t2, ($s1) # t2 = list_diemso_ngchoi[i]
	
	sw $t6, ($s3)
	sw $t5, ($s4)
	lw $t5, ($s3)
_SortDesc.Skip:
	addi $s2, $s2, 4 # Tang dia chi
	addi $s4, $s4, 4
	addi $t1, $t1, 1 # Tang j
	blt $t1, $s0, _SortDesc.Loop1 # Kiem tra j < n thi lap
	
	addi $s1, $s1, 4 # Tang dia chi
	addi $s3, $s3, 4
	addi $t0, $t0, 1 # Tang i
	blt $t0, $s0, _SortDesc.Loop0 # Kiem tra i < n thi lap
_SortDesc.End:

#Cuoi thu tuc
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $t0, 16($sp)
	lw $t1, 20($sp)
	lw $t2, 24($sp)
	lw $s3, 28($sp)
	lw $t3, 32($sp)
	lw $s4, 36($sp)
	lw $t4, 40($sp)
	lw $t5, 44($sp)
	lw $t6, 48($sp)
	addi $sp, $sp, 48
	jr $ra

# ---------------- Print Top 10 ----------------
# Truyen vao tham so a0 = Dia chi list_ngchoi
# Truyen vao tham so a1 = Dia chi list_pointer_ngchoi
# Truyen vao tham so a2 = Dia chi list_diemso_ngchoi
	
_PrintTop10:
# Dau thu tuc
	addi $sp, $sp, -48
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $t0, 16($sp)
	sw $t1, 20($sp)
	sw $t2, 24($sp)
	sw $s3, 28($sp)
	sw $t3, 32($sp)
	sw $s4, 36($sp)
	sw $s5, 40($sp)
	sw $t4, 44($sp)
	move $t4, $ra
# Than thu tuc
	#Truyen tham so
	move $s0, $a0 # Dia chi list_ngchoi
	move $s1, $a1 # Dia chi list_pointer_ngchoi
	move $s2, $a2 # Dia chi list_diemso_ngchoi
	
	move $s4, $a1 # Dia chi list_pointer_ngchoi
	move $s5, $a2 # Dia chi list_diemso_ngchoi
	
	# Thao tac xu li file	
	# Mo file
	li $v0, 13
	la $a0, file_nguoichoi
	li $a1, 0
	li $a2, 0
	syscall # File descriptor dc luu vao $v0
	move $s3, $v0
	
	# Doc file
	li $v0, 14
	move $a0, $s3
	move $a1, $s0
	li $a2, 1024
	syscall
	move $a0, $s0
	add $a0, $a0, $v0
	sb $zero, 0($a0)
	
	# Dong file
	li $v0, 16
	move $a0, $s3
	syscall
	
	move $t2, $s0 # Backup Dia chi list_ngchoi
	# Dem so nguoi choi va luu vi tri cua moi nguoi choi
	li $s3, 0 # Khoi tao count = 0
	la $t1, ($s0)
	sw $t1, ($s1) # Luu dia chi cua phan tu dau tien
	addi $s1, $s1, 4
_PrintTop10.Loop0:	
	lb $t0, ($s0)
	beqz $t0, _PrintTop10.Exit_Count # Kiem tra t0 = '\0' thi Exit
	bne $t0, '*', _PrintTop10.Skip_Count # Kiem tra t0 = '*' thi Skip
	# Khong thi tang dem
	addi $s3, $s3, 1
	addi $s0, $s0, 1
	la $t1, ($s0)
	sw $t1, ($s1)
	addi $s1, $s1, 4
	addi $s0, $s0, -1
_PrintTop10.Skip_Count:	
	addi $s0, $s0, 1
	j _PrintTop10.Loop0
_PrintTop10.Exit_Count:
	addi $s3, $s3, 1 # n dau '*' thi co n + 1 nguoi choi
	move $s1, $s4 # Reset Dia chi list_pointer_ngchoi
	move $s0, $t2 # Reset Dia chi list_ngchoi
	
	# Rut trich diem so
	li $t0, 0 # Khoi tao count'-'
	li $t1, 0
	li $t2, 10
_PrintTop10.Loop1:
	lb $t3, ($s0)
	bne $t3, '*', _PrintTop10.LoadNumSkip # Kiem tra t1 != '*' thi Skip
	# Khong thi dua du lieu vao list_diemso_ngchoi
	div $t1, $t2
	mflo $t1
	sw $t1, ($s2)
	addi $s2, $s2, 4 # Tang dia chi
	li $t1, 0 # Reset $t1
	li $t0, 0 # Reset count'-'
_PrintTop10.LoadNumSkip:
	beqz $t3, _PrintTop10.Exit # Kiem tra t1 == '\0' thi Exit
	
	bne $t3, '-', _PrintTop10.CountHyphenSkip # Kiem tra t1 != '-' thi Skip
	# Khong thi tang dem '-' va tang dia chi
	addi $t0, $t0, 1
	bne $t0, 1, _PrintTop10.GetNumSkip # Kiem tra count'-' != 1 thi Skip
	# Khong thi tang dia chi
	addi $s0, $s0, 1 # Tang dia chi de vuot qua dau '-' lan dau tien
	lb $t3, ($s0)
_PrintTop10.CountHyphenSkip:
	bne $t0, 1, _PrintTop10.GetNumSkip # Kiem tra count'-' != 1 thi Skip
	# Khong thi thuc hien rut trich so nguyen
	addi $t3, $t3, -48 # Chuyen ki tu thanh so nguyen
	add $t1, $t1, $t3
	mult $t1, $t2
	mflo $t1 # t1 = t1 * 10
_PrintTop10.GetNumSkip:
	addi $s0, $s0, 1 # Tang dia chi
	j _PrintTop10.Loop1
_PrintTop10.Exit:
	# Dua du lieu cuoi vao list_diemso_ngchoi
	div $t1, $t2
	mflo $t1
	sw $t1, ($s2)
	move $s2, $s5 # Reset Dia chi list_diemso_ngchoi
	
	# Sap xep giam dan
	move $a0, $s3
	move $a1, $s2
	move $a2, $s1
	jal _SortDesc

	
	# Xuat top 10 nguoi choi co diem so cao nhat
	# Khoi tao vong lap 2
	li $t0, 0
_PrintTop10.Loop2:	
	lw $t1, ($s1)
_PrintTop10.Print_Loop:
	lb $t2, ($t1)
	beq $t2, '*', _PrintTop10.Print_Skip # Kiem tra t2 ==  '*' thi skip
	beqz $t2, _PrintTop10.Print_Skip # Kiem tra t2 == '\0' thi skip
	# Khong thi in ra man hinh
	li $v0, 11
	move $a0, $t2
	syscall
	addi $t1, $t1, 1
	j  _PrintTop10.Print_Loop
_PrintTop10.Print_Skip:
	# In new line
	li $v0, 11
	li $a0, '\n'
	syscall
	
	addi $s1, $s1, 4
	addi $t0, $t0, 1
	beq $t0, 10, PrintTop10_Loop2_Exit # Kiem tra i == 10 thi Exit
	bne $t0, $s3, _PrintTop10.Loop2 # Kiem tra i == length thi loop
PrintTop10_Loop2_Exit:

# Cuoi thu tuc
	lw $ra, ($sp)
	move $ra, $t4
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $t0, 16($sp)
	lw $t1, 20($sp)
	lw $t2, 24($sp)
	lw $s3, 28($sp)
	lw $t3, 32($sp)
	lw $s4, 36($sp)
	lw $s5, 40($sp)
	lw $t4, 44($sp)
	addi $sp, $sp, 44
	jr $ra

###########################################################
###                        EXIT                         ###
########################################################### 
_exitHangMan:
	li $v0, 4
	la $a0, strTop
	syscall

	la $a0, list_ngchoi
	la $a1, list_pointer_ngchoi
	la $a2, list_diemso_ngchoi
	jal _PrintTop10
	
	li $v0, 4
	la $a0, strGoodbye
	syscall
	
	li $v0, 12 # sys code for readchar
    	syscall
	
	li $v0,10
	syscall

