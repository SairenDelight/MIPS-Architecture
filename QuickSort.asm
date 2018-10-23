.include "macros.asm"
.data
original: .asciiz "The unsorted array: "
charNL: .asciiz "\n"
finalResult: .asciiz "The sorted array: "
charSP: .asciiz " "
list: .word 3 5 2 1 4 3 4 2 2 2	# This is the hard-coded array
.text                                                                                                                                                                                                                                                                                                                                                                                                                                                  
.globl main

main:
	print_str(original)
	push($ra)
	jal printArray
	pop($ra)
	print_str(charNL)
	
	add $s0,$zero,$zero	# Initialize the startIndex
	addi $s1,$zero, 9	# Initialize the endIndex, this must be modified 
	push($ra)
	jal partition
	pop($ra)
	
	print_str(finalResult)
	push($ra)
	jal printArray
	pop($ra)
	j Exit	
	
# t0 is the load address of the array
# t1 is the rangeIndex
# t2 is the midPointer
# t3 is the currentElement
# t4 is the index
# t5 is the midPointer-1
# t6 is the midPointer+1
# t7 is the array[midPointer]

# s0 is the startIndex
# s1 is the endIndex 
# s2 is the endElement

partition:
	la $t0, list	# Loads the base address
	li $t1,0
	li $t2,0
	li $t3,0
	li $t4,0
	li $t5,0
	li $t6,0
	li $t7,0
	li $s2,0
	sub $t1,$s1,$s0	# rangeIndex = endIndex - startIndex
	addi $a1,$zero,1
	bge $t1, $a1,continue
	jr $ra
	continue:
	add $t2,$zero,$s0 	# initializing midPointer with the startIndex
	
	sll $a0,$s1,2	# Should multiply endIndex by 4 to get address
	add $t0,$t0,$a0	# This should get add the previous product to get the address of array[endIndex]
	lw $s2,($t0)	# This should load the value at endElement
	la $t0,list	# load back to base address of array
	add $t4,$zero,$s0	# int index = startIndex
	
	loopInPartition:
		sll $a0,$t4,2		# multiply index by 4 to get address of array
		add $t0,$t0,$a0		# add prev product to get address of array[index]
		lw $t3,($t0)	# This should load the value at array[index]/currentElement
		la $t0,list	# Load back to base
		
		bge $t4,$s1,switchPivot	# for(index < endIndex)
		bge $t3,$s2,increment	# currentElement < endElement
		sll $a0,$t2,2		# multiply midPointer by 4 to get address of array
		add $t0,$t0,$a0
		lw $t7,($t0)	# This should load the value at array[midPointer]
		la $t0, list	# Load back to base
		
		swap:
			sll $a0,$t4,2		
			add $t0,$t0,$a0
			sw $t7,($t0)	# array[index] = array[midPointer]
			la $t0,list	# Load back to base
		
			sll $a0,$t2,2	# multiply midPointer by 4 to get address of array
			add $t0,$t0,$a0	
			sw $t3,($t0)	# store array[midPointer] at array[index]
			la $t0,list	# Load back to base
		addi $t2,$t2,1	# add to midPointer
		increment:
		add $t4,$t4,1		# index++
		j loopInPartition
	switchPivot:
		la $t0,list
		sll $a0,$t2,2	# multiply midPointer by 4 to get address of array
		add $t0,$t0,$a0
		lw $t7,($t0)	# This should load the RECENT value at array[midPointer]
		sw $s2,($t0)	# array[midPointer] = array[endElement]
		
		la $t0,list
		sll $a0,$s1,2	# multiply endIndex by 4 to get address of array
		add $t0,$t0,$a0
		sw $t7,($t0)	# array[endElement] = array[midPointer]
		push($ra)
		jal printArray
		pop($ra)
		print_str(charNL)
	left_partition:

		push($s0)
		push($t2)
		push($s1)
		addi $s0,$zero,0	# the new startIndex
		add $t5, $t2,-1
		add $s1,$zero,$t5	# the new endIndex = midPointer - 1
		push($ra)
		jal partition
		pop($ra)
		pop($s1)
		pop($t2)
		pop($s0)
		
	
	right_partition:	
		push($s0)
		push($t2)
		push($s1)
		addi $t6, $t2,1
		add $s0,$zero,$t6	# the new startIndex = midPointer + 1
		add $s1,$zero,$s1	# endIndex
		push($ra)
		jal partition
		pop($ra)
		pop($s1)
		pop($t2)
		pop($s0)
	
	jr $ra	
	
	
	
printArray:
	la $t0,list 	# Stores the base address of list into t0
	add $s3, $zero,$zero	# Initializing the counter for the loop
	li $s4,10	# This must be modified to total amount of elements in array!
	add $s5, $zero, $zero	# Initializing the register to put the value from the address
	
	printLoop:	bge $s3, $s4, endLoop
			lw $s5, ($t0)	# this loads the value from the address into the register
			print_int($s5)   # This prints the integer
			print_str(charSP)	# This prints the space
			addi $t0, $t0,4		# This adds 4 to the address to obtain the next value
			addi $s3,$s3,1		# This adds to the counter
			j printLoop
	endLoop:	jr $ra
Exit:	exit
