#######################################################
# When properly adjusted, will report elapsed time every 5
# seconds over a period of one minute.
#######################################################
	.data 			# Data declaration section
msg: 	.asciiz "\n Elapsed Time = "
	.code
main:
# Start of code section
	li 	$s1,0 		# Time counter
countdown:
	li 	$s0,250000 	# Adjustable Time Factor
waitloop:
	addi 	$s0,$s0,-1
	bnez 	$s0,waitloop
	addi 	$s1,$s1,5
	la 	$a0,msg
	syscall	$print_string
	move 	$a0,$s1
	syscall	$print_int 	# Print amount
	addi 	$t0,$s1,-60
	bnez 	$t0,countdown
	syscall	$exit
	
	