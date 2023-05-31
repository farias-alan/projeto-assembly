.data
    menu: .asciiz "\nEscolha uma op��o:\n"
    
    op1: .asciiz "1 - Fahrenheit para Celsius\n"
    conv: .asciiz "Digite a temperatura em Fahrenheit\n"
    conv2: .asciiz "�C\n"
    conv3: .asciiz "O resultado da convers�o � "
    
    op2: .asciiz "2 - Fibonacci\n"
    prompt_fib: .asciiz "Digite o valor de N para calcular o en�simo termo da sequ�ncia de Fibonacci: "
    result_fib: .asciiz "O en�simo termo da sequ�ncia de Fibonacci �: "
    
    op3: .asciiz "3 - Enesimo par\n"
    prompt_par: .asciiz "Digite o valor de N para calcular o en�simo n�mero par: "
    result_par: .asciiz "O en�simo n�mero par �: "
    
    op4: .asciiz "4 - Sair\n"
    enc: .asciiz "Programa encerrado"
    
    inv: .asciiz "Op��o Inv�lida\n"
    

.text
    #print do menu
    principal:
    li $v0, 4   #definindo que a impress�o � uma string
    la $a0, menu    #definindo o que ser� impresso
    syscall     #imprimindo

    li $v0, 4
    la $a0, op1
    syscall 

    li $v0, 4
    la $a0, op2
    syscall 

    li $v0, 4
    la $a0, op3
    syscall 

    li $v0, 4
    la $a0, op4
    syscall 

    #ler o numero digitado pelo usuario para escolher a op��o do menu

    li $v0, 5    #lendo o numero inteiro digitado pelo usuario
    syscall

    #comparando entrada do usario com o numero das op�oes (IF)

    beq $v0, 1, converter	#caso a entrada seja 1, entao ira chamar a op�ao de converter
    beq $v0, 2, fibonacci	#caso seja 2, ira chamar a op�ao de Fibonacci
    beq $v0, 3, enesimo
    beq $v0, 4, sair     
    bge $v0, 5, invalido    	#usamos o bge para verificar se a o numero de entrada que o usuario digitou � maior ou igual a 5, caso seja, chama a fun�ao invalido

    #op��o 1 - Fahrenheit para Celsius
    
    converter:
    li $v0, 4
    la $a0, conv
    syscall

    li $v0, 5    #entrada do usuario em graus Fahrenheit
    syscall

    #equa�ao de transforma�ao de Fahrenheit para Celsius

    subi $t0, $v0, 32		#subtrai o valor de entrada do usuario por 32
    li $t1, 9		#atribuindo o valor 9 para $t1
    div $t0, $t1        #divide o resultado da subtra�ao acima por 9
    mflo $s0		#resultados das divisoes ficam armazenados em LO e HI, onde LO fica a parte inteira do quociente, e no HI fica o resto da divisao. Usamos o mflo para mover de LO para $s0 para conseguir ultilizar esse valor
    mul $t2, $s0, 5	#multiplica o resultado da divisao acima por 5, chegando no resultado final
    
    #impressao do resultado
    
    li $v0, 4
    la $a0, conv3
    syscall 
    
    li $v0, 1    	#imprimindo o resultado
    move $a0, $t2 	#movemos o resultado que estava em $t2 para $a0 para que o resultado seja impresso
    syscall

    li $v0, 4 
    la $a0, conv2 	#imprimindo a mensagem para complementar o resultado
    syscall

    j principal        #retorno pro menu principal



    #op��o 2 - Fibonacci
    
    fibonacci:
    li $v0, 4
    la $a0, prompt_fib
    syscall

    li $v0, 5
    syscall
    move $s0, $v0
    
    # Exibe o resultado do en�simo termo da sequ�ncia de Fibonacci
    li $v0, 4
    la $a0, result_fib
    syscall

    move $a0, $s0
    jal fib_loop

    move $a0, $v0
    li $v0, 1
    syscall

    jal principal  # Retorno ao menu principal


    # Fun��o para calcular a sequ�ncia de Fibonacci
    fib_loop:
    # Configura os registradores iniciais da sequ�ncia de Fibonacci
    li $t0, 0   # F0 = 0
    li $t1, 1   # F1 = 1
    li $t3, 1

    # Caso base
    beqz $a0, base_case   # Se N = 0, retorna F0 (0)
    beq $a0, 1, base_case   # Se N = 1, retorna F1 (1)
    beq $a0, 2, base_case
    addi $a0, $a0, -2   # Decrementa N em 2 para o pr�ximo termo

    fib_loop_inner:
    add $t2, $t3, $t1   # F2 = F0 + F1
    move $t3, $t1   # F0 = F1
    move $t1, $t2   # F1 = F2

    addi $a0, $a0, -1   # Decrementa N
    bnez $a0, fib_loop_inner   # Se N != 0, continua o loop

    move $v0, $t2   # Armazena o resultado em V0
    jr $ra   # Retorna � chamada anterior

    base_case:
    beqz $a0, base_case_zero    # Se N = 0, retorna F0 (0)
    beq $a0, 1, base_case_one   # Se N = 1, retorna F1 (1)
    beq $a0, 2, base_case_two
    base_case_zero:
    move $v0, $t0   # Retorna F0 (0)
    jr $ra   # Retorna � chamada anterior

    base_case_one:
    move $v0, $t1   # Retorna F1 (1)
    jr $ra   # Retorna � chamada anterior
    
    base_case_two:
    move $v0, $t1
    jr $ra



    #op��o 3 - En�simo par
    enesimo:
  
    li $v0, 4
    la $a0, prompt_par
    syscall

    # L� o valor de N digitado pelo usu�rio
    li $v0, 5
    syscall
    move $s0, $v0     # Armazena o valor de N em $s0

    # Calcula o en�simo n�mero par pulando de 2 em 2
    li $t0, 2       # Inicializa o multiplicador como 2
    mul $t1, $s0, $t0   # Multiplica N por 2

    li $t2, 0       # Inicializa o n�mero par como 0

    loop:
    addi $t2, $t2, 2    # Incrementa o n�mero par pulando de 2 em 2

    bne $t2, $t1, loop  # Se o n�mero par n�o atingir 2*N, continua o loop

    # Exibe o resultado
    li $v0, 4
    la $a0, result_par
    syscall

    li $v0, 1
    move $a0, $t2
    syscall
    jal principal   # Retorno ao menu principal


    #op��o 4 - Sair
    sair:
    li $v0, 4
    la $a0, enc 	#mensasem de encerramento do programa
    syscall

    li $v0, 10		#comando para encerrar o programa
    syscall		#execu�ao do encerramento


    #op��o Inv�lida
    invalido:
    li $v0, 4
    la $a0, inv 	#imprimindo a mensagem onde diz que a op�ao � invalida
    syscall

    j principal 	#apos a mensagem, retorna para o menu principal






