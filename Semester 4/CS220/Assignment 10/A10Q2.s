  		.data
	str1: .asciiz "Enter n: \n"
	str2: .asciiz "Input the array\n"
	msg1: .asciiz "Final sum: "

	.text
	.globl main

main:
	li $v0, 4
	la $a0, str1
	syscall

	li $v0, 5
	syscall

	add $t0, $v0, $0

	sub.s $f1, $f1, $f1
	add $t1, $0, $0

	li $v0, 4
	la $a0, str2
	syscall

part1:
	li $v0, 6
	syscall
	andi $t2, $t1, 1
	beq $t2, $0, add_part
	sub.s $f1, $f1, $f0
	j part2

add_part:
	add.s $f1, $f1, $f0

part2:
	addi $t1, $t1, 1
	bne $t0, $t1, part1

	li $v0, 4
	la $a0, msg1
	syscall

	li $v0, 2
	mov.s $f12, $f1
	syscall
	jr $ra