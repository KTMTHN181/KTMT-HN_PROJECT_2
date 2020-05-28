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


# ============= SapXepGiamDan =============
_SapXepGiamDan:
#Dau thu tuc
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $t0,16($sp)
	sw $t1,20($sp)
	sw $t2,24($sp)
	sw $t3,28($sp)
	sw $t4,32($sp)
	# Lay tham so luu vao thanh ghi
	move $s0,$a0 #n gia tri
	move $s1,$a1 #arr
	move $s2,$a1 #arr
	move 

#Than thu tuc
	#Khoi tao vong lap 0
	li $t0, 0 # i = 0
	
_SapXepGiamDan.Loop0:
	move $s2, $a1 # Reset lai dia chi arr
	li $t4, 4
	lw $t2, ($s1) # t2 = arr[i]
	#Khoi tao vong lap 1
	addi $t1, $t0, 1 # j = i + 1
	beq $t1, $s0, _SapXepGiamDan.End
	mult $t1, $t4
	mflo $t4
	add $s2, $s2, $t4 # Tang dia chi s2
_SapXepGiamDan.Loop1:
	lw $t3, ($s2) # t3 = arr[j]
	
	blt $t2, $t3, _SapXepGiamDan.Skip # Kiem tra arr[i] < arr[j] thi skip
	# Khong thi swap arr[i] va arr[j]
	sw $t3, ($s1) # arr[i] = t3
	sw $t2, ($s2) # arr[j] = t2
	lw $t2, ($s1) # t2 = arr[i]
_SapXepGiamDan.Skip:
	addi $s2, $s2, 4 # Tang dia chi
	addi $t1, $t1, 1 # Tang j
	blt $t1, $s0, _SapXepTangDan.Loop1 # Kiem tra j < n thi lap
	
	addi $s1, $s1, 4 # Tang dia chi
	addi $t0, $t0, 1 # Tang i
	blt $t0, $s0, _SapXepTangDan.Loop0 # Kiem tra i < n thi lap
_SapXepGiamDan.End:
#Cuoi thu tuc
	#restore
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $t0,16($sp)
	lw $t1,20($sp)
	lw $t2,24($sp)
	lw $t3,28($sp)
	lw $t4,32($sp)
	#xoa stack
	addi $sp,$sp,32
	# tra ve
	jr $ra

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
	
	# Rut trich diem so
	li $t0, 0 # Khoi tao count'-'
	li $t1, 0
	li $t2, 10
_XuatTop10.Loop1:
	lb $t3, ($s0)
	bne $t3, '*', _XuatTop10.LoadNumSkip # Kiem tra t1 != '*' thi Skip
	# Khong thi dua du lieu vao list_diemso_ngchoi
	div $t1, $t2
	mflo $t1
	sw $t1, ($s2)
	addi $s2, $s2, 4 # Tang dia chi
	li $t1, 0 # Reset $s2
_XuatTop10.LoadNumSkip:
	beqz $t3, _XuatTop10.Exit # Kiem tra t1 == '\0' thi Exit
	
	bne $t3, '-', _XuatTop10.CountHyphenSkip # Kiem tra t1 != '-' thi Skip
	# Khong thi tang dem '-' va tang dia chi
	addi $t0, $t0, 1
	bne $t0, 1, _XuatTop10.GetNumSkip # Kiem tra count'-' != 1 thi Skip
	# Khong thi tang dia chi
	addi $s0, $s0, 1 # Tang dia chi de vuot qua dau '-' lan dau tien
	lb $t3, ($s0)
_XuatTop10.CountHyphenSkip:
	bne $t0, 1, _XuatTop10.GetNumSkip # Kiem tra count'-' != 1 thi Skip
	# Khong thi thuc hien rut trich so nguyen
	addi $t3, $t3, -48
	add $t1, $t1, $t3
	mult $t1, $t2
	mflo $t1 # t1 = t1 * 10
_XuatTop10.GetNumSkip:
	addi $s0, $s0, 1 # Tang dia chi
	j _XuatTop10.Loop1
_XuatTop10.Exit:
	# Dua du lieu cuoi vao list_diemso_ngchoi
	div $t1, $t2
	mflo $t1
	sw $t1, ($s2)
	
	move $s2, $s6 # Reset dia chi
	
	# Sap xep giam dan
	