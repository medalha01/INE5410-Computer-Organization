.data
	promptQuestaoTamanho: .asciiz "\n Qual o tamanho da Matriz quadrada? \n"
	avisoInputInvalido: .asciiz " Input invalido ou maior que 32, tente novamente."
	tamanhoMatriz: .word 0
	.align 2
	newline: .asciiz "\n"
	.align 2
	space: .asciiz " "
	promptQuestaoLinha1: .asciiz "\n Digite os numeros em ordem por linha 'Primeira Matriz' "
	promptQuestaoLinha2: .asciiz "\n Digite os numeros em ordem por linha 'Segunda Matriz' "
	filename: .asciiz "Resultado.txt"
        matrizA: .word 0 0 0 0 0 0 0 0 0


.text

partePrincipalAdquireInput:
	li $v0, 51
	la $a0, promptQuestaoTamanho
	syscall
	bnez $a1, inputInvalido
	bgt $a0, 32, inputInvalido
	move $t0, $a0
	move $s0, $t0 #Tamanho da matriz
	mul $s1, $t0, 4 #Tamanho da linha
	mul $s2, $t0, $t0
	mul $s2, $s2, 4 #Matriz na memoria
	sw $t0, tamanhoMatriz
	la $s3, matrizA #matrizA
	add $s4, $s3, $s2 #MatrizB
	add $s5, $s4, $s2 #MatrizResultado
	mul $t0, $t0, $t0 #Dimens√£o da matriz
	li $t1, 0
	move $t3, $s3	
	jal obtemMatrizUm
	jal Cancel
inputInvalido:
	li $v0, 4
	la $a0, avisoInputInvalido
	syscall
	j partePrincipalAdquireInput
obtemMatrizUm:
	beq $t0, $t1, preObtemMatrizDois
	li $v0, 51
	la $a0, promptQuestaoLinha1
	syscall
	move $t2, $a0
	sw $t2, 0($t3)
	addi $t3, $t3, 4
	addi $t1, $t1, 1
	j obtemMatrizUm
preObtemMatrizDois:
	li $t1, 0
	move $t3, $s4
obtemMatrizDois:
	beq $t0, $t1, calcula
	li $v0, 51
	la $a0, promptQuestaoLinha2
	syscall
	move $t2, $a0
	sw $t2, 0($t3)
	addi $t3, $t3, 4
	addi $t1, $t1, 1
	j obtemMatrizDois
calcula:
	li $t7, 0 #Coluna
	li $t6, 0 #Linha
	li $t1, 0 #Numero de iteracoes
	li $t2, 0 #Numero de itaracoes com reset
	li $t3, 0
	move $s6, $s3
	move $s7, $s4
	mul $s1, $s0, 4
calculaMain:
	beq $t3, $s0, Cancel
	beq $t2, $s0, ResetaReg2 #Loop2
	beq $t1, $s0, ResetaReg #Loop1 - i < numero de colunas
	lw $t4, 0($s6) #Carrega o endereÁo da variavel da matriz A
	lw $t5, 0($s7) #Carrega o endereÁo da variavel da matriz B
	mul $t9, $t4, $t5 #Multiplica as variaveis
	addu  $t8, $t8 ,$t9 #Soma as variaveis
	addi $s6, $s6, 4 #Add Linha
	add $s7, $s7, $s1 #Add coluna numero de elementos * 4
	addi $t1, $t1, 1
	j calculaMain
ResetaReg:
	sw $t8, 0($s5) # Guarda Resultado
	li $t8, 0 #Reseta somatorio
	addi $s5, $s5, 4 #Move Ponteiro, #Fim da matriz
	li $t1, 0 #Reseta contador 
	addi $t2, $t2, 1 #Soma Contador de iteraÁ„o do loop secundario
	addi $t7, $t7, 4 #Pecorre para a proxima linha
	move $s7, $s4
	move $s6, $s3
	add $s7, $s7, $t7
	add $s6, $s6, $t6
	j calculaMain
ResetaReg2:
	beq $t3, $s0, Cancel
	li $t7, 0
	li $t2, 0
	li $t1, 0
	add $t6, $t6, $s1
	move $s7, $s4
	move $s6, $s3
	add $s7, $s7, $t7
	add $s6, $s6, $t6
	addi $t3, $t3, 1
	j calculaMain
Cancel:
	move $t1, $zero
	move $t2, $zero
	mul $t4, $s0, 4
	move $t8, $zero
	move $t9, $zero
	addi $s5, $s5, 4
	add $t3, $s4, $s2
AbrirArquivo:
	la $a0, filename
	li $v0, 13
	li $a1, 1
	li $a2 , 0
	syscall
	move $t1, $v0
LoopDeEscritaDeLinha:
	bgt  $t9, $t4, EscreveNewLine
	addi $t9, $t9, 1
	move $t5, $zero
	move $t6, $zero
	move $t7, $zero
	lw $s7, space
	lw $t2, ($t3)
	addi $t3, $t3, 4
Milhar:
	blt $t2, 1000, Centena
	addi $t5, $t5, 1
	subi $t2, $t2, 1000
	j Milhar
Centena:
	blt $t2, 100, Dezena
	addi $t6, $t6, 1
	subi $t2, $t2, 100
	j Centena
Dezena:
	blt $t2, 10, EscreveNaMemoria
	addi $t7, $t7, 1
	subi $t2, $t2, 10
	j Dezena
EscreveNaMemoria:
	addi $t5, $t5, 48
	sw $t5, 0($s5)
	addi $s5, $s5, 4
	addi $t6, $t6, 48
	sw $t6, 0($s5)
	addi $s5, $s5, 4
	addi $t7, $t7, 48
	sw $t7, 0($s5)
	addi $s5, $s5, 4
	addi $t2, $t2, 48
	sw $t2, 0($s5)
	addi $s5, $s5, 4
	sw $s7, 0($s5)
	addi $s5, $s5, 4
	j LoopDeEscritaDeLinha
EscreveNewLine:
	beq $t8, $s0, EscreveNoArquivo
	lw $s7, newline
	sw $s7, 0($s5)
	addi $s5, $s5, 4	
	li $t9, 0
	addi $t8, $t8, 1
EscreveNoArquivo:
	mul $s0, $s0, $s0
	mul $s0, $s0, 4
	mul $s0, $s0, 5
	add $t3, $s4, $s2
	add $t3, $t3, $s2
	addi $t3, $t3, 4
	li $v0 , 15
	move $a0, $t1
	move $a1, $t3
	move $a2, $s0
	syscall 
	li $v0, 16
	move $a0, $t1
	syscall	
	


