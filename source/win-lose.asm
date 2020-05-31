##########################################################
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
###############STATIC VARIABLES/STRINGS###################
file_nguoichoi:	.asciiz "data\\nguoichoitest.txt" #nho chinh lai dung file
strCorrect: .asciiz "Ban da doan dung tu!\n"
strIncorrect: .asciiz "Ban da doan sai! \n-----NUOC MAT ANH ROI-----\n----CUOC CHOI KET THUC----\n"
strScore: .asciiz "So diem hien tai cua ban la: "
strLose: .asciiz "So diem cuoi cung cua ban la: "
strHighScore: .asciiz "Chuc mung! Ban vua xac lap ki luc diem cao moi nhat!\n"
strContinue: .asciiz "Ban co muon choi lai tu dau khong? (Y/N) \n(Bat ki gia tri nao khac Y/y se ket thuc tro choi)"
strGoodbye: .asciiz "Goodnight."
enter: .asciiz "\n"
star: .asciiz "*"
dash: .asciiz "-"
uppercaseAffirm: .asciiz "Y"
lowercaseAffirm: .asciiz "y"

###########UNIQUE VARIABLES (trong main chua co)############
currentScore: .word 0		#moi lan thang + diem = do dai cua tu
correctGuesses: .word 123456
buffer: .space 128

#####GLOBAL VARIABLES (cac bien phai co san trong main)#####
#highScore: .word 2		#neu co dung den
username: .word
length: .space 4		#do dai cua tu dang doan, giong ben main

	.text
#######################DEBUG KO CAN CHEP########################
	.data
strWordLength: .asciiz "Nhap do dai cua tu: "
strInpScore: .asciiz "Nhap so diem hien tai: "
strInpName: .asciiz "Nhap ten nguoi choi: "
	.text
main:
	li $v0, 4
	la $a0, strWordLength
	syscall
	
	#get int
	li $v0, 5
	syscall

	#store int in length
	sw $v0, length
	
	#prints newline
	li $v0, 4
	la $a0, enter
	syscall
	
	li $v0, 4
	la $a0, strInpScore
	syscall
	
	#get int
	li $v0, 5
	syscall
	
	#store int in currentScore
	sw $v0, currentScore
	
	#prints newline
	li $v0, 4
	la $a0, enter
	syscall
	
	li $v0, 4
	la $a0, strInpName
	syscall
	
	la $a0, username
	addi $a1, $zero, 1000
	#get username string
	li $v0, 8
	syscall
	
	#prints newline
	li $v0, 4
	la $a0, enter
	syscall
	
	#test
	j _game.incorrectGuess
#	j _game.correctGuess
########################END OF DEBUG##########################

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
	j _exit
#thay bang label ham chay turn tiep theo


#tra loi sai goi ham nay
_game.incorrectGuess:
	#prints game over string
	li $v0, 4
	la $a0, strIncorrect
	syscall

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
  	
	j _exit

_game.continueQuery:
	#ask if player wants to continue
	li $v0, 4
	la $a0, strContinue
	syscall
	
	la $a0, buffer
	addi $a1, $zero, 1000
	#get Y/N string
	li $v0, 8
	syscall
	
	la $a1, uppercaseAffirm		#load "Y"
	la $a2, lowercaseAffirm		#load "y"
	beq $a0, $a1, _game.newGame	#thay bang label restart
	beq $a0, $a2, _game.newGame	#thay bang label restart
	j _exit

_game.newGame:
#placeholder label
#thay bang label restart game tao game moi

_exit:
	li $v0, 4
	la $a0, strGoodbye
	syscall
	
	li $v0,10
	syscall

#function chuyen int thanh string
#CHEP HET KHUC TU DAY DEN CUOI FILE NHA
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