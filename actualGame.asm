		.data
currentState:	.asciiz	"This is the current state of the GameBoard:\n"
playerOne:	.asciiz	"Player One won\n"
playerTwo:	.asciiz	"Computer won\n"
playerNone:	.asciiz	"No winners found\n"
enterMove:	.asciiz	"\nEnter a board position (0-8) to make move:\n"
invalidMove:	.asciiz	"\nInvalid move - try again.\n"
computerMove:	.asciiz	"\nThe computer will now move to position: "
askWhomToPlay:	.asciiz	"\nEnter 0 if you want to play against the computer. Enter 1 otherwise.\n\n"
CR:		.byte	'\n
SPACE:		.byte	0x20
O:		.byte	'o
X:		.byte	'x
DOT		.byte	'.
player:		.byte	0x01
gameBoard:	.byte	0,0,0,0,0,0,0,0,0	# fresh clean empty gameboard
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
				
1:
	addu	$t3,$t0,$t1
	lb	$t4,0($t3)
	bltz	$t4,3f
	bgtz	$t4,2f
	lb	$a0,DOT
	syscall	$print_char
	b	4f
2:
	lb	$a0,X
	syscall	$print_char
	b	4f
3:
	lb	$a0,O
	syscall	$print_char
4:
	addi	$t1,$t1,1	# next position
	div	$t1,$t6		# check if it's the end of a row
	mfhi	$t5		# if zero, it is the end of a row
	bnez	$t5,5f		# otherwise, not
	lb	$a0,CR		# print a CR if it's the end of a row
	syscall	$print_char
5:
	blt	$t1,9,1b
	jr	$ra		# return from function call


##########################################################################
# RequestMove 
#
# ToDo:
#		return $v0 = player's choice to move to that is valid
#
##########################################################################

RequestMove:
	la	$t0,gameBoard
	li	$t1,0x00		# reset to starting index on game board
	la	$a0,enterMove		# prompt player
	syscall	$print_string
	syscall	$read_int		# read their choice (in $v0)
	bgt	$v0,8,bad		# be sure it is less than 9
check:
	move	$t1,$v0				
	addu	$t3,$t0,$t1		# calculate the address of the current position
	lb	$t4,0($t3)		# load the value at the current position
	beqz	$t4,done		# valid move - position not used
bad:
	la	$a0,invalidMove		# invalid move
	syscall	$print_string
	b	RequestMove		# try again

done:
	jr	$ra			# return from function call


##########################################################################
# ComputerMove 
#
#	Note: The simplest implementation is to randomly guess a number between 0 and 8
#	return it in $v0 if available. Otherwise, guess again.
#
#	The downside of the above implementation is that the random number tends to
#	guess the same values - which means it can take up to a minute to have it
#	guess something really new. During that time it is repeatedly guessing the
#	same invalid choices and looping.
#
#	For an additional 5 extra credit points beyond the simple random implementation
#	described above, use a hybrid approach where the initial guess is random; but
#	if invalid, iterate until you find a valid position.
#
# ToDo:
#	return $v0 = computer's choice to move to that is valid
#
##########################################################################

ComputerMove:
			# ENTER YOUR IMPLEMENTATION HERE


				
##########################################################################
# CheckForMoreMoves 
#
# ToDo:
#		return $v0 = 0 if no more moves left on gameBoard
#		return $v0 = 1 if yes there are more moves left on gameBoard
#
##########################################################################

CheckForMoreMoves:	
	la	$t0,gameBoard
	li	$t1,0x00	# starting index on game board
	li	$v0,0x01	# default is we have more moves	
check:	
	addu	$t3,$t0,$t1	# calculate the address of the current position
	lb	$t4,0($t3)	# load the value at the current position
	beqz	$t4,done
	addi	$t1,$t1,1	# next index
	blt	$t1,9,check
	li	$v0,0x00	# clear our response to say no more moves

done:
	jr	$ra		# return from function call

##########################################################################
# TOGGLEPLAYER
##########################################################################

TogglePlayer:
	lb	$t0,player				
	sub	$t0,$zero,$t0
	sb	$t0,player
	jr	$ra		# return from function call


##########################################################################
# MAIN
##########################################################################

main:
	# Ask the user whom to play
	# get their answer
	# Print the board	

	# decide whether to ask player or computer for the next move
	# if the user did not want to play the computer, always RequestMove
	# otherwise, RequestMove if player is 1. ComputerMove if player is 2
	# Either request the move from Player
	# OR have computer choose

	# apply the move to the board & toggle player
	# check for win
	# check for more moves
	# loop until win or draw			
	# if no winners found, say so and exit
	# print the board one last time before exiting
	# exit