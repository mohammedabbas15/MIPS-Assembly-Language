		.data
CR		=	'\n
E		=	'e
SPACE		=	0x20	
BLOCKCHAR	=	0xdb
NAMESIZE	=	20
NUMBLOCKS	=	1
NUMCOLUMNS	=	79
NUMROWS		=	25
NUMITERATIONS	=	100
WIDTH		=	79
HEIGHT		=	25
newX		.word	0
newY		.word	0
windowHandle	.word	0
userNamePtr	.word	0
prompt		.asciiz "Enter first name (max 20 char):"
thankYou	.asciiz "Thank you for playing... "

		.data
keyboard:	.struct	0xa0000000	#start from hardware base address
flags:		.byte	0
mask:		.byte	0
		.half	0
keypress: 	.byte	0,0,0
presscon: 	.byte	0
keydown:	.half	0
shiftdown:	.byte	0
downcon:	.byte	0
keyup:		.half	0
upshift:	.byte	0
upcon:		.byte	0
		.data
mouse:		.struct	0xa0000018
flags:		.byte	0
mask:		.byte	0
		.half	0
		.word	0
move:		.word	0,0
down:		.word	0,0
up:		.word	0,0
wheel:		.word	0,0
wheeldown:	.word	0,0
wheelup:	.word	0,0
		.data
		
		.code
		.globl	main

##########################################################################
# DELAY
# input: $a3 is the number of times to iterate without doing anythin
##########################################################################

Delay:
	b	2f			# branch to label 2 (f = forward from here)
1:					# for ( $a1; $a1>0; --$a1)
	nop				# do nothing; ie. delay
	addi	$a3,$a3,-1		# decrement the for loop counter
2:	
	bgtz	$a3,1b			# branch greater than to label 1 (b = backward from here)
	jr	$ra			# return from function call

############################################################################
# InitScreen
############################################################################

InitScreen:
	li	$a0,NUMROWS
	li	$a1,NUMCOLUMNS
	li	$a2,1
	syscall	$open_cons
	sw	$v0,windowHandle
	move	$a0,$v0
	syscall	$select_cons
	jr	$ra

############################################################################
# InitKeyInterrupts
############################################################################

InitKeyInterrupts:
	la	$a0,keyboard.mask
	addi	$a1,$0,1
	addi	$a2,$0,0x0F
	syscall	$IO_write
	jr	$ra

############################################################################
# ClearScreen
############################################################################

ClearScreen:
	li	$t0,NUMROWS		# max rows
	b	testRows
topRow:
	addi	$t0,$t0,-1		# one less row
	li	$t1,NUMCOLUMNS		# max columns
	b	testColumns
topCol:
	addi	$t1,$t1,-1		# one less col
	move	$a0,$t1
	move	$a1,$t0
	syscall $xy
	li	$a0,SPACE
	syscall	$print_char
testColumns:
	bnez	$t1,topCol				
testRows:
	bnez	$t0,topRow		
	jr	$ra

############################################################################
# UpdateScreen
#		No need to flash, simply clear screen to white, then place cursor
############################################################################

UpdateScreen:
	addi	$sp,$sp,-4		# make room on the stack for our variables
	sw	$ra,0($sp) 		# save our return address

	# YOUR code here  [ AREA 1 of 6 ]
	# 1) ClearScreen
	# 2) Draw a BLOCKCHAR at current X and Y

	jal	ClearScreen		# clear the screen
	lw	$a0,newX		# location of x,  	##newX is a word, you sure you want to use la?
	lw	$a1,newY		# location of y,  	##newY is a word, you sure you want to use la?
	syscall	$xy			# callin the cursor fuction
	la	$a0,BLOCKCHAR		
	syscall	$print_char		# print the character
	
	lw	$ra,0($sp) 		# save our return address
	addi	$sp,$sp,4		# make room on the stack for our variables
	jr	$ra

############################################################################
# GetKey
#	Output:	$v0 = 0 if no key was pressed
#		$v0 = ascii code of key that was pressed
############################################################################

GetKey:
	move	$v0,$zero
	la	$a0,keyboard.flags		# hardware address of keyboard flags
	addi	$a1,$0,1			# 1 byte of data
	syscall $IO_read			# read flags
	blez	$v0,1f				# branch if no keyboard flags
	la	$a0,keyboard.keypress		# hardware address of ascii data
	addi	$a1,$0,1			# 1 byte of data
	syscall	$IO_read
	la	$a0,keyboard.flags		# hardware address of keyboard flags
	addi	$a1,$0,1			# 1 byte of data
	move	$a2,$zero
	syscall $IO_write			# read flags

1:	jr	$ra

############################################################################
# Main
############################################################################

main:
	li	$s1,'w
	li	$s2,'a
	li	$s3,'s
	li	$s4,'x
	li	$s5,'z
	li	$s6,'q

	jal	InitScreen
	jal	InitKeyInterrupts
	jal	ClearScreen

	# Your code here [ AREA 2 of 6 ]
	# 1) Prompt user to enter name

	la	$a0,prompt
	syscall	$print_string		# print the opening message

	# 2) MALLOC storage for the user name

	li	$a0,NAMESIZE
	syscall	$malloc			# this gives you v0

	# 3) Read the username if you got the storage 
	
	lw	$a0,userNamePtr
	sw	$v0,userNamePtr
	li	$a1,NAMESIZE
	move	$a0,$v0
	syscall	$read_string

		
# you need to save the output from v0 into userNamePtr = a0
# all you have to do is set it up correctly for syscall $read_string

	# 4) Update the screen
	
	jal	UpdateScreen		# calling update screen function

loop:
	# More of your code here [ AREA 3 of 6 ]
	# 5) Call GetKey
	# if none pressed, branch to next

	jal	GetKey
	beqz	$v0,next

	# 6) If key pressed
	# COMPLETE THE SWITCH
	# switch (on the pressed key)
	
	move	$s0,$v0			# move key to do the check
	bge	$s0,0x61,switch		# likely to be lower case character
	addi	$s0,$s0,0x20		# presume it needs to be converted to lower case

switch:
	beq	$s0,$s1,caseUp		
	beq	$s0,$s2,caseLeft
	beq	$s0,$s3,caseRight
	beq	$s0,$s4,caseDownSC
	beq	$s0,$s5,caseDownFC
	beq	$s0,$s6,caseQuit

	# v--- Your switch cases here to implement all
	# <- YOUR CODE FOR caseLeft 
caseLeft:				
	lw	$t0,newX
	beqz	$t0,next
	addi	$v0,$v0,-1
	sw	$t0,newX
	b	switchBreak
	# <- YOUR CODE FOR caseRight 
caseRight:
	lw	$t0,newX
	beqz	$t0,next
	addi	$v0,$v0,1
	sw	$t0,newX
	b	switchBreak
	# <- YOUR CODE FOR caseDown (first character)
caseDownFC:
	lw	$t0,newY
	beqz	$t0,next
	addi	$v0,$v0,1
	sw	$t0,newY
	b	switchBreak
	# <- YOUR CODE FOR caseDown (second character)
caseDownSC:
	lw	$t0,newY
	beqz	$t0,next
	addi	$t0,$t0,1
	sw	$t0,newY
	b	switchBreak
	# <- YOUR CODE FOR caseUp
caseUp:
	lw	$t0,newY
	beqz	$t0,next
	addi	$t0,$t0,-1
	sw	$t0,newY
	b	switchBreak	
	# <- YOUR CODE FOR caseQuit
caseQuit:
	b	close	
default:
# NONE NEEDED FOR THIS IMPLEMENTATION
switchBreak:
	jal	UpdateScreen	# END OF SWITCH	

# ^--- Your switch cases
next:
	li	$a3,0x00FFFFFF
	jal	Delay
	j	loop

	# Lastly...More of your code here [ AREA 6 of 6 ]
	# 7) Clear the screen

	jal	ClearScreen

	# 8) Print the thank you prompt (not name)

	la	$a0,thankYou
	syscall	$print_string

	# 9) Check namePtr is NOT null

	li	$t0,0x00
	lw	$a0,userNamePtr
	beq	$a0,$t0,close		# if it is null, branch to close		

	# 10) otherwise, print the name

	lw	$a0,userNamePtr
	syscall	$print_string

	# 11) and free the malloc'ed storage
	
	lw	$a0,userNamePtr
	syscall	$free
close:
	lw	$a0,windowHandle
	syscall	$close_cons
	syscall	$exit