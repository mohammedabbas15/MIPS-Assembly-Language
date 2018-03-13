		.data		# assmebler directive to place following lines in the data memory section
theString:	.asciiz		"This is the string"
answer:		.asciiz		"The program determined the string length is: "

		#.code		assmebler directive to place the following lines in the code memory section
		#.globl		main
		.text
main:		la		$a1,theString	# pass in the addres ofhte string we want the length of
		jal		StringLength	# this jump and link instructions sets the $ra register for func. return
		syscall		$exit		# we're done

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# StringLength
#
# input: 	$a1: contains the starting address of the string (ie. the base address)
# return: 	$v0: length of string not including the null (by convention results are returned in $v0)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
StringLength:
		# These next seven lines (plus the jr) are the heart of the solution
		#
		move		$t0,$zero	# $t0 = index (and since each char is a byte, also the offset)
calcEA:		add		$t1,$a1,$t0	# $t1 = effective address of the char we want to check
		lb		$t2,0($t1)	# $t2 = the actual character at address $t1
		beqz		$t2,done	# if it's a zero, we're done
		addi		$t0,$t0,1	# otherwise, we want to check the next character
		b		calcEA		# loop
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
done:		move		$v0,$t0		# the length does not include the \0 - matches the value of our index

		# The problem says to output the length with a suitable message
		# hence, outputting a message is required as is outputting the length
		# This could be done in main; but for the midterm this is easier to code since it's in the
		# flow of answering the question.
		#
		la		$a0,answer	# load the address of the message we want to output
		syscall		$print_string	# print that message
		move		$a0,$v0		# move (register to register) the actual length
		syscall		$print_int	# print the length
		
		jr		$ra		# this return is REQUIRED since we're a function