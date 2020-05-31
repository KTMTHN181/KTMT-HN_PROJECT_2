        .data
fout:   .asciiz "ketqua.txt"      # filename xuat output
wintext: .asciiz "Ban thang"		
losetext: .asciiz "Ban Thua"
ask: .asciiz "Ban muon choi tiep? (1:Tiep,0:Khong)"
TBdiem: .asciiz "Diem:"
        .text
	li $s4,0 #Diem nguoi choi
	li $s5,5 #mang song nguoi choi =5 , co the bi tru trong qua trinh choi
while 
	li $v0,5		
	syscall
	move $s0,$v0
	li	$s1,1	
	beq $s0,$s0, Exit	##Neu s0=1 thi tiep tuc choi, khong thi thoi
	li $a0, length	#Luu so chu trong tu
	move $s2,$a0	#s2=so tu
	addi $s4,$s4,$s2	#luu diem
	li $v0,4
	la $a0,TBdiem
	syscall
	li $v0,1
	move $a0,$s4
	syscall
	################Lenh tiep tuc choi
	## check mang song thuong xuyen va break ra neu chet => thua
	##.....
	##Thua:
	li $v0,4
	la $v0,losetext
	bltz $s5,Exit 
	##Thang:
	li $v0,4
	la $v0,wintext
Exit:
	##Thong bao diem
	li $v0,4
	la $a0,TBdiem
	syscall
	li $v0,1
	move $a0,$s4
	syscall
	li $v0,10
	syscall	
