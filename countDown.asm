		.data
theString:	.asciiz	"Print one char at a time with SPACES"
CR:		.byte		'\n
SPACE:		.byte		0x20

		.code
		.globl		main


Print2CR:
	lb	$a0,CR			# improved UI
	syscall	$print_char
	lb	$a0,CR			# improved UI
	syscall	$print_char

	jr		$ra
	
###################################################################
# CountDown
#	Input:	if $a0 = 0 simply print it
#			otherwise, print $a0, subract 1 and recursively call CountDown
#
#	Note that recursion is NOT the same as implementing a for loop or a dowhile loop
###################################################################

CountDown:
		addi		$sp,$sp,-8		# make room on the stack for our variables
		sw		$ra,4($sp) 		# save our return address
		sw		$a0,0($sp) 		# save our original $a0

		syscall 	$print_char		# a0 already has the number we want
		beqz		$a0,doneCD		# if we're at 0, exit without recursion

		lb		$a0,SPACE		# improved UI
		syscall	$print_char

		lw		$a0,0($sp)		# copy back the $a0 (since we overwrote it printing the space
		addi		$a0,$a0,-1		# decrement a0		
		jal		CountDown		# recurse
		
doneCD:	
		lw		$a0,0($sp) 		# restore our original $a0
		lw		$ra,4($sp) 		# restore our return address
		addi		$sp,$sp,8		# free the room we have taken on the stack
		jr		$ra


###################################################################
# Main
###################################################################		
main:		
	la	$a0,theString
	jal	Print2CR		# cosmetic - just for improved UI
	jal	CountDown		# demonstrate counting down
	jal	Print2CR		# cosmetic - just for improved UI
	syscall	$exit