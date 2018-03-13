#	.data
#A:	.byte	10
#B:	.byte	20
#C:	.byte	0
#sumMsg:	.asciiz	"A + B = "
#	.text
#main:	lb	$t0,A
#	lb	$t1,B
#	add	$t2,$t0,$t1
#	sb	$t2,C
#	la	$a0,sumMsg
#	syscall	$print_string
#	move	$a0,$t2
#	syscall	$print_int
#	syscall	$exit
	.data
label:	.asciiz	"d"	
label2:	.asciiz	"w"	
	.text
	la	$a0,label
	syscall	$print_string
	la	$a0,label2
	syscall	$print_string
