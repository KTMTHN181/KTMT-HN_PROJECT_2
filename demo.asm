	.data
	###data file
file_debai:	.asciiz "data\\dethi.txt"
.align 1
count_debai_old: .space 4
list_debai:	.space 1024
debai:		.space 100
debai_old:	.space 400
count_debai:	.space 4
length: .space 4 #do dai de truyen vao bien nay
	###data turn
u: .asciiz "*" #ki tu quy dinh
enter: .asciiz "\n" #enter
strTBturn: .asciiz "\nBan muon: \n1. Doan ki tu \n2. Doan dap an \n -----> Chon: "
strTBNhap1: .asciiz "Nhap ki tu:"
strTBNhap2: .asciiz "Nhap dap an:"
strTBDung: .asciiz "DUNG ROI!!!"
strTBSai: .asciiz "SAI ROI!!!"
chuoiDoanDapAn: .asciiz""
chuoiKiTu: .asciiz""
	.text
main:

_game.Login:


_game.Restart:
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
	sw $v0, length#luu length
	
	###in length
	#li $v0, 1
	#lw $a0, length
	#syscall
	
	li $v0, 4
	la $a0, debai
	syscall
	
	j _reset
_game.Loop:
	####cai gi gi do
	j _mainTurn
	
_game.End:
	###xu li thang thua cac thu	
		
# ---------------- Get Length ----------------
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
	
# ---------------- Get De Thi ----------------
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
	la $a0, chuoiKiTu
	syscall
	j _exitTurn #ket thuc turn game
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

while_Char:
	
	beq $t2, $t3, exit_Char	#dieu kien ngung lap
	lb $t6, 0($t0)			
	lb $t7, 0($t1)		 
	bne $t7, $t5 dontSet	#khong phai dau * thi k set ki tu
	beq $t6, $t4, set	#giong ki tu goc thi set
	j dontSet
	
	set:#co ki tu thi chay qua ham set, neu khong chay qua ham set -> ki tu do sai
	sb $t4, 0($t1)		#gan ki tu dung vao chuoiKiTu

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
#ket thuc
_exit:
	li $v0,10
	syscall
