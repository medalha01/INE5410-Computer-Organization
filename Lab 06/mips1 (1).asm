.data
	.align 2
	filename: .asciiz "Resultado1.txt"
	.align 2
	space: .asciiz " "
	.align 2
	Array: .word 0 1 2 3 4 5 6 7 8 9
	.align 2
	Valor: .word 128
	.align 3
	funcA: .float 0
	funcB: .float 0
	result: .float 0
	prompt: .asciiz "\n Insira a variável A: "
	prompt2: .asciiz " Insira a variável B: "
	FloatZero: .float 0
	Espaco2: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0  0 0 0 0 0 0 0 0 0
	Espaco1: .asciiz " "
	

.text
COD:
	jal ColetaVar
	jal Operation
	jal PrintResult
	jal ConverterParaAscii
	jal EscreverArray
	li $v0, 10
	j COD
ColetaVar:
	li $v0, 4
	la $a0, prompt
	syscall
	li $v0, 6
	syscall
	swc1 $f0, funcA
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 6
	syscall
	swc1 $f0, funcB
	lwc1 $f1, funcA
	jr $ra
Operation:
	sub.s $f3, $f3, $f0
	div.s $f0, $f3, $f1
	swc1 $f0, result
	lwc1 $f12, result
	jr $ra
PrintResult:
	li $v0, 2
	syscall
	lwc1 $f0, FloatZero
	lwc1 $f1, FloatZero
	lwc1 $f2, FloatZero
	lwc1 $f3, FloatZero
	lwc1 $f12, FloatZero
	jr $ra
ConverterParaAscii:
	la $t0, Array
	la $t3, Espaco1
	li $t9, 0
	la $a0, filename
	li $v0, 13
	li $a1, 1
	li $a2 , 0
	syscall
	move $s7, $v0
	move $s6, $v0 
ConverterParaAscii2:
	beq $t9, 40, FinalizaEscrita
	lw $t1, ($t0)
	addi $t0, $t0, 4
	addi $t1, $t1, 48
	sw $t1, 0($t3)
	addi $t3, $t3, 4
	lw $t4, space
	sw $t4, 0($t3)
	addi $t3, $t3, 4
	addi $t9, $t9, 4
	j ConverterParaAscii2
FinalizaEscrita:
	li $v0 , 15
	move $a0, $s7
	la $a1, Espaco1
	move $a2, $t9
	add $a2, $a2, $a2
	syscall
	li $v0, 16
	move $a0, $s7
	syscall
	jr $ra
EscreverArray:
	la $t1, Espaco2
	li $v0, 13
	la $a0, filename
	li $a1, 0
	li $a2 , 0
	syscall
	move $s7, $v0
	li $v0, 14
	move $a0, $s7
	la $a1 , Espaco2
	li $a2, 80
	li $t0, 0
	syscall
ConverteArray:
	beq $t0, 84, FinalizaArray
	lw $t2, Espaco2($t0)
	subi $t2, $t2, 48
	sw $t2, Espaco2($t0)
	addi $t0, $t0, 4
	j ConverteArray
FinalizaArray:
	jr $ra
	
