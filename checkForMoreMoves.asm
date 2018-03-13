		.data
noMoreMoves:	.asciiz	"there are no more moves \n"
yesHaveMoves:	.asciiz	"yes, there are more moves \n"

######################################################
# enable each one (turning off the other) to confirm
# your codes works in both cases
######################################################
gameBoard:	.byte	-1,0,-1,0,1,0,-1,1,-1
#gameBoard:	.byte	-1,1,-1,1,-1,-1,-1,1,1

		.code
		.globl	main

checkForMoreMoves:
		la	$t0,gameBoard
		li	$t1,0x00	# starting index on the game board
		li	$v0,0x01	# default is we have more moves (this means yes)
		add	$t2,$t0,$t1	# gives the effective address of the first position
		addi	$t1,$t1,1	# check the next spot
		bnez	$t2,check	
		b	checkForMoreMoves	#loop if no more moves
check:
		beqz	$t2,yes		# if not 0 then yes
		b	done		# return to function
done:
		jr	$ra

main:
		jal	checkForMoreMoves
		bnez	$v0,yes
		la	$a0,noMoreMoves
		syscall	$print_string
		b	finish
yes:
		la	$a0,yesHaveMoves
		syscall	$print_string
finish:
		syscall	$exit