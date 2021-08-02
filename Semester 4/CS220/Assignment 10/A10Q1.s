                .data
str1:           .asciiz "Enter the integer n : \n"
str2:           .asciiz "Enter the sorted array : \n"
str3:           .asciiz "Enter the integer k: \n"
msg1:           .asciiz "Found element at index \n"
msg2:           .asciiz "Element was not found\n"
A:            .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;

                .text
                .globl main

main:           li $v0, 4
                la $a0, str1
                syscall

                li $v0, 5
                syscall

                move $a2, $v0
                addi $v0, $0, 4
                mult $a2, $v0
                mflo $t0
                addiu $s0, $t0, 0

                la $t1, A

                li $v0, 4
                la $a0, str2
                syscall

                move $t2, $0

loop1:          li $v0, 5
                syscall

                sw $v0, 0($t1)
                addi $t1, $t1, 4
                addiu $t2, $t2, 4
                slt $v0, $t2, $t0
                bne $v0, $0, loop1

                li $v0, 4
                la $a0, str3
                syscall

                li $v0, 5
                syscall

                move $s1, $v0
                move $t0, $0
                addi $t1, $s0, -4

binarysearch:   slt $v0, $t1, $t0
                bne $v0, $0, notfound

                sra $t1, $t1, 2
                sra $t0, $t0, 2
                add $t2, $t0, $t1
                sra $t2, $t2, 1
                sll $t2, $t2, 2
                addiu $s2, $t2, 0
                sll $t1, $t1, 2
                sll $t0, $t0, 2
                la $t3, A
                add $t3, $t3, $t2

                lw $t2, 0($t3)
                beq $t2, $s1, found

                slt $v0, $t2, $s1
                bne $v0, $0, right
                beq $v0, $0, left

left:         addi $t1, $s2, -4
                j binarysearch

right:        addi $t0, $s2, 4
                j binarysearch

found:          li $v0, 4
                la $a0, msg1
                syscall

                li $v0, 1
                add $a0, $s2, $0
                sra $a0, $a0, 2
                addiu $a0, $a0, 1
                syscall

                j exit

notfound:       li $v0, 4
                la $a0, msg2
                syscall


exit:           li $v0, 10
                syscall
