.text
.macro 	print_str (%str)  #prints the string of a given label
	.data
string:	.asciiz %str
numIncorrectGuesses: .word 0
	.text
	li $v0, 4
	la $a0, string
	syscall
.end_macro
	
.macro _printHangProcess
#Prints different parts of gallows
##################################
	lw $a0, numIncorrectGuesses
	# 0 incorrect guesses
	beq $a0, 1, g1
	beq $a0, 2, g2
	beq $a0, 3, g3
	beq $a0, 4, g4
	beq $a0, 5, g5
	beq $a0, 6, g6
	beq $a0, 7, g7
	# 1 incorrect guess
g1:	print_str("_______\n|/    |\n|\n|\n|\n|\n|\n")
	#2 incorrect guesses
g2:	print_str("_______\n|/    |\n|     O\n|\n|\n|\n|\n")
	#3 incorrect guesses
g3:	print_str("_______\n|/    |\n|     O\n|     |\n|\n|\n|\n")
	#4 incorrect guesses
g4:	print_str("_______\n|/    |\n|     O\n|    /|\n|\n|\n|\n")
	#5 incorrect guesses
g5:	print_str("_______\n|/    |\n|     O\n|    /|\\\n|\n|\n|\n")
	#6 incorrect guesses
g6:	print_str("_______\n|/    |\n|     O\n|    /|\\\n|    /\n|\n|\n")
	#7 incorrect guesses
g7:	print_str("_______\n|/    |\n|     O\n|    /|\\\n|    / \\\n|\n|\n")
.end_macro