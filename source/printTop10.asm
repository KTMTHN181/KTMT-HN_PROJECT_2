	.data
file_ngchoi:	.asciiz "data\\nguoichoi.txt"
.align 1
list_pointer_ngchoi:	.space 1024
list_diemso_ngchoi:	.space 1024
list_ngchoi:		.space 1024
	.text
main:
	la $a0, list_ngchoi
	la $a1, list_pointer_ngchoi
	la $a2, list_diemso_ngchoi
	jal _PrintTop10
_PrintTop10.Out:
			
	#ket thuc
	li $v0, 10
	syscall

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
	la $a0, file_ngchoi
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
