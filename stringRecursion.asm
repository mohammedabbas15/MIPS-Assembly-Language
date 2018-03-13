		.data
theString:	.asciiz	"Print one char at a time with SPACES
SPACE:		.asciiz	" "
#CR:		.byte	'\n
	
		.code
		.globl	main

###################################################################
# Print2CR
#				cosmetic
###################################################################

#Print2CR:	lb	$a0,CR
#		syscall	$print_char
#		lb	$a0,CR	
#		syscall	$print_char
#		
#		jr	$ra
	
##################################################################################################
# PrintForward
#
#	Input:	$a1 = address of string to print RECURSIVELY ONE CHARACTER 
#		AT A TIME FORWARD WITH A SPACE between each.
#
# 	Hint - Leverage the countdown sample code that was posted
#
#	Note that recursion is NOT the same as implementing a for loop or a dowhile loop
# 	You will get ZERO points for implementing a loop. The implementation MUST be a recursion.
#
##################################################################################################

PrintForward:
	addi	$sp,$sp,-8		# make room on the stack for our variables
	sw	$ra,4($sp) 		# save our return address
	sw	$a1,0($sp) 		# save our original $a1

	li	$v0,0x00
	beq	$a1,$v0,donePF
	add	$a1,$v0,$a1
	lb	$a1,theString
	syscall	$print_char		#print literally that character
	addi	$a1,$a1,-1		#moving to counter to the next spot

	jal	PrintForward	

	# YOUR CODE HERE										
	# NOTE THAT THE INPUT PARAMETER FOR THIS IMPLEMENTATION
	# IS PASSED IN REGISTER $A1

donePF:	
	lw	$a1,0($sp) 	# restore our original $a1
	lw	$ra,4($sp) 	# restore our return address
	addi	$sp,$sp,8	# free the room we have taken on the stack
	jr	$ra


###################################################################
# Main
###################################################################		
main:
	#jal	Print2CR		# cosmetic - just for improved UI
	la	$a1,theString		# pass the string address as a parameter to the function
	jal	PrintForward		# print it forward one char at a time without loops
	jal	Print2CR		# cosmetic - just for improved UI
	syscall	$exit
