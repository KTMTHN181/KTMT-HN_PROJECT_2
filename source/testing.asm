	.data
list_ngchoi:	.asciiz "Binh-100-3*Minh-231-4*Yen-123-2*Khang-143-2*Han-432-1"
list_diemso_ngchoi:	.space 1024
	.text
main:
	la $s0, list_ngchoi
	la $s1, list_diemso_ngchoi
	li $t0, 0 # Khoi tao count'-'
	li $s2, 0
	lb $t1, ($s0)
	bne $t1, '-', CountHyphenSkip
	addi $t0, $t0, 1
CountHyphenSkip:
	bne $t0, 1, LoadNumSkip
	mult $s2, 
	
LoadNumSkip: