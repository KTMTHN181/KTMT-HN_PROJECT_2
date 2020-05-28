	.data
list_diemso_ngchoi:	.space 1024
list_ngchoi:	.asciiz "Binh-100-3*Minh-231-4*Yen-123-2*Khang-143-2*Han-432-1"
	.text
main:
	la $s0, list_ngchoi
	la $s1, list_diemso_ngchoi
	la $s3, list_diemso_ngchoi # Temp
	li $t0, 0 # Khoi tao count'-'
	li $s2, 0
	li $t2, 10
Loop:
	lb $t1, ($s0)
	bne $t1, '*', LoadNumSkip # Kiem tra t1 != '*' thi Skip
	# Khong thi dua du lieu vao list_diemso_ngchoi
	div $s2, $t2
	mflo $s2
	sw $s2, ($s1)
	addi $s1, $s1, 4 # Tang dia chi
	li $s2, 0 # Reset $s2
	
LoadNumSkip:
	beqz $t1, Exit # Kiem tra t1 == '\0' thi Exit
	
	bne $t1, '-', CountHyphenSkip # Kiem tra t1 != '-' thi Skip
	# Khong thi tang dem '-' va tang dia chi
	addi $t0, $t0, 1
	bne $t0, 1, GetNumSkip # Kiem tra count'-' != 1 thi Skip
	# Khong thi tang dia chi
	addi $s0, $s0, 1 # Tang dia chi de vuot qua dau '-' lan dau tien
	lb $t1, ($s0)
CountHyphenSkip:
	bne $t0, 1, GetNumSkip # Kiem tra count'-' != 1 thi Skip
	# Khong thi thuc hien rut trich so nguyen
	addi $t1, $t1, -48
	add $s2, $s2, $t1
	mult $s2, $t2
	mflo $s2 # s2 = s2 * 10
GetNumSkip:
	addi $s0, $s0, 1 # Tang dia chi
	j Loop
Exit:
	# Dua du lieu cuoi vao list_diemso_ngchoi
	div $s2, $t2
	mflo $s2
	sw $s2, ($s1)
	
	move $s1, $s3 # Reset dia chi
	
	