.data
	matriz: .word 1 2 0 1 -1 -3 0 1 3 6 1 3 2 4 0 3
	matriztransposta: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	fout: .asciiz "testout.dat"	# nome do arquivo de sa?da.
.text
	#s0 endereço matriztransposta
	#t0 endereço matrizprinciapl
	#s1 contador do loop secundario
	#s2 contador do loop principal // ponteiro de memoria

LOOP2:  beq $s2, 16, CODIGO #Loop principal, ele itera para cada coluna
	la $s0, matriztransposta # Carrega Memoria matriz principal
	la $t0, matriz #Carrega memoria matriz transposta
	add $s0,$s0, $s2 #Move o ponteiro da matriz transposta para proxima coluna
	add $t0, $t0, $s2 #Move o ponteiro da matriz principal para proxima linha
	add $t0, $t0, $s2
	add $t0, $t0, $s2
	add $t0, $t0, $s2 #Fim do move ponteiro
LOOP:	beq $s1, 4, ADD #Loop secundario, ele itera para cada linha
	lw $t1, 0($t0)
	addi $t0, $t0, 4 #Move ponteiro na memoria
	sw $t1, ($s0)
	addi $s0, $s0, 16
	addi $s1, $s1, 1 #Contador de iterações
	j LOOP 
ADD:    addi $s2, $s2, 4 #Contador de iterações // Tambem serve como ponteiro de memoria
	li $s1, 0
	j LOOP2
CODIGO: li $v0, 13 			# Comando para abrir novo arquivo. 
	la $a0, fout 			# Carrega nome
	li $a1, 1 			# Aberto para escrita
	li $a2, 0 		
	syscall 			# Abre arquivo
	move $s6, $v0 			
	li $v0, 15 			 
	move $a0, $s6 			 
	la $a1, matriztransposta	
	li $a2, 16			
	syscall 			
	li $v0, 16 			
	move $a0, $s6 			
	syscall 			

	
