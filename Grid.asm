		.data
CR		=	'\n
SPACE		=	0x20	
BLOCKCHAR	=	0xdb
NUMBLOCKS	=	25
NUMCOLUMNS	=	79
NUMROWS		=	24
NUMITERATIONS	=	100
WIDTH		=	10
HEIGHT		=	10
windowHandle	.word	0
lastCharacter	.byte	0

		.data			# start of structure
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
		.data			# end of structure

		.code
		.globl	main

##########################################################################
# DELAY
# input: $a2 is the number of times to iterate without doing anythin
##########################################################################

Delay:
	b	2f		# branch to label 2 (f = forward from here)
1:				# for ( $a1; $a1>0; --$a1)
	nop			# do nothing; ie. delay
	addi	$a2,$a2,-1	# decrement the for loop counter
2:	
	bgtz	$a2,1b		# branch greater than to label 1 (b = backward from here)
	jr	$ra		# return from function call

############################################################################
# InitScreen
############################################################################

InitScreen:		li		$a0,NUMROWS
			li		$a1,NUMCOLUMNS
			li		$a2,1
			syscall		$open_cons
			sw		$v0,windowHandle
			move		$a0,$v0
			syscall		$select_cons
			jr		$ra


############################################################################
# InitMouseInterrupts
############################################################################

InitMouseInterrupts:
			la		$a0,mouse.mask
			addi		$a1,$0,1
			addi		$a2,$0,0x0F
			syscall		$IO_write
			jr		$ra

############################################################################
# ClearScreen
############################################################################

ClearScreen:		li		$t0,NUMROWS		# max rows
			b		testRows
topRow:			addi		$t0,$t0,-1		# one less row
			li		$t1,NUMCOLUMNS		# max columns
			b		testColumns
topCol:			addi		$t1,$t1,-1		# one less col
			move		$a0,$t1
			move		$a1,$t0
			syscall 	$xy
			li		$a0,SPACE
			syscall		$print_char
testColumns: 		bnez		$t1,topCol				
testRows:		bnez		$t0,topRow		
					jr			$ra

############################################################################
# DrawHorizontalLine
#	Input: $a0 = row number
############################################################################

DrawHorizontalLine:
			addi		$sp,$sp,-16		# make room on the stack for our variables
			sw		$ra,12($sp) 				
			sw		$s0,8($sp) 				
			sw		$s1,4($sp) 			
			sw		$s2,0($sp) 				

			move		$s0,$a0			# hold onto the row parameter passed into this function
			li		$s1,NUMCOLUMNS

			move		$s2,$zero		# for ( $s2=0; $s2<NUMCOLUMNS; $s2++ )
			b		4f		
3:			move		$a0,$s2			# current column
			move		$a1,$s0			# user's specified row
			syscall 	$xy
			li 		$a0,BLOCKCHAR
			syscall		$print_char
			addi		$s2,$s2,1		# next column
4:			blt		$s2,$s1,3b		# loop if not done

			lw		$s2,0($sp)
			lw		$s1,4($sp)
			lw		$s0,8($sp)
			lw		$ra,12($sp) 		# restore our return address
			addi		$sp,$sp,16		# free room on the stack for our variables
			jr		$ra

############################################################################
# DrawVerticalLine
#	Input: $a0 = column number
############################################################################

DrawVerticalLine:
			addi		$sp,$sp,-16		# make room on the stack for our variables
			sw		$ra,12($sp) 				
			sw		$s0,8($sp) 				
			sw		$s1,4($sp) 			
			sw		$s2,0($sp) 				

			move		$s0,$a0			# hold onto the row parameter passed into this function
			li		$s1,NUMROWS

			move		$s2,$zero		# for ( $s2=0; $s2<NUMCOLUMNS; $s2++ )
			b		4f		
3:			move		$a0,$s0			# current column
			move		$a1,$s2			# user's specified row
			syscall 	$xy
			li 		$a0,BLOCKCHAR
			syscall		$print_char
			addi		$s2,$s2,1		# next column
4:			blt		$s2,$s1,3b		# loop if not done

			lw		$s2,0($sp)
			lw		$s1,4($sp)
			lw		$s0,8($sp)
			lw		$ra,12($sp) 		# restore our return address
			addi		$sp,$sp,16		# free room on the stack for our variables
			jr		$ra
			
############################################################################
# DrawGrid
############################################################################

DrawGrid:	
			addi		$sp,$sp,-4		# make room on the stack for our variables
			sw		$ra,0($sp) 		# save our return address

			li		$s0,3

			li		$t0,NUMROWS		# max rows
			divu		$t0,$s0			# one third rows
			mflo		$s1
			move		$s2,$s1			# two thirds rows
			add		$s2,$s2,$s1

			move		$a0,$s1
			jal		DrawHorizontalLine

			move		$a0,$s2
			jal		DrawHorizontalLine

			li		$t0,NUMCOLUMNS		# max rows
			divu		$t0,$s0			# one third rows
			mflo		$s1
			move		$s2,$s1			# two thirds rows
			add		$s2,$s2,$s1

			move		$a0,$s1
			jal		DrawVerticalLine

			move		$a0,$s2
			jal		DrawVerticalLine


					# YOUR CODE HERE TO CALL DrawVerticalLine
					# FOR BOTH THE 1/3 POSITION AND THE 2/3 POSITION
					# COMPARABLE TO WHAT WAS DONE FOR DrawHorizonalLine

			lw		$ra,0($sp) 		# restore our return address
			addi		$sp,$sp,4		# free room on the stack for our variables
	
			jr		$ra


############################################################################
# GetMouseLocation
#
# Output:
#		$v0 : x position of mouse
#		$v1 : y position of mouse
#
############################################################################

GetMouseLocation:
			la		$a0,mouse.move		# hardware address of keyboard code
			addi		$a1,$zero,4		# 4 bytes of data
			syscall		$IO_read
			move		$v1,$v0			# copy the response
			andi		$v0,$v0,0x0000FFFF	# want the lower half word
			srl		$v1,$v1,16		# want the high half word
			jr		$ra


############################################################################
# CheckMouseDown
#
# Output:
#		$v0 : 0 if mouse NOT down, 1 if down
#
############################################################################

CheckMouseDown:
			li		$t0,0x02
			la		$a0,mouse.flags		# hardware address of mouse control
			addi		$a1,$zero,4		# 1 byte of data
			syscall		$IO_read		# read the flags
			and		$v0,$v0,$t0		# check bit 2 of the flags (mousedown)
			beqz		$v0,doneMD
			not		$t0,$t0
			la		$a0,mouse.flags		# hardware address of mouse control
			addi		$a1,$zero,4		# 1 byte of data
			and		$a2,$v0,$t0		# check bit 2 of the flags (mousedown)
			syscall		$IO_write
doneMD:			jr		$ra			# we can simply return it as our function result


############################################################################
# FlashCursor
#
# Input:	$v0 : center x
#		$v1 : center y
#
# COPY YOUR IMPROVED FLASHING CURSOR CODE HERE
# NOTE THAT THE CURSOR MUST NOT BE THE VERSION
# THAT ERASES. IT MUST BE THE IMPROVED ONE.
#
############################################################################
FlashCursor:
	addi	$sp,$sp,-20		# make room on the stack for our variables 
	sw	$ra,16($sp) 		# save our return address
	sw	$s0,12($sp) 		# save our original $s0
	sw	$s1,8($sp) 		# save our original $s1
	sw	$s2,4($sp) 		# save our original $s2
	sw	$s3,0($sp) 		# save our original $s3


	move	$s3,$v0
	move	$s2,$v1


	move	$a0,$v0			# take arguments and store into v0...
	move	$a1,$v1			# ...same for v1
	syscall $xy			# need two arguments to pass through to xy func
	move	$s0,$v0			# the char into s register to save for later	
	li	$a0,BLOCKCHAR		# print blocks
	syscall	$print_char


	li	$a2,0x0066000		# Delay
	jal 	Delay
	move	$a0,$s3
	move	$a1,$s2
	syscall $xy
	move	$a0,$s0
	syscall	$print_char


	lw	$s3,0($sp) 		# restore our original $a0
	lw	$s2,4($sp) 		# restore our original $a0
	lw	$s1,8($sp) 		# restore our original $a0
	lw	$s0,12($sp) 		# restore our original $a0
	lw	$ra,16($sp) 		# restore our return address
	addi	$sp,$sp,20		# free the room we have taken on the stack


	jr	$ra			

############################################################################
# Main
############################################################################

main:			jal		InitScreen
			jal		InitMouseInterrupts		
			jal		ClearScreen
			jal		DrawGrid

update:
			jal		GetMouseLocation
			jal		FlashCursor
			jal		CheckMouseDown
			li		$a2,0x00700000		# enjoy the screen
			jal		Delay			# invoke delay function call
			beqz		$v0,update		# repeat until a mouse click occurs

finished:		lw		$a0,windowHandle
			syscall		$close_cons
			syscall 	$exit