# Macro : print_str
# Usage: print_str(<address of the string>)
.macro print_str($arg)
li	$v0, 4     # System call code for print_str  
la	$a0, $arg   # Address of the string to print
syscall            # Print the string        
.end_macro


# Macro : swap
# Usage : swap(<first element to swtich>,<second element to switch>)
.macro swap($index1,$index2,$temp)
add $temp,$zero,$index1
li $index1, 0
add $index1,$zero,$index2
li $index2, 0
add $index2,$zero,$temp 
.end_macro


# Macro: read_int
# Usage: read_int(<location of the placed value>)
.macro read_int($arg)
li $v0,5
syscall
move $arg,$v0
.end_macro


# Macro: print_int
# Usage:
.macro print_int($arg)
li $v0,1
move $a0,$arg
syscall
.end_macro


# Macro: push
# Usage: push (<reg>)
.macro push($reg)
sw	$reg, 0x0($sp)	# M[$sp] = R[reg]
addi    $sp, $sp, -4	# R[sp] = R[sp] - 4
.end_macro
	
	
# Macro: pop
# Usage: pop (<reg>)
.macro pop($reg)
addi    $sp, $sp, +4	# R[sp] = R[sp] + 4
lw	$reg, 0x0($sp)	# M[$sp] = R[reg]
.end_macro


# Macro : exit
 # Usage: exit
.macro exit
li 	$v0, 10 
syscall
.end_macro
