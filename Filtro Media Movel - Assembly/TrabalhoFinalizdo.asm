.data
	Output: .asciiz "output.txt"
	Ponto: .asciiz "."
	NewLine: .asciiz "\n"
	Zero: .float 0
	Um: .float 1
	Dez: .float 10
	Cem: .float 100
	Mil: .float 1000
	FimDeString: .asciiz "\0"
	.align 2
	SlotdeEscrita: .asciiz "1000"
	Espaco: .asciiz "                  "
	Constante: .asciiz "Con"
	Queda: .asciiz "Qued"
	Alta: .asciiz "Alta"
	Cotacao: .asciiz "Cotação(Entrada)"
	Curto: .asciiz "Curto"
	Longo: .asciiz "Longo"
	Tendencia: .asciiz "Tendencia"
	TextDisplay: .asciiz "Digite a serie numerica em ordem \n Digite Q para determinar o fim da serie!"
	TextDisplayFilter: .asciiz "Digite a serie do Filtro Curto"
	TextDisplayFilter2: .asciiz "Digite a serie do Filtro Longo"
	MemDin: .word 0


##Multiplicar o float por 10 e escrever numero por numero, sim isso é retardado
##NÃ£o esquecer de salvar os resultados no final sad face :c arquivo e pritnar no negocio sad face tbm
.text
	li $s7, 0 ##Pointer da Memoria
	li $s6, 0 ##Numero de iteraÃ§Ãµes
	lwc1 $f30, Um
	CollectInput:
		li $v0, 52
		la $t0, TextDisplay
		move $a0, $t0 ##Texto de Display
		syscall
		beq $a1, -1, Filter
		beq $a1, -2, End
		addi $s6, $s6, 1  ### Numero de elementos da Serie Historica
		swc1 $f0, MemDin($s7)
		addi $s7, $s7, 4 ##### Tamanho da Serie Historica na Memoria (importante)
		li $v0, 2
		add.s $f12, $f0, $f2
		syscall
		la $t0, NewLine
		li $v0, 4
		move $a0, $t0 ##Nova Linha
		syscall
		j CollectInput
	Filter:
		li $v0, 51
		la $t0, TextDisplayFilter ##Texto de Display
		move $a0, $t0
		syscall
		la $t0, TextDisplayFilter2 ##Texto de Display
		move $s0, $a0 ### Filtro 1
		li $v0, 51
		move $a0, $t0 ##Texto de Display
		syscall
		move $s1, $a0 ### Filtro 2
		la $s5, MemDin($s7)###Ponteiro da memoria atual
		move $t1, $s0
		jal CalculoFiltro
	Parte2:
		li $t2, 0
		move $t1, $s1
		jal CalculoFiltro
		add $s4, $s7, $s7
		move $s3, $s7
		li $t7, 0
		la $t0, MemDin
		la $t1, MemDin($s3)
		la $t2, MemDin($s4)
		li $t6, 0
		j PreCompara
	CalculoFiltro:
		beq $t2, $s6, Retorna ### $t2 sendo usado como contador de iteração contra o numero de elementos $t2 = conta o numero de resets para garantir que todos os elementos sejam filtrados
		lwc1 $f4, Zero #Reseta acumulador
		li $t6, 0 ##IF (Interation Counter For Item)
		mul $s2, $t2, 4 ##Ponteiro memoria
		blt $t2, $t1, CalculoMenor
	CalculoMaior:
		beq $t6, $t1,EscreveResultadoMem1
		lwc1 $f2, MemDin($s2)
		subi $s2, $s2, 4
		add.s $f4, $f2, $f4
		addi $t6, $t6, 1
		add.s $f28, $f28, $f30
		j CalculoMaior
	CalculoMenor:
		move $t6, $t2
	CalculoMenorP2:
		bltz $t6, EscreveResultadoMem2
		lwc1 $f2, MemDin($s2)
		subi $s2, $s2, 4
		add.s $f4, $f2, $f4
		subi $t6, $t6, 1 
		add.s $f28, $f28, $f30
		j CalculoMenorP2
	EscreveResultadoMem1:
		div.s $f4, $f4, $f28
		mov.s $f12, $f4
		li $v0, 2
		syscall
		swc1 $f4,0($s5)
		mov.s $f4, $f0
		mov.s $f28, $f0
		addi $s5, $s5, 4
		addi $t2, $t2, 1
		j CalculoFiltro
	EscreveResultadoMem2:
		li $t9, 0
		div.s $f4, $f4, $f28
		mov.s $f12, $f4
		li $v0, 2
		syscall
		swc1 $f4, 0($s5)
		mov.s $f4, $f0
		mov.s $f28, $f0
		addi $s5, $s5, 4
		addi $t2, $t2, 1
		j CalculoFiltro
	Retorna:
		jr $ra
	PreCompara:
		jal EscreverArquivos
	Compara:
		### Provisorio
		lwc1 $f2, ($t0) #entrada
		mov.s $f28, $f2
		jal EscreverEntradas
		lwc1 $f4, ($t1) #filtro1
		mov.s $f28, $f4
		jal EscreverEntradas
		lwc1 $f6, ($t2) #filtro2
		mov.s $f28, $f6
		jal EscreverEntradas
		c.lt.s $f2, $f4
		bc1t CheckQueda
		c.lt.s $f4, $f2
		bc1t CheckAlta
		j Constantee
	CheckQueda:
		c.lt.s $f4, $f6
		bc1f Constantee
		li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, Queda   # address of buffer from which to write
  		li   $a2, 4
  		syscall
		la $t5, Queda
		sw $t5, ($s5)
		addi $s5, $s5, 4
		j Prox
	CheckAlta:
		c.lt.s $f6, $f4
		bc1f Constantee
		li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, Alta   # address of buffer from which to write
  		li   $a2, 4
  		syscall
		la $t5, Alta
		sw $t5, ($s5)
		addi $s5, $s5, 4
		j Prox
	Constantee:
		li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, Constante   # address of buffer from which to write
  		li   $a2, 4
  		syscall
		la $t5, Constantee
		sw $t5, ($s5)
		addi $s5, $s5, 4
		j Prox
	Prox:
		li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, NewLine   # address of buffer from which to write
  		li   $a2, 1
  		syscall
		addi $t0, $t0, 4
		addi $t1, $t1, 4
		addi $t2, $t2, 4
		addi $t7, $t7, 1
		j Compara
	EscreverArquivos:
		 # Open (for writing) a file that does not exist
  		li   $v0, 13       # system call for open file
 		la   $a0, Output     # output file name
 		li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
		li   $a2, 0        # mode is ignored
  		syscall            # open a file (file descriptor returned in $v0)
  		move $s0, $v0      # save the file descriptor 
  	  # Write to file just opened
 		li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, Cotacao   # address of buffer from which to write
  		li   $a2, 7       # hardcoded buffer length
 	 	syscall            # write to file
 		li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, Espaco   # address of buffer from which to write
  		li   $a2, 18       # hardcoded buffer length
 	 	syscall            # write to file
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, Curto   # address of buffer from which to write
  		li   $a2, 5       # hardcoded buffer length
 	 	syscall            # write to file
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, Espaco   # address of buffer from which to write
  		li   $a2, 18       # hardcoded buffer length
 	 	syscall            # write to file
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, Longo   # address of buffer from which to write
  		li   $a2, 5       # hardcoded buffer length
 	 	syscall            # write to file
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, Espaco   # address of buffer from which to write
  		li   $a2, 18       # hardcoded buffer length
 	 	syscall            # write to file
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, Tendencia   # address of buffer from which to write
  		li   $a2, 9       # hardcoded buffer length
 	 	syscall            # write to file
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, NewLine   # address of buffer from which to write
  		li   $a2, 1       # hardcoded buffer length
 	 	syscall            # write to file
 	 	jr $ra
 	 	EscreverEntradas:
 	 	beq $t7, $s6, End ###BAD CODE
 	 	Miil:
 	 	lwc1 $f30, Mil
 	 	c.lt.s 0,$f28, $f30
		bc1t FimMil
		addi $t4, $t4, 1
		sub.s $f28, $f28, $f30
		j Miil
		FimMil:
		addi $t4, $t4, 48
		sw $t4, SlotdeEscrita
		li $t4, 0
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, SlotdeEscrita   # address of buffer from which to write
  		li   $a2, 1
  		syscall
  		Ceem:
  		lwc1 $f30, Cem
		c.lt.s 0,$f28, $f30
		bc1t FimCem
		addi $t4, $t4, 1
		sub.s $f28, $f28, $f30
		j Ceem
		FimCem:
		addi $t4, $t4, 48
		sw $t4, SlotdeEscrita
		li $t4, 0
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, SlotdeEscrita   # address of buffer from which to write
  		li   $a2, 1
  		syscall            # write to file
  		Deez:
  		lwc1 $f30, Dez
		c.lt.s 0,$f28, $f30
		bc1t FimDez
		addi $t4, $t4, 1
		sub.s $f28, $f28, $f30
		j Deez
		FimDez:
		addi $t4, $t4, 48
		sw $t4, SlotdeEscrita
		li $t4, 0
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, SlotdeEscrita   # address of buffer from which to write
  		li   $a2, 1
  		syscall
  		Uum:
  		lwc1 $f30, Um
		c.lt.s 0,$f28, $f30
		bc1t FimUm
		addi $t4, $t4, 1
		sub.s $f28, $f28, $f30
		j Uum
		FimUm:
		addi $t4, $t4, 48
		sw $t4, SlotdeEscrita
		li $t4, 0
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, SlotdeEscrita   # address of buffer from which to write
  		li   $a2, 1
  		syscall
  		Zeero:
  		li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, Ponto   # address of buffer from which to write
  		li   $a2, 1
  		syscall
  		lwc1 $f30, Dez
  		mul.s $f28, $f28, $f30
  		ZeeroUm:
  		lwc1 $f30, Um
		c.lt.s 0,$f28, $f30
		bc1t NextUm
		addi $t4, $t4, 1
		sub.s $f28, $f28, $f30
		j ZeeroUm
		NextUm:
		addi $t4, $t4, 48
		sw $t4, SlotdeEscrita
		li $t4, 0
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, SlotdeEscrita   # address of buffer from which to write
  		li   $a2, 1
  		syscall
  		lwc1 $f30, Dez
  		mul.s $f28, $f28, $f30
  		ZeeroDois:
  		lwc1 $f30, Um
		c.lt.s 0,$f28, $f30
		bc1t NextDois
		addi $t4, $t4, 1
		sub.s $f28, $f28, $f30
		j ZeeroDois
		NextDois:
		addi $t4, $t4, 48
		sw $t4, SlotdeEscrita
		li $t4, 0
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, SlotdeEscrita   # address of buffer from which to write
  		li   $a2, 1
  		syscall
  		lwc1 $f30, Dez
  		mul.s $f28, $f28, $f30
  		ZeeroTres:
  		lwc1 $f30, Um
		c.lt.s 0,$f28, $f30
		bc1t NextTres
		addi $t4, $t4, 1
		sub.s $f28, $f28, $f30
		j ZeeroTres
		NextTres:
		addi $t4, $t4, 48
		sw $t4, SlotdeEscrita
		li $t4, 0
 	 	li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, SlotdeEscrita   # address of buffer from which to write
  		li   $a2, 1
  		syscall
  		li   $v0, 15       # system call for write to file
 		move $a0, $s0      # file descriptor 
  		la   $a1, Espaco   # address of buffer from which to write
  		li   $a2, 18      # hardcoded buffer length
  		syscall
  		jr $ra
		#---------------
		End:
		li   $v0, 16       # system call for close file
 		move $a0, $s0     # file descriptor to close
 		syscall            # close file
  ###############################################################
