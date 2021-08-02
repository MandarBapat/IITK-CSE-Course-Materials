
.data
    prompt1: .asciiz "n= "
    prompt2: .asciiz ", "
    

.text
.globl main
main:
    
    li $v0, 4
    la $a0, prompt1
    syscall

    li $v0, 5
    syscall

    move $a0, $v0
    jal fib1
    move $a1, $v0
    
    end:
        li $v0, 10
        syscall

    fib1:
        addi $s0, $0, 1 # i
        add $s1, $0, $a0
        add $s1, $s1, 1
        add $t1, $0, 1
        loop: 
            slt $t0, $s0, $s1
            beq $t0, $0, end
            
            move $a0, $s0
            jal fib
            move $a1, $v0

            beq $s0, $t1, break1
            li $v0, 4
            la $a0, prompt2
            syscall

            break1:

            li $v0, 1
            move $a0, $a1
            syscall

            addi $s0, $s0, 1

            j loop
        

    fib:
        slti $t0, $a0, 2
        beq $t0, $0, Label
        addi $v0, $a0, 0
        jr $ra
    Label:
        addi $sp, $sp, -12
        sw $ra, 8($sp)
        sw $a0, 4($sp)
        addi $a0, $a0, -1
        jal fib
        sw $v0, 0($sp)
        lw $a0, 4($sp)
        lw $ra, 8($sp)
        addi $a0, $a0, -2
        jal fib
        lw $t0, 0($sp)
        lw $ra, 8($sp)
        add $v0, $v0, $t0
        addi $sp, $sp, 12
        jr $ra





        
        


