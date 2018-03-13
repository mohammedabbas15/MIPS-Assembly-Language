		.data
currentState:	.asciiz	"This is the current state of the GameBoard:\n"
playerOne:	.asciiz	"Player One won\n"
playerTwo:	.asciiz	"Player Two won\n"
playerNone:	.asciiz	"No winners found\n"
CR:		.byte	'\n
SPACE:		.byte	0x20
O:		.byte	'o
X:		.byte	'x
DOT		.byte	'.
#########################################################
# enable only one at a time to test your code
# it should detect the win for the designated player
#########################################################
#gameBoard:	.byte		0,0,0,0,0,0,0,0,0	# no winner
gameBoard:	.byte		1,1,1,0,0,0,0,0,0	# player one wins - by row 0
#gameBoard:	.byte		0,0,0,-1,-1,-1,0,0,0	# player two wins - by row 1
#gameBoard:	.byte		0,0,0,0,0,0,-1,-1,-1	# player two wins - by row 2
#gameBoard:	.byte		1,0,0,1,0,0,1,0,0	# player one wins - by col 0
#gameBoard:	.byte		0,1,0,0,1,0,0,1,0	# player one wins - by col 1
#gameBoard:	.byte		0,0,-1,0,0,-1,0,0,-1	# player two wins - by col 2
#gameBoard:	.byte		1,0,0,0,1,0,0,0,1	# player one wins - by diag 0
#gameBoard:	.byte		0,0,-1,0,-1,0,-1,0,0	# player two wins - by diag 1
		
		.code
		.globl	main

##########################################################################
# CheckTriplet
#			Check the gameboard positions matching the triplet passed in
#			to determine either player has won that specific triplet.
#
# Input:
#			$a0 : first position to check on gameboard
#			$a1 : second position to check on gameboard
#			$a2 : third position to check on gameboard
#
# Output:
#			$v0 : 0 	= no winner found
#			$v0 : 1 	= player one won
#			$v0 : -1 	= player two won
#			AS WELL AS an appropriate message if player one or player two has won
#
##########################################################################
CheckTriplet:
	add	$t3,$a1,$a2
	move	$t4,$a0
	add	$t5,$t3,$t4
	beq	$t5,0,noWin
	beq	$t5,3,done	
	beq	$t5,-3,done	
	b	done
noWin:
	la	$a3,playerNone
	syscall	$print_string
	jr	$ra
oneWin:
	la	$a3,playerOne
	syscall	$print_string
	jr	$ra
twoWin:		
	la	$a3,playerTwo
	syscall	$print_string
	jr	$ra
done:
	jr	$ra

CheckForWin:
	addi	$sp,$sp,-4		# make room on the stack for our variables
	sw	$ra,0($sp) 		# save our return address

	la	$a0,gameBoard		#load address of gameBoard
	li	$t0,0x00		#assign the register to 0
	add	$a0,$a0,$t0		#make this the first spot in the array
	la	$a1,gameBoard		#loading again
	li	$t1,0x01		#assign the second spot
	add	$a1,$a1,$t1		#make this the second spot in the array
	la	$a2,gameBoard		#and for the third
	li	$t2,0x02		#assign the third register
	add	$a2,$a2,$t2		#make this the third spot in the array
	b	CheckTriplet
	
	la	$a0,gameBoard		#load address of gameBoard
	li	$t0,0x00		#assign the register to 0
	add	$a0,$a0,$t0		#make this the first spot in the array
	la	$a1,gameBoard		#loading again
	li	$t1,0x03		#assign the second spot
	add	$a1,$a1,$t1		#make this the second spot in the array
	la	$a2,gameBoard		#and for the third
	li	$t2,0x06		#assign the third register
	add	$a2,$a2,$t2		#make this the third spot in the array
	b	CheckTriplet

	la	$a0,gameBoard		#load address of gameBoard
	li	$t0,0x00		#assign the register to 0
	add	$a0,$a0,$t0		#make this the first spot in the array
	la	$a1,gameBoard		#loading again
	li	$t1,0x04		#assign the second spot
	add	$a1,$a1,$t1		#make this the second spot in the array
	la	$a2,gameBoard		#and for the third
	li	$t2,0x08		#assign the third register
	add	$a2,$a2,$t2		#make this the third spot in the array
	b	CheckTriplet

	la	$a0,gameBoard		#load address of gameBoard
	li	$t0,0x01		#assign the register to 0
	add	$a0,$a0,$t0		#make this the first spot in the array
	la	$a1,gameBoard		#loading again
	li	$t1,0x04		#assign the second spot
	add	$a1,$a1,$t1		#make this the second spot in the array
	la	$a2,gameBoard		#and for the third
	li	$t2,0x07		#assign the third register
	add	$a2,$a2,$t2		#make this the third spot in the array
	b	CheckTriplet

	la	$a0,gameBoard		#load address of gameBoard
	li	$t0,0x02		#assign the register to 0
	add	$a0,$a0,$t0		#make this the first spot in the array
	la	$a1,gameBoard		#loading again
	li	$t1,0x04		#assign the second spot
	add	$a1,$a1,$t1		#make this the second spot in the array
	la	$a2,gameBoard		#and for the third
	li	$t2,0x06		#assign the third register
	add	$a2,$a2,$t2		#make this the third spot in the array
	b	CheckTriplet

	la	$a0,gameBoard		#load address of gameBoard
	li	$t0,0x02		#assign the register to 0
	add	$a0,$a0,$t0		#make this the first spot in the array
	la	$a1,gameBoard		#loading again
	li	$t1,0x05		#assign the second spot
	add	$a1,$a1,$t1		#make this the second spot in the array
	la	$a2,gameBoard		#and for the third
	li	$t2,0x08		#assign the third register
	add	$a2,$a2,$t2		#make this the third spot in the array
	b	CheckTriplet

	la	$a0,gameBoard		#load address of gameBoard
	li	$t0,0x03		#assign the register to 0
	add	$a0,$a0,$t0		#make this the first spot in the array
	la	$a1,gameBoard		#loading again
	li	$t1,0x04		#assign the second spot
	add	$a1,$a1,$t1		#make this the second spot in the array
	la	$a2,gameBoard		#and for the third
	li	$t2,0x05		#assign the third register
	add	$a2,$a2,$t2		#make this the third spot in the array
	b	CheckTriplet
	
	la	$a0,gameBoard		#load address of gameBoard
	li	$t0,0x06		#assign the register to 0
	add	$a0,$a0,$t0		#make this the first spot in the array
	la	$a1,gameBoard		#loading again
	li	$t1,0x07		#assign the second spot
	add	$a1,$a1,$t1		#make this the second spot in the array
	la	$a2,gameBoard		#and for the third
	li	$t2,0x08		#assign the third register
	add	$a2,$a2,$t2		#make this the third spot in the array
	b	CheckTriplet
	b	doneCFW
doneCFW:	
	lw	$ra,0($sp) 		# restore our return address
	addi	$sp,$sp,4		# free the room we have taken on the stack
	jr	$ra			# return from function
		
##########################################################################
# PRINTBOARD 
##########################################################################

PrintBoard:
	la	$a0,currentState
	syscall	$print_string
	la	$t0,gameBoard
	li	$t6,0x03
	li	$t1,0x00				
1:	addu	$t3,$t0,$t1
	lb	$t4,0($t3)
	bltz	$t4,3f
	bgtz	$t4,2f
	lb	$a0,DOT
	syscall	$print_char
	b	4f
2:	lb	$a0,X
	syscall	$print_char
	b	4f
3:	lb	$a0,O
	syscall	$print_char
4:	addi	$t1,$t1,1	# next position
	div	$t1,$t6		# check if it's the end of a row
	mfhi	$t5		# if zero, it is the end of a row
	bnez	$t5,5f		# otherwise, not
	lb	$a0,CR		# print a CR if it's the end of a row
	syscall	$print_char
5:	blt	$t1,9,1b
	jr	$ra


##########################################################################
# MAIN
##########################################################################

main:
	jal	PrintBoard
	jal	CheckForWin
	bnez	$v0,finished
	la	$a0,playerNone		# if no winners found, for now, just say so and exit
	syscall	$print_string

finished:
	syscall	$exit