		.data
currentState:	.asciiz	"This is th current state of the GameBoard: \n"
playerOne:	.asciiz	"Player One enter your move \n"
playerTwo:	.asciiz	"Player two enter your move \n"
CR:		.byte	'\n
SPACE:		.byte	0x20
O:		.byte	'o
X:		.byte	'x
DOT:		.byte	'.
gameBoard:	.byte	-1,0,-1,0,1,0,-1,1,-1	#print the gae board by calculating the off set
		.code
		.globl	main
printBoard:
		la	$a0,currentState
		syscall	$print_string
		la	$t0,gameBoard
		li	$t6,0x03
		li	$t1,0x00
		
######################################################
# TO DO : calculate the address of the next grid spot
# TO DO : load the byte from that spot
# TO DO : < 0 ? ()
# TO DO : > 0 ? ()
# TO DO : = 0 ? Print DOT (beqz )
# TO DO : label and code for printing an x
# TO DO : label and code for printing an o
#######################################################
loop:		
		add	$t2,$t0,$t1	# t2 = effective address of the spot we want to check
		lb	$t3,0($t2)	# t3 = the actual bit we want
		beqz	$t3,printDot	# if = to 0 print dot
		addi	$t2,$t2,1	# check the next spot
		bltz	$t3,printX	# branch if less than 0
		bgtz	$t3,printO	# branch if greater than 0
		b	loop		# loop
printDot:
		lb	$a0,DOT
		syscall	$print_char
printX:
		lb	$a0,X
		syscall	$print_char
printO:
		lb	$a0,O
		syscall	$print_char

4:		addi	$t1,$t1,1	#next position
		div	$t1,$t6		#check if its the end of the row
		mfhi	$t5		#if zero its the end of a row
		bnez	$t5,5f		#other wise not
		lb	$a0,CR		#print CR if its the end of the row
		syscall	$print_char

5:		blt	$t1,9,loop
		jr	$ra

main:
		jal	printBoard	#return from function call
		syscall	$exit