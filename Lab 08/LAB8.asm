.text
li $t1, 1
li $v0, 5
syscall
move $t0, $v0
move $t8, $t0
jal factorial
move $s1, $s0 ## N!
li $v0, 5
syscall
move $t0, $v0
move $t9, $t0
jal factorial
move $s2, $s0 ## P!
sub $t8, $t8, $t9
move $t0, $t8
jal factorial
move $s3, $s0 ## (n- P)!
mul $s4, $s2, $s3
div $s4, $s1, $s4
j End 
 ## Soma
retornoFactorial:
move $s0, $t1
li $t1, 1
jr $ra
factorial:
beq $t0, $zero, retornoFactorial
mul  $t1, $t0, $t1
sub $t0, $t0, 1
j factorial
End:
li $v0, 1
move $a0, $s4
syscall