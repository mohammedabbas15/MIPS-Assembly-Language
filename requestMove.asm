		.data
enterMove:	.asciiz	"\nEnter board position (0-8) to make your move:\n"
youChose:	.asciiz	"\nYou chose: "
invalidMove:	.asciiz	"\nInvalid move - try again...\n"
CR:		.byte	'\n
gameBoard:	.byte	-1,0,-1,0,1,0,-1,1,-1	#position 1 3 5 are valid moves
		.code
		.globl	main
requestMove:	
		la	$t0,gameBoard
		li	$t1,0x00		# reset to starting index on game board
		li	$v0,0xFF		# not implemented
		la	$a0,enterMove		# prompt player
		syscall	$print_string		 
		li	$v0,4			# read their choice (in $v0)
		syscall
		blt	$v0,9,check		# be sure it is less than 9
		la	$a0,invalidMove		# invalid move
		syscall	$print_string
		b	requestMove		# loop if invalid

#######################################################################
# calculate the address belonging to the position the user entered
# load the byte of THAT position
# check that it is currently empty (allowing the user to choose it)
# valid = return the position
# INvalid = do not return and tell user to try again
#######################################################################

check:
		la	$a0,youChose
		syscall	$print_string
		move	$a0,$v0
		syscall	$print_char
		beqz	$a0,done
done:
		jr	$ra
main:
		jal	requestMove			
		la	$a0,youChose
		syscall	$print_string
		move	$a0,$v0
		syscall	$print_int
		lb	$a0,CR
		syscall	$print_char
		syscall	$exit