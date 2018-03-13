###################################################################			
# Program Name: Sum of Integers			
# Programmer: YOUR NAME			
# Date last modified:			
##################################################################			
# Functional Description:			
# A program to find the sum of the integers from 1 to N, where N 			
# is a value read in from the keyboard.			
##################################################################			
# Pseudocode description of algorithm:			
# main(){			
#    do {			
# 	cout << "\n Please input a value for N = ";		
#	cin >> v0;		
#	t0 = 0;		
#	if (v0 > 0){		
#	    while (v0 > 0) {		
#		t0 = t0 + v0;	
#		v0 = v0 - 1;	
#	    }		
#	    cout << " The sum of the integers from 1 to N is "    		
#		<< t0;	
#	}		
#    }while (t0 > 0);			
#    cout << "\n **** Adios Amigo - Have a good day ****";			
# }			
##################################################################			
# Register Usage:			
# v0: N,			
# t0: Sum			
##################################################################			
	.data		
Prompt:	.asciiz	"\n Please Input a value for N = "	
Result:	.asciiz	"The sum of the integers from 1 to N is"	
Bye:	.asciiz	"\n **** Adios Amigo - Have a good day****"	
	.globl 	main	
	.code		
main:			
	la 	$a0,Prompt	# load address of prompt into $a0
	syscall	$print_string	# print the prompt message
	syscall	$read_int	# reads the value of N into $v0
	li 	$t0,0	# clear register $t0 to 0
	blez 	$v0,End	# branch to end if $v0 < = 0
Loop:			
	add 	$t0,$t0,$v0 	# sum of integers in register $t0
	addi 	$v0,$v0,-1 	# summing integers in reverse order
	bnez 	$v0,Loop 	# branch to loop if $v0 is != 0
	la 	$a0,Result 	# load address of message into $a0
	syscall	$print_string	# print the string
	move 	$a0,$t0 	# move value to be printed to $a0
	syscall	$print_int	# print sum of integers
End:	bnez 	$t0,main 	# branch to main
	la 	$a0,Bye 	# load address of msg. into $a0
	syscall	$print_string	# print the string
	syscall	$exit	# return control to system
			
