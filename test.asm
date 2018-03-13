		.data
first:		.asciiz		"\nPlease enter an integer:" 	#stores the embedded 0 in the acsiiz
result:		.asciiz		"\nThe result of 5 less than number is: "

		.code
main:
		la	$a0,first
		syscall	$print_string
		syscall	$read_int		#get the first intger fom the user
		move	$t0,$v0
		
		addi	$t2,$t0,-5

		la	$a0,result
		syscall	$print_string
		move	$a0,$t2
		syscall	$print_int
		syscall	$exit
