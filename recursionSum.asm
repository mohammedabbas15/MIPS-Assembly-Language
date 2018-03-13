	.data
first:	.asciiz	"\n\nPlease enter an integer:"
sumMsg:	.asciiz	"\nThe sum from 0 to "
isMsg:	.asciiz	" is: "
	.code
	.globl	main

##################################################################################################
# Sum Recursion
#	Input:	if $a0 = 0 set $v0 to zero
#	otherwise, subract 1, recursively call Sum and then add $a0 to $v0
#
#
#	Output:	Return in $v0 the sum of all $a0 values that are called in the recursion
# Note:
#	Recursion is NOT the same as implementing a for loop or a dowhile loop
# 	You will get ZERO points for implementing a loop. The implementation MUST be a recursion.
##################################################################################################

sum:	addi	$sp,$sp,-8		#make space for 2 words
	sw	$ra,4($sp)		#store return address in stack
	sw	$s1,0($sp)		#store local variable in stack

	li	$v0,0			#store a 0 in local variable
	beq	$a0,$zero,done		#if both zero then done

	move	$s1,$a0			#move input into local variable

	addi	$a0,$a0,-1		#decrementer
	jal	sum			#recursion
	add	$v0,$s1,$v0		#add
done:
	lw	$s1,0($sp)		#reverse the stack
	lw	$ra,4($sp)
	addi	$sp,$sp,8
	jr	$ra

###################################################################
# Main
###################################################################	
	
main:
	la	$a0,first
	syscall	$print_string

	syscall	$read_int	# get number from user
	move	$s0,$v0		# save the user's integer for later
	move	$a0,$v0		# pass the user's integer as a parameter
	jal	sum		# recursively sum

	la	$a0,sumMsg	# print a message to the user letting them know the sum is
	syscall	$print_string	
	move	$a0,$s0	
	syscall	$print_int

	la	$a0,isMsg
	syscall	$print_string	
	move	$a0,$v0		# print the sum our recursive function determined
	syscall	$print_int

	syscall	$exit
