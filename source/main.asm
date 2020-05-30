	.data

#main program
numIncorrectGuesses:	.word 0
#wordLength:		.word 0
numLettersGuessed:	.word 0
#wordToGuess: 		.asciiz
prevGuessed:		.asciiz
guessedLetters: 	.asciiz
numCorrectGuesses:	.word 0

#graffiti
fail1: .asciiz "_______\n|/    |\n|\n|\n|\n|\n|\n"
fail2: .asciiz "_______\n|/    |\n|     O\n|\n|\n|\n|\n"
fail3: .asciiz "_______\n|/    |\n|     O\n|     |\n|\n|\n|\n"
fail4: .asciiz "_______\n|/    |\n|     O\n|    /|\n|\n|\n|\n"
fail5: .asciiz "_______\n|/    |\n|     O\n|    /|\\\n|\n|\n|\n"
fail6: .asciiz "_______\n|/    |\n|     O\n|    /|\\\n|    /\n|\n|\n"
fail7: .asciiz "_______\n|/    |\n|     O\n|    /|\\\n|    / \\\n|\n|\n"

#username
inputLabel: .asciiz "Oops. We do not have any thing about you. Let's introduction with each other, I'm the one who try to hang you and you is: "
conditionalLabel: .asciiz "\n\nAh, don't forget the first rule in this game: Your name must containt only: A-Z, a-z, 0-9. Ok, your name is: "
wrongInputLabel: .asciiz "\nOh no, your name have some characters out of: A-Z, a-z, 0-9. Don't worry, just input again ;)"
inputOkLabel: .asciiz "Welcome "
welcomeLabel: .asciiz "The stage is yours now!"
theWrongIs: .asciiz "\nThis one is wrong: "
downLine: .asciiz "\n"
username: .space 50
test: .asciiz "."
#$a2 giu bool cua ham CheckName
#$a3 giu bool cua ham CheckChar

#dictionary
file_debai:	.asciiz "data\\dethi.txt"
file_ngchoi:	.asciiz "data\\nguoichoi.txt"
list_debai:	.space 1024
list_ngchoi:	.space 1024
list_pointer_ngchoi:	.space 1024
list_diemso_ngchoi:	.space 1024
debai:		.space 100

#turn
u: .asciiz "*" #ki tu quy dinh
enter: .asciiz "\n" #enter
strTBturn: .asciiz "\nBan muon: \n1. Doan ki tu \n2. Doan dap an \n -----> Chon:"
strTBNhap1: .asciiz "Nhap ki tu:"
strTBNhap2: .asciiz "Nhap dap an:"
strTBDung: .asciiz "DUNG ROI!!!"
strTBSai: .asciiz "SAI ROI!!!"

guessWord: .asciiz	# de truyen vao bien nay
length: .word 0 	#do dai de truyen vao bien nay

guessedAnswer: .asciiz""
guessedString: .asciiz""

.include "printHangMacros.asm"

	.text
main:

	addi $s3, $zero, 1 #set $s3 to 1 for use later
	add $s4, $sp, $zero	#sets array up on stack
	addi $s5, $sp, 4	#sets array pointer
	la $t0, guessWord
	lb $s2, numIncorrectGuesses #sets $s2 to null bit
	addi $s1, $zero, -1	#set string length to -2 (to get correct value later)
	sw $s1, length

	#list of registers: $s0 = 2, $s1 = nothing, $s2 = null, $s3 = 1, $s4 = $sp, $s5 = $sp (used to move up and down array), $s6 used in generateWord can be used in other things, $s7 = used to store imported char
	#		    $t0 = address of wordToGuess, $t1 = used in printChar, $t2 = used in checkForMatch
	#stack is used for the array - should that be changed?

#	li $v0, 4
#	la $a0, stringInput
#	syscall		#prompt user for input
#	li $v0, 8
#	la $a0, wordToGuess
#	li $a1, 256
#	syscall #loads a string into memory at string's address (max 256 chars)

	la $t0, guessWord
	li $t7, ' '

stackSetup:
	lb $a0, ($t0)
	jal addToStack		#adds onto stack
	addi $t0, $t0, 1
	bne $a0, $t7, stackSetup	#loops until a space is encountered


	addi $s0, $s0, 2
	sw $s0, ($sp)
	add $sp, $sp, -4	#takes 2 1's off the stack becasue there are 2 too many
	addi $sp, $sp, 24

	#Word inputed and store in memory; stack set up as array
loop:
	print_str("\n=====================================\n")

	la $t6, prevGuessed		#load prevGuessed into t6
	lw $t5, numLettersGuessed	#load number of letters guessed into t5
	add $t4, $zero, $zero		#reset t4 into 0

	# Print letters already guessed
	print_str("Guessed letters: ")
	li $v0, 4
	la $a0, guessedLetters
	syscall
	print_str("\n")

	add $s5, $s4, $zero	#set $s5 to beginning of array

	addi $s3, $zero, 1
	jal generateWord

	
	#goi _printHangProcess de in ra hinh nhan
	#$a1 thanh numIncorrectGuesses
	_printHangProcess

	lw $t3, numIncorrectGuesses
	beq $t3, 6, failure

	# Print number of incorrect guesses
	print_str("Incorrect guesses: ")
	li $v0, 1
	lw $a0, numIncorrectGuesses
	syscall
	print_str("\n")

	# Add guessed letter
	#print_str("Guess a letter: ")
	#li $v0, 12
	#syscall	#inputs a character
	#add $s7, $v0, $zero

	# Add guess
	#add $a0, $v0, $zero
	#jal addGuess
	#beq $v0, 1, loop2 # Continue if the add was valid

	# Otherwise, error
	#print_str("Letter already guessed.\n")
	#j loop
	
	

loop2:
	add $s5, $s4, $zero
	jal checkForMatch
	add $t2, $zero, $zero

	lw $t3, length
	lw $t4, numLettersGuessed
	beq $t3, $t4, success

	j loop

checkForMatch:
	la $t3, guessWord
	sub $t1, $s5, $s4
	div  $t1, $t1, 4
	add $a1, $t3, $t1
	lb $a0, ($a1)
	addi $s5, $s5, 4f
	beq $a0, $s7, checkIfAlreadyGuessed	#checks to see if character guessed is the same as current character in word; if yes, see if it has been guessed before
	beq $s2, $a0, matchCompleted	#when a null byte is encountered - word is over
	j checkForMatch

checkIfAlreadyGuessed:
	la $t6, prevGuessed
	lw $t5, numLettersGuessed
	add $t4, $zero, $zero

checkIfAlreadyGuessedLoop:
	add $s6, $t4, $t6
	lb $t0, ($s6)
	beq $t4, $t5, storeSetup	#if all previously guessed chars have been examined and none are the same, continue
	beq $t0, $a0, checkForMatch	#if a char has already been guessed, go back to checkForMatch
	addi $t4, $t4, 1
	j checkIfAlreadyGuessedLoop

storeSetup:
addi $a3, $zero, 2
j matchFound

storeInPrev:
	add $t4, $t5, $t6
	sb $a0, ($t4)
	j soundGood

matchFound:
	sw $s2, ($s5)
	add $t2, $zero, 2	#used in finished to see if a char matched
	lw $t7, numLettersGuessed
	addi $t7, $t7, 1
	sw $t7, numLettersGuessed	#increments the number of letters guessed - used for
	j checkForMatch

matchCompleted:
	bne $t2, 2, incrementGuessesNum	#if the letter guessed was not in the word, then incorrectguessess++
	beq $a3, 2, storeInPrev
	j soundGood
	#jr $ra	#otherwise go back to loop

incrementGuessesNum:	#if the letter guessed was not in the word, then incorrectguessess++
	lw $t3, numIncorrectGuesses
	add $t3, $t3, 1
	sw $t3, numIncorrectGuesses
	j soundBad	#play sound for incorrect guess
	#jr $ra

generateWord:	#make a word with _ and letters
	lb $s6, 4($s5)
	beq $s6, $s3, print_
	beq $s6, $s2, printChar
	jr $ra

print_:		#if value in array is 1, then an underscore is printed
	print_str("_ ")
	addi $s5, $s5, 4
	j generateWord

printChar:	#if value in array is 0, then the character from that spot is printed
	la $t3, wordToGuess
	sub $t1, $s5, $s4
	div  $t1, $t1, 4
	add $a1, $t3, $t1
	lb $a0, ($a1)
	li $v0, 11
	syscall

	addi $s5, $s5, 4
	print_str(" ")
	j generateWord

addToStack:
	lw $s1, wordLength
	addi $s1, $s1, 1
	sw $s1, wordLength
	add $sp, $sp, 4	#add 1 onto the stack
	sw $s3, ($sp)
	jr $ra

failure:	#reached from end of main loop
	print_str("\nYou have made too many incorrect guesses. Game Over")
	#insert sound for losing the game
	j end

success:	#reached from end of main loop
	print_str("\nYou have guessed all of the letters in the word. You Win\n")
	#insert sounds for winning the game
	j end

soundBad:

	li $v0, 33	#Number for syscall
	li $a0, 40	#Pitch
	li $a1, 1000	#Duration
	li $a2, 56	#Instrument
	li $a3, 127	#Volume
	syscall

	jr $ra

soundGood:

	li $v0, 33	#Number for syscall
	li $a0, 62	#Pitch
	li $a1, 250	#Duration
	li $a2, 0	#Instrument
	li $a3, 127	#Volume
	syscall

	li $v0, 33	#Number for syscall
	li $a0, 67	#Pitch
	li $a1, 1000	#Duration
	li $a2, 0	#Instrument
	li $a3, 127	#Volume
	syscall

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
	j loop

end:
	li $v0, 10
	syscall
