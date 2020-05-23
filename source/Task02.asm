	.data
file_debai:	.asciiz "data\\dethi.txt"
file_ngchoi:	.asciiz "data\\nguoichoi.txt"
list_debai:	.space 1024
list_ngchoi:	.space 1024
list_pointer_ngchoi:	.space 1024
list_diemso_ngchoi:	.space 1024
debai:		.space 100
	.text
main:
	# Goi ham DocDeThi
	la $a0, list_debai
	la $a1, debai
	jal _DocDeThi

	# Goi ham XuatTop10
	la $a0, list_ngchoi
	la $a1, list_pointer_ngchoi
	la $a2, list_diemso_ngchoi
	jal _XuatTop10
	
	#ket thuc
	li $v0,10
	syscall


# ---------------- Doc De Thi ----------------
# Ket qua tre ve dia chi chuoi de bai luu vao $v0
# Tham so a0 = Dia chi list_debai, a1 = Dia chi debai
_DocDeThi:
# Dau thu tuc
	addi $sp, $sp, -32
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $t0, 20($sp)
	sw $t1, 24($sp)
	sw $t2, 28($sp)
	
# Than thu tuc
	# Truyen tham so
	move $s0, $a0 # Dia chi list_debai
	move $s1, $a0 # Dia chi list_debai - Dung de reset dia chi neu can
	move $s2, $a1 # Dia chi debai
	move $t2, $a1 # Dia chi debai
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
_DocDeThi.Loop0:	
	lb $t0, ($s0)
	beqz $t0, _DocDeThi.Exit_Count # Kiem tra t0 = '\0' thi Exit
	bne $t0, '*', _DocDeThi.Skip_Count # Kiem tra t0 = '*' thi Skip
	# Khong thi tang dem
	addi $s3, $s3, 1
_DocDeThi.Skip_Count:	
	addi $s0, $s0, 1
	j _DocDeThi.Loop0
_DocDeThi.Exit_Count:
	addi $s3, $s3, 1 # n dau '*' thi co n + 1 de
	
	# Dua mot de bai random tu list_debai vao debai
	# Random number 0 <= [int] < a1
	li $v0, 42
	li $a0, 0 # Set seed
	move $a1, $s3
	syscall
	move $s3, $a0
	
	li $t1, 0 # Khoi tao count'*' = 0
_DocDeThi.Loop1:
	beq $t1, $s3, _DocDeThi.Copy # Kiem tra count'*' == rand thi Copy
	# rand = 0 -> de 1 -> count'*' = 0
	# rand = 1 -> de 2 -> count'*' = 1 ...
	lb $t0, ($s1)
	bne $t0, '*', _DocDeThi.Skip_CountStar # Kiem tra t0 != '*' thi Skip
	# Khong thi tang dem '*'
	addi $t1, $t1, 1
_DocDeThi.Skip_CountStar:
	addi $s1, $s1, 1
	j _DocDeThi.Loop1
_DocDeThi.Copy:
	lb $t0, ($s1)
	beq $t0, '*', _DocDeThi.Exit_Copy
	beqz $t0, _DocDeThi.Exit_Copy # Kiem tra t0 == '*' hoac '\0' thi Exit
	# Khong thi copy 1 de tu list_debai qua debai
	sb $t0, ($s2)
	addi $s1, $s1, 1
	addi $s2, $s2, 1
	j _DocDeThi.Copy
_DocDeThi.Exit_Copy:
	sb $0, ($s2) # Chen ki tu ket thuc chuoi cho debai
	
	move $v0, $t2 # Tra ve ket qua la dia chi cua label debai
# Cuoi thu tuc
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $t0, 16($sp)
	lw $t1, 20($sp)
	addi $sp ,$sp, 32
	jr $ra

# ---------------- Xuat Top 10 ----------------
_XuatTop10:
# Dau thu tuc
	addi $sp, $sp, -40
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $t0, 16($sp)
	sw $t1, 20($sp)
	sw $t2, 24($sp)
	sw $s3, 28($sp)
	sw $s4, 32($sp)
	sw $s5, 36($sp)
	sw $s6, 40($sp)
	
# Than thu tuc
	move $s0, $a0 # Dia chi list_ngchoi
	move $s4, $a0 # Dia chi list_ngchoi/De reset dia chi
	move $s1, $a1 # Dia chi list_pointer_ngchoi
	move $s5, $a1 # Dia chi list_pointer_ngchoi/De reset dia chi
	move $s2, $a2 # Dia chi list_diemso_ngchoi
	move $s6, $a2 # Dia chi list_diemso_ngchoi/De reset dia chi
	
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
	
	# Dem so nguoi choi
	li $s3, 0 # Khoi tao count = 0
	la $t1, ($s0)
	sd $t1, ($s1) # Luu dia chi cua phan tu dau tien
	addi $s1, $s1, 4
_XuatTop10.Loop0:	
	lb $t0, ($s0)
	beqz $t0, _XuatTop10.Exit_Count # Kiem tra t0 = '\0' thi Exit
	bne $t0, '*', _XuatTop10.Skip_Count # Kiem tra t0 = '*' thi Skip
	# Khong thi tang dem
	addi $s3, $s3, 1
	addi $s0, $s0, 1
	la $t1, ($s0)
	sd $t1, ($s1)
	addi $s1, $s1, 4
	addi $s0, $s0, -1
_XuatTop10.Skip_Count:	
	addi $s0, $s0, 1
	j _DocDeThi.Loop0
_XuatTop10.Exit_Count:
	addi $s3, $s3, 1 # n dau '*' thi co n + 1 nguoi choi
	
	