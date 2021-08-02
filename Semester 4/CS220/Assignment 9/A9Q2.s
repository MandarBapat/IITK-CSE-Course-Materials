	.data
	str2: .asciiz "Input number N entered\n"
	str3: .asciiz "First array taken as input\n"
	str4: .asciiz "Second array taken as input\n"
	str5: .asciiz "Multiplication computed\n"
	A: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
	B: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;


	.text
	.globl main	
	main:	li $v0,5;
		syscall;
		move $t0,$v0;

		li $v0,4;
		la $a0, str2;
		syscall;

		li $t1,0;

	loop1:	slt $t2,$t1,$t0;
		beq $t2,$0,exit1

 		li $v0,6;
		syscall;
		mov.s $f1,$f0;

		la $t3,A;
		move $t4, $t1;
		sll $t4,$t4,2;
		add $t3, $t4, $t3;
		s.s $f1, 0($t3);

		addi $t1,$t1,1;
		j loop1


	exit1:	li $v0,4;
		la $a0, str3;
		syscall;

		li $t1,0;


	loop2:	slt $t2,$t1,$t0;
		beq $t2,$0,exit2

  		li $v0,6;
		syscall;
  		mov.s $f1,$f0;

		la $t3,B;
		move $t4, $t1;
		sll $t4,$t4,2;
		add $t3, $t4, $t3;
		s.s $f1, 0($t3);

		addi $t1,$t1,1;
		j loop2
	

	exit2:	li $v0,4;
		la $a0, str4;
		syscall;

		li $t1,0;
		mtc1 $0,$f5;

	loop3:	slt $t2,$t1,$t0;
		beq $t2,$0,exit3
		la $t3,A;
		move $t4,$t1;
		sll $t4,$t4,2;
		add $t3, $t4, $t3;
		l.s $f6, 0($t3);

		la $t3,B;
		move $t4,$t1;
  		sll $t4,$t4,2;
  		add $t3, $t4, $t3;
  		l.s $f7, 0($t3);

  		mul.s $f6,$f6,$f7;
  		add.s $f5,$f5,$f6;

  		addi $t1,$t1,1;
		j loop3
	

	exit3:	li $v0,4;
		la $a0, str5;
		syscall;

		mov.s $f12,$f5;
		li $v0,2;
		syscall;


	end: jr $ra


