;Trabalho 2 - calculadora avançada -> Prof. Leandro Alonso Xastre
;Aluno: Tiago Rodrigues Mattar
;RA...: 21000233 
.model small
.data
    MSG_CALC DB 13, 10, '       [ x86 Calculator Program ]', 13, 10, '$'
    MSG_MENU db 13, 10, '        >>> Menu de escolhas <<<', 13, 10, 13, 10, '$'
    MSG_LINHA DB 13, 10, 8 DUP('-----'), '$'
    MSG_LINHA1 db          '   A+B (a)  A-B (b)  Mul (c)  Div (d) ', '$'
    MSG_LINHA2 DB  13, 10, '   X^Y (e)  X^2 (f)  10^ (g)  log (h) ', '$'
    MSG_LINHA3 DB  13, 10, '   |M| (i)  Sqr (j)  W%Y (k)  D_B (l) ', '$'
    MSG_LINHA4 DB  13, 10, '   B_D (m)  D_H (n)  H_D (o)  B_H (p) ', '$'
    MSG_LINHA5 DB  13, 10, '   H_B (q)  End (0)', '$'
    MSG_ESCOLHA db 13, 10, ' >>> Digite a operacao desejada: ', '$'
    MSG_CONTINUAR db 13, 10, 13, 10, 'Continuar a usar a calculadora? (s ou n)', '$'
    MSG1  DB  13, 10, 13, 10, ' Digite um valor para A: ', '$'
    MSG2  DB  13, 10, ' Digite um valor para B: ', '$'
    MSG_M DB 13, 10, 13, 10, ' Digite um valor para M: ', '$'
    MSG_MUL  DB 13, 10, 13, 10, ' Valor do primeiro operando: ', '$'
    MSG_MUL2 DB 13, 10, ' Valor do segundo operando.: ', '$'
    MSG_DIV  DB 13, 10, 13, 10, ' Digite o valor do dividendo: ', '$'
    MSG_DIV2 DB 13, 10, ' Digite o valor do divisor..: ', '$'
    MSG_RES DB 13, 10, ' >> RESULTADO: ', '$'
    MSG_X DB 13, 10, 13, 10, ' Digite um valor para X (operando): ', '$'
    MSG_Y DB 13, 10, 13, 10, ' Digite um valor para Y (expoente): ', '$'
    MSG_EXPOENTE DB 13, 10, 13, 10, ' Digite o valor do expoente: ', '$'
    MSG_DECIMAL DB 13, 10, 13, 10, ' Digite um numero decimal: ', '$'
    MSG_BINARIO DB 13, 10, 13, 10, ' Digite um numero binario: ', '$'
    MSG_HEXA DB 13, 10, 13, 10, ' Digite um numero hexadecimal: ', '$'
    MSG_RAIZ DB 13, 10, 13, 10, ' Digite um radicando: ', '$'
    MSG_RAIZ_MENOR DB 13, 10, ' - O radicando nao possui raiz perfeita', '$'
    MSG_W DB 13, 10, 13, 10, ' Digite um valor para W: ', '$'
    MSG_Y_2 DB 13, 10, 13, 10, ' Digite um valor para Y: ', '$'
    MSG_LOGARIT DB 13, 10, 13, 10, ' Digite o logaritmando: ', '$'
    MSG_FUNC DB 13, 10, 13, 10, 'Digite uma funcao f(x): ', '$'
    FUNCAO DB ?
    MSG_1 DB '0', '$'
    MSG_2 DB '0.3', '$'
    MSG_3 DB '0.48', '$'
    MSG_5 DB '0.7', '$'
.stack 100h
.code
ENTDEC PROC
;le um numero decimal da faixa de -32768 a +32767
;variaveis de entrada: nenhuma (entrada de digitos pelo teclado)
;variaveis de saida: AX  ->  valor binario equivalente do numero decimal
    PUSH BX
    PUSH CX
    PUSH DX                     ;salvando registradores que serão usados
    XOR BX,BX                   ;BX  acumula o total, valor inicial 0
    MOV AH,1h
    INT 21h                     ;le caracter no AL
    CMP AL,'-'                  ;sinal negativo?
    JE MENOS
    CMP AL,'+'                  ;sinal positivo?
    JE MAIS
    JMP NUM                     ;se não é sinal, então vá processar o caracter
    MENOS:
        MOV CX,1                ;negativo = verdadeiro
    MAIS:
        INT 21h                 ;lê um outro caracter
    NUM:
        AND AX,000Fh            ;junta AH a AL, converte caracter para binário
        PUSH AX                 ;salva AX (valor binário) na pilha
        MOV AX,10               ;prepara constante 10
        MUL BX                  ;AX = 10 x total, total está em BX
        POP BX                  ;retira da pilha o valor salvo, vai para BX
        ADD BX,AX               ;total = total x 10 + valor binário
        MOV AH,1h
        INT 21h                 ;le um caracter
        CMP AL,0Dh              ;é o CR ?
        JNE  NUM                ;se não, vai processar outro dígito em NUM
        MOV AX,BX               ;se é CR, então coloca o total calculado em AX
        CMP CX,1                ;o número é negativo?
        JNE SAIDA               ;não
        NEG AX                  ;sim, faz-se seu complemento de 2
    SAIDA:
        POP DX
        POP CX
        POP BX                  ;restaura os conteúdos originais
        RET                     ;retorna a rotina que chamou
ENTDEC ENDP

SAIDEC PROC
;exibe o conteudo de AX como decimal inteiro
;variaveis de entrada: AX  ->  valor binario equivalente do número decimal
;variaveis de saida: nenhuma (exibição de dígitos direto no monitor de video)
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX                     ;salva na pilha os registradores usados
    OR AX,AX                    ;prepara comparação de sinal
    JGE PT1                     ;se AX maior ou igual a 0, vai para PT1
    PUSH AX                     ;como AX menor que 0, salva o número na pilha
    MOV DL,'-'                  ;prepara o caracter '-' para sair
    MOV AH,2h                   ;prepara exibição
    INT 21h                     ;exibe '-'
    POP AX                      ;recupera o número
    NEG AX                      ;troca o sinal de AX (AX = - AX)
    PT1:
        XOR CX,CX               ;inicializa CX como contador de dígitos
        MOV BX,10               ;BX possui o divisor
    PT2:
        XOR DX,DX               ;inicializa o byte alto do dividendo em 0; restante é AX
        DIV BX                  ;após a execução, AX = quociente; DX = resto
        PUSH DX                 ;salva o primeiro dígito decimal na pilha (1o. resto)
        INC CX                  ;contador = contador + 1
        OR AX,AX                ;quociente = 0 ? (teste de parada)
        JNE PT2                 ;não, continuamos a repetir o laço
        ;exibindo os dígitos decimais (restos) no monitor, na ordem inversa
        MOV AH,2h               ;sim, termina o processo, prepara exibição dos restos
    PT3: 
        POP DX                  ;recupera dígito da pilha colocando-o em DL (DH = 0)
        ADD DL,30h              ;converte valor binário do dígito para caracter ASCII
        INT 21h                 ;exibe caracter
        LOOP PT3                ;realiza o loop ate que CX = 0
        POP DX                  ;restaura o conteúdo dos registros
        POP CX
        POP BX
        POP AX                  ;restaura os conteúdos dos registradores
        RET                     ;retorna à rotina que chamou
SAIDEC ENDP

ENTHEX PROC
;BX é assumido como registrador de armazenamento
;string de caracteres "0" a "9" ou de "A" a "F", digitado no teclado
;máximo de 16 bits de entrada ou máximo de 4 dígitos hexa
    XOR BX, BX                  ;inicializa BX com zero
    MOV CL, 4                   ;inicializa contador com 4
    MOV AH, 01h                 ;prepara entrada pelo teclado
    INT 21h                     ;entra o primeiro caractere

    TOPO_v2: 
        CMP AL, 0Dh             ;é o CR ?
        JE FIM_v2
        CMP AL, 39h             ;caractere número ou letra?
        JG LETRA                ;caractere já está na faixa ASCII
        AND AL, 0Fh             ;número: retira 30h do ASCII
        JMP DESL
    LETRA: 
        SUB AL, 37h             ;converte letra para binário
    DESL:     
        SHL BX, CL              ;desloca BX 4 casas à esquerda
        OR BL, AL               ;insere valor nos bits 0 a 3 de BX
        INT 21h                 ;entra novo caractere
        JMP TOPO_v2             ;faz o laço até que haja CR
    FIM_v2:
        RET
ENTHEX ENDP

SAIHEX PROC
;BX é assumido como registrador de armazenamento
;total de 16 bits de saída
;string de caracteres HEXA é exibido no monitor de vídeo.
    MOV CH, 4                   ;CH contador de caracteres hexa
    MOV CL, 4                   ;CL contador de deslocamentos
    MOV AH, 02h                 ;prepara exibição no monitor

    TOPO_2: 
        MOV DL, BH              ;captura em DL os oito bits mais significativos de BX
        SHR DL, CL              ;resta em DL os 4 bits mais significativos de BX
        CMP DL, 0Ah             ;testa se é letra ou número
        JAE LETRA_2
        ADD DL,30h              ;é número: soma-se 30h
        JMP PT1_v2

    LETRA_2: 
        ADD DL, 37h             ;ao valor soma-se 37h -> ASCII

    PT1_v2: 
        INT 21h                 ;exibe
        ROL BX, CL              ;roda BX 4 casas para a direita
        DEC CH
        JNZ TOPO_2              ;faz o FOR 4 vezes
    RET
SAIHEX ENDP

ENTBIN PROC
;string de caracteres "0's" e "1's" fornecidos pelo teclado
;BX é assumido como registrador de armazenamento
;máximo de 16 bits de entrada.
    MOV CX, 16                  ;inicializa contador de dígitos
    MOV AH, 01h                 ;função DOS para entrada pelo teclado
    XOR BX, BX                  ;zera BX -> terá o resultado
    INT 21h                     ;entra, caractere está no AL

    TOPO: 
        CMP AL,0Dh              ;é CR?
        JE FIM                  ;se sim, termina o WHILE
        AND AL,0Fh              ;se não, elimina 30h do caractere (poderia ser SUB AL,30h)
        SHL BX,1                ;abre espaço para o novo dígito
        OR  BL,AL               ;insere o dígito no LSB de BL
        INT 21h                 ;entra novo caractere
        LOOP TOPO               ;controla o máximo de 16 dígitos
    FIM:
        RET
ENTBIN ENDP

SAIBIN PROC
;BX é assumido como registrador de armazenamento
;total de 16 bits de saída
;string de caracteres "0's" e "1's" é exibido no monitor de vídeo
    MOV CX, 16                  ;inicializa contador de bits
    MOV AH, 02h                 ;prepara para exibir no monitor

    PARTE1_v2: 
        ROL BX, 1               ;desloca BX 1 casa à esquerda
        JNC PARTE2_v2           ;salta se CF = 0
        MOV DL, 31h             ;como CF = 1
        INT 21h                 ;exibe na tela "1" = 31h
        JMP PARTE3_v2
    PARTE2_v2: 
        MOV DL, 30h             ;como CF = 0
        INT 21h                 ;exibe na tela "0" = 30h
    PARTE3_v2:  
        LOOP PARTE1_v2          ;repete 16 vezes
    RET
SAIBIN ENDP

MENU_CALC PROC                  ;interface gráfica do Menu de escolhas
    MOV AH, 00H                 ;função set video mode -> deixa a apresentação do programa mais bonita
    MOV AL, 0
    INT 10h

    MOV AH, 06h                 ;função Scroll Up
    XOR AL, AL                  ;limpa toda a tela
    ;título da calculadora
    XOR CX, CX                  ;canto superior esquerdo - CH = fileira, CL = coluna
    MOV DX, 0427H               ;canto inferior direito  - DH = fileira, DL = coluna 
    MOV BH, 8Eh                 ;Preto: cor de fundo ; Amarelo: cor do texto -> 8Eh = 1000 1110b - bit mais significativo = 1 (blinking)
    INT 10H
    ;corpo da calculadora
    MOV CX, 0500H               ;canto superior esquerdo - CH = fileira, CL = coluna
    MOV DX, 1327H               ;canto inferior direito  - DH = fileira, DL = coluna
    MOV BH, 0Bh                 ;Preto: cor de fundo ; Ciano claro: cor do texto
    INT 10H
    ;parte das operações -> Preto: cor de fundo ; Branco básico: cor do texto

    MOV AH, 09h
    LEA DX, MSG_CALC
    INT 21h                     ;exibe a mensagem menu

    LEA DX, MSG_MENU
    INT 21h                     ;exibe a mensagem menu

    LEA DX, MSG_LINHA1
    INT 21h                     ;exibe a mensagem da primeira linha da calculadora

    LEA DX, MSG_LINHA
    INT 21h                     ;imprime uma linha de de 40 (-) para separar as linhas da calculadora

    LEA DX, MSG_LINHA2
    INT 21h                     ;exibe a mensagem da segunda linha da calculadora

    LEA DX, MSG_LINHA
    INT 21h                     ;imprime uma linha de de 40 (-) para separar as linhas da calculadora

    LEA DX, MSG_LINHA3
    INT 21h                     ;exibe a mensagem da terceira linha da calculadora

    LEA DX, MSG_LINHA
    INT 21h                     ;imprime uma linha de de 40 (-) para separar as linhas da calculadora

    LEA DX, MSG_LINHA4
    INT 21h                     ;exive a mensagem da quarta linha da calculadora

    LEA DX, MSG_LINHA
    INT 21h                     ;imprime uma linha de de 40 (-) para separar as linhas da calculadora

    LEA DX, MSG_LINHA5
    INT 21h                     ;exibe a mensagem da quinta linha da calculadora

    LEA DX, MSG_LINHA
    INT 21h                     ;imprime uma linha de de 40 (-) para separar as linhas da calculadora

    LEA DX, MSG_ESCOLHA
    INT 21h                     ;exibe a mensagem escolha de uma operação

    MOV AH, 01H                 ;leitura de qual operação será realizada
    INT 21h
    RET
MENU_CALC ENDP

OPSOMA PROC
    MOV AH,9h
    LEA DX,MSG1
    INT 21h                     ;exibe a primeira mensagem (valor de A)
    
    CALL ENTDEC                 ;chama subrotina ENTDEC, retorna o valor de A
    MOV SI,AX                   ;move o valor de A, presente em AX, para o registrador SI
    
    MOV AH,9h
    LEA DX,MSG2
    INT 21h                     ;exibe a segunda mensagem (valor de B)

    CALL ENTDEC                 ;chama subrotina ENTDEC, retorna o valor de B
    ADD AX,SI                   ;somando os 2 valores

    PUSH AX                     ;salva na pilha o valor de AX

    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;imprime a mensagem 'RESULTADO: ' na tela

    POP AX                      ;recupera o valor da pilha em AX

    CALL SAIDEC                 ;chama subrotina SAIDEC -> exibindo o valor da soma na tela
    RET
OPSOMA ENDP

OPSUB PROC
    MOV AH,9h
    LEA DX,MSG1
    INT 21h                     ;exibe a primeira mensagem (valor de A)
    
    CALL ENTDEC                 ;chama subrotina ENTDEC, retorna o valor de A
    MOV SI,AX                   ;move o valor de A, presente em AX, para o registrador SI
    
    MOV AH,9h
    LEA DX,MSG2
    INT 21h                     ;exibe a segunda mensagem (valor de B)

    CALL ENTDEC                 ;chama subrotina ENTDEC, retorna o valor de B
    SUB SI,AX                   ;subtraindo os 2 valores
    MOV AX,SI                   ;move o resultado da subtração para AX

    PUSH AX                     ;salva na pilha o valor de AX

    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;imprime a mensagem 'RESULTADO: ' na tela

    POP AX                      ;recupera o valor da pilha em AX

    CALL SAIDEC                 ;chama subrotina SAIDEC -> exibindo o valor da subtração na tela
    RET
OPSUB ENDP

OPMULT PROC
    MOV AH,9h
    LEA DX, MSG_MUL
    INT 21h                     ;exibe mensagem para digitar um valor para o primeiro operando

    CALL ENTDEC                 ;chama subrotina ENTDEC
    PUSH AX                     ;salva o valor de AX na pilha

    MOV AH,9h
    LEA DX, MSG_MUL2
    INT 21h                     ;exibe mensagem para digitar um valor para o segundo operando

    CALL ENTDEC                 ;chama subrotina ENTDEC
    MOV BX, AX                  ;move o valor de AX para BX
    POP AX

    MUL BL                      ;multiplica BL por AL

    PUSH AX                     ;salva na pilha o valor de AX -> quociente

    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;imprime a mensagem 'RESULTADO: ' na tela

    POP AX                      ;recupera o valor da pilha em AX

    CALL SAIDEC                 ;chama subrotina SAIDEC -> exibindo o valor da multiplicação na tela
    RET
OPMULT ENDP

OPDIV PROC
    MOV AH,9h
    LEA DX, MSG_DIV
    INT 21h                     ;exibe mensagem para digitar um valor para o dividendo

    CALL ENTDEC                 ;chama subrotina ENTDEC
    PUSH AX                     ;salva o valor de AX na pilha

    MOV AH,9h
    LEA DX, MSG_DIV2
    INT 21h                     ;exibe mensagem para digitar o valor para o divisor

    CALL ENTDEC                 ;chama subrotina ENTDEC
    MOV BX, AX                  ;move o valor de AX para BX
    POP AX                      ;recupera o valor da pilha em AX

    DIV BL                      ;divide AX por BL
    PUSH AX                     ;salva o valor de AX na pilha

    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h

    POP AX                      ;recupera o valor da pilha em AX
    XOR AH, AH
    CALL SAIDEC                 ;chama subrotina SAIDEC
    RET
OPDIV ENDP

OPEXPONENCIAL PROC
    MOV AH,9h
    LEA DX, MSG_Y
    INT 21h                     ;exibe mensagem para digitar um valor para Y

    CALL ENTDEC                 ;chama subrotina ENTDEC
    MOV CX, AX                  ;move o valor de AX para CX (contador)
    SUB CX, 0001H               ;subtrai 1 de CX (as multiplicações que acontecem são sempre iguais ao expoente - 1 -> EX: 2^2 = 2*2, 2^3 = 2*2*2...)
    CMP CX, 0000H               ;compara CX com 0
    JE EXPO_1                   ;se for igual, pula para EXPO_1

    MOV AH,9h
    LEA DX, MSG_X
    INT 21h                     ;exibe mensagem para digitar um valor para X

    CALL ENTDEC                 ;chama subrotina ENTDEC
    MOV BX, AX                  ;move o valor de AX para BX (segundo operando)

    OPERACAO_EXP:
        MUL BL                  ;multiplica AL por BL
        LOOP OPERACAO_EXP       ;LOOP até CX = 0

    PUSH AX                     ;salva na pilha o valor de AX

    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;imprime a mensagem 'RESULTADO: ' na tela

    POP AX                      ;recupera o valor da pilha em AX

    CALL SAIDEC                 ;chama subrotina SAIDEC
    JMP TERMINO

    EXPO_1:
        MOV AH,9h
        LEA DX, MSG_X
        INT 21h                 ;exibe mensagem para digitar um valor para X

        CALL ENTDEC             ;chama subrotina ENTDEC
        PUSH AX                 ;salva o valor de AX na pilha

        MOV AH, 09h
        LEA DX, MSG_RES
        INT 21h                 ;imprime a mensagem 'RESULTADO: ' na tela

        POP AX                  ;restaura o valor da pilha em AX
        CALL SAIDEC             ;chama subrotina SAIDEC
    TERMINO:
        RET
OPEXPONENCIAL ENDP

OP_POW_X_2 PROC
    MOV AH, 09h
    LEA DX, MSG_X
    INT 21h                     ;imprime a mensagem 'Digite um valor para X (operando): ' na tela

    CALL ENTDEC                 ;chama subrotina ENTDEC
    MOV CX, AX                  ;move o valor de AX para CX

    MUL CL                      ;multiplica o valor de AL por CL, resultado final em AX

    PUSH AX                     ;salva na pilha o resultado final

    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;imprime a mensagem 'RESULTADO: ', na tela

    POP AX                      ;restaura o valor presente na pilha em AX
    CALL SAIDEC                 ;chama subrotina SAIDEC
    RET
OP_POW_X_2 ENDP

OP_POW_10_Y PROC
    MOV AH, 09h
    LEA DX, MSG_EXPOENTE
    INT 21h                     ;imprime a mensagem 'Digite o valor do expoente: ' na tela
    CALL ENTDEC                 ;chama subrotina ENTDEC

    MOV CX, AX                  ;move o valor de AX para CX (contador do LOOP)
    SUB CX, 0001H               ;subtrai o valor de 1 de CX (se o expoente for 2, por exemplo, vai haver apenas uma multiplicação - 10x10)
    CMP CX, 0000H               ;compara se CX é igual a zero
    JE EXP_1                    ;se for, pula para EXP_1
    XOR AX, AX                  ;zera AX -> vai acumular o resultado

    MOV AX, 00001010B           ;move o valor de 10 para AX
    MOV BX, AX                  ;move o valor de AX para BX (segundo operando)

    OPERACAO_POW_10:
        MUL BL                  ;multiplica AL por BL
        LOOP OPERACAO_POW_10    ;LOOP até CX = 0

    PUSH AX                     ;salva na pilha o valor de AX

    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;imprime na tela a mensagem 'RESULTADO: '

    POP AX                      ;restaura o valor na pilha em AX
    CALL SAIDEC                 ;chama subrotina SAIDEC
    JMP FINAL                   ;pula para o FINAL

    EXP_1:                      ;caso o expoente seja 1
        MOV AX, 00001010B       ;move o valor de 10 para AX
        PUSH AX                 ;salva o valor de AX na pilha

        MOV AH, 09h
        LEA DX, MSG_RES
        INT 21h                 ;imprime a mensagem 'RESULTADO: ' na tela

        POP AX                  ;restaura o valor da pilha em AX
        CALL SAIDEC             ;chama subrotina SAIDEC
    FINAL:
        RET                     ;retorna
OP_POW_10_Y ENDP

DECIMAL_BINARIO PROC
    MOV AH, 09h
    LEA DX, MSG_DECIMAL
    INT 21h                     ;imprime a mensagem: 'Digite um nímero decimal: ' na tela

    CALL ENTDEC                 ;chama subrotina ENTDEC
    PUSH AX                     ;salva o valor de AX na pilha

    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;imprime a mensagem: 'RESULTADO: ' na tela

    POP BX                      ;restaura o valor da pilha em BX
    CALL SAIBIN                 ;chama subrotina SAIBIN
    RET
DECIMAL_BINARIO ENDP

BINARIO_DECIMAL PROC
    MOV AH, 09h
    LEA DX, MSG_BINARIO
    INT 21h                     ;exibe a mensagem 'Digite um numero binário: ' na tela

    CALL ENTBIN                 ;chama subrotina ENTBIN
    PUSH BX                     ;salva o valor de BX na pilha

    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;exibe a mensagem 'RESULTADO: ', na tela

    POP AX                      ;restaura o valor da pilha em AX
    CALL SAIDEC                 ;chama subrotina SAIDEC
    RET
BINARIO_DECIMAL ENDP

SQUARE_ROOT PROC
    MOV AH, 09h
    LEA DX, MSG_RAIZ
    INT 21h                     ;imprime a mensagem 'Digite um radicando: '

    CALL ENTDEC                 ;chama subrotina ENTDEC
    XOR CX, CX                  ;zera CX (contador) -> representará, no final, a raiz quadrada
    MOV BX, 00000001B           ;move o valor de 1, em binário, para BX

    RESOLVENDO:
        SUB AX, BX              ;subtrai BX de AX
        INC CX                  ;incrementa CX
        ADD BX, 00000010B       ;soma 2, em binário, em BX
        CMP AX, 0000H           ;compara AX com 0
        JG RESOLVENDO           ;se for maior do que 0 pula para RESOLVENDO -> a operação ainda não terminou
        CMP AX, 0000H           ;compara AX com 0
        JB MENOR                ;se for menor pula para MENOR -> o radicando não possui raiz perfeita
        CMP AX, 0000H           ;compara AX com 0
        JE ACABOU               ;se for igual pula para ACABOU -> a operação finalizou
    
    MENOR:
        MOV AH, 09h
        LEA DX, MSG_RAIZ_MENOR
        INT 21h                 ;imprime a mensagem '- O radicando nao possui raiz perfeita'
        JMP FIM_2               ;pula para o final do procedimento

    ACABOU:
        MOV AX, CX              ;move o valor de CX para AX
        PUSH AX                 ;salva o valor de AX na pilha         

        MOV AH, 09h     
        LEA DX, MSG_RES
        INT 21h                 ;exibe a mensagem 'RESULTADO: ', na tela

        POP AX                  ;restaura o valor da pilha em AX
        CALL SAIDEC             ;chama subrotina SAIDEC
    FIM_2:
        RET                     ;retorna
SQUARE_ROOT ENDP

OPPORCENTAGEM PROC
    MOV AH, 09h
    LEA DX, MSG_W
    INT 21h                     ;imprime a mensagem 'Digite um valor para W: ' na tela

    CALL ENTDEC                 ;chama subrotina ENTDEC
    MOV BX, AX                  ;move o valor de AX para BX
    XOR AX, AX                  ;zera AX
    MOV AX, 01100100B           ;passa o valor de 100, em binário, para AX 

    DIV BL                      ;divide W por 100
    PUSH AX                     ;salva o resultado na pilha (tanto o quociente quanto o resto)

    MOV AH, 09h
    LEA DX, MSG_Y_2
    INT 21h                     ;imprime a mensagem 'Digite um valor para Y: ' na tela

    POP BX                      ;restaura o que está na pilha em BX

    CALL ENTDEC                 ;chama subrotina ENTDEC

    DIV BL                      ;divide Y pelo resultado da divisão de W por 100
    PUSH AX                     ;salva o valor de AX na pilha

    MOV AH, 09h     
    LEA DX, MSG_RES
    INT 21h                     ;exibe a mensagem 'RESULTADO: ', na tela

    POP AX                      ;restaura o valor da pilha em AX
    CALL SAIDEC                 ;chama subrotina SAIDEC
    RET
OPPORCENTAGEM ENDP

OPLOG PROC
    MOV AH, 09h
    LEA DX, MSG_LOGARIT
    INT 21h                     ;exibe a mensagem 'Digite um logaritmando: ', na tela

    CALL ENTDEC                 ;chama subrotina ENTDEC
    CMP AX, 00001010B           ;conpara AX (logaritmando) com 10
    JB MENOR_QUE_10             ;pula se for menor
    MOV SI, AX                  ;move o valor de AX para SI

    MOV BX, 00001010B           ;move o valor de 10 para BX (representa a base do log)
    MOV CX, 1                   ;move o valor de 1 para CX
    XOR AX, AX                  ;zera AX
    MOV AX, BX                  ;move o valor de 10 para AX
    PRIMEIRA_PARTE:
        CMP SI, BX              ;compara para ver se a base é igual ao logaritmando
        JE FINALIZOU            ;se sim, já finaliza
    SEGUNDA_PARTE:
        MUL BL                  ;multiplica AL por BL
        INC CX                  ;incrementa CX
        CMP SI, AX              ;compara para ver se finaliza
        JNE SEGUNDA_PARTE       ;se não for igual quer dizer que não finalizou, pula novamente para SEGUNDA_PARTE

    FINALIZOU:
        MOV AH, 09h
        LEA DX, MSG_RES
        INT 21h                 ;exibe na tela a mensagem 'RESULTADO:'

        MOV DX, CX
        OR DL, 30h
        MOV AH, 02h
        INT 21h                 ;print do caracter que representa o logaritmo
        JMP ULTIMA_PARTE        ;pula para o retorno

    MENOR_QUE_10:
        CMP AX, 00000001B       ;compara para ver se o logaritmando é um
        JE UM                   ;pula se sim
        CMP AX, 00000010B       ;compara para ver se o logaritmando é dois
        JE DOIS                 ;pula se sim
        CMP AX, 00000011B       ;compara para ver se o logaritmando é tres
        JE TRES                 ;pula se sim
        CMP AX, 00000101B       ;compara para ver se o logaritmando é cinco
        JE CINCO                ;pula se sim
        UM:
            MOV AH, 09h
            LEA DX, MSG_RES
            INT 21h             ;exibe na tela a mensagem 'RESULTADO:'

            LEA DX, MSG_1
            INT 21h             ;print do valor de log de 1
            JMP ULTIMA_PARTE    ;pula para o retorno
        DOIS:
            MOV AH, 09h
            LEA DX, MSG_RES
            INT 21h             ;exibe na tela a mensagem 'RESULTADO:'

            LEA DX, MSG_2
            INT 21h             ;print do valor de log de 2
            JMP ULTIMA_PARTE    ;pula para o retorno
        TRES:
            MOV AH, 09h
            LEA DX, MSG_RES
            INT 21h             ;exibe na tela a mensagem 'RESULTADO:'

            LEA DX, MSG_3
            INT 21h             ;print do valor de log de 3
            JMP ULTIMA_PARTE    ;pula para o retorno
        CINCO:
            MOV AH, 09h
            LEA DX, MSG_RES
            INT 21h             ;exibe na tela a mensagem 'RESULTADO:'

            LEA DX, MSG_5
            INT 21h             ;print do valor de log de 5
            JMP ULTIMA_PARTE    ;pula para o retorno
    ULTIMA_PARTE:
        RET                     ;retorno
OPLOG ENDP

SAIDEC_MOD PROC                 ;procedimento usado na operação de módulo
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX                     ;salva na pilha os registradores usados
    OR AX,AX                    ;prepara comparação de sinal
    JGE PT1_v3                  ;se AX maior ou igual a 0, vai para PT1
    NEG AX                      ;troca o sinal de AX
    PT1_v3:
        XOR CX,CX               ;inicializa CX como contador de dígitos
        MOV BX,10               ;BX possui o divisor
    PT2_v3:
        XOR DX,DX               ;inicializa o byte alto do dividendo em 0; restante é AX
        DIV BX                  ;após a execução, AX = quociente; DX = resto
        PUSH DX                 ;salva o primeiro dígito decimal na pilha (1o. resto)
        INC CX                  ;contador = contador + 1
        OR AX,AX                ;quociente = 0 ? (teste de parada)
        JNE PT2_v3              ;não, continuamos a repetir o laço
        ;exibindo os dígitos decimais (restos) no monitor, na ordem inversa
        MOV AH,2h               ;sim, termina o processo, prepara exibição dos restos
    PT3_v3: 
        POP DX                  ;recupera dígito da pilha colocando-o em DL (DH = 0)
        ADD DL,30h              ;converte valor binário do dígito para caracter ASCII
        INT 21h                 ;exibe caracter
        LOOP PT3_v3             ;realiza o loop ate que CX = 0
        POP DX                  ;restaura o conteúdo dos registros
        POP CX
        POP BX
        POP AX                  ;restaura os conteúdos dos registradores
    RET                         ;retorna à rotina que chamou
SAIDEC_MOD ENDP

OPMODULO PROC
    MOV AH, 09h
    LEA DX, MSG_M
    INT 21h                     ;exibe a mensagem 'Digite um valor para N:' na tela 

    CALL ENTDEC                 ;chama subrotina ENTDEC

    PUSH AX                     ;salva o valor de AX na pilha
    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;exibe a mensagem 'RESULTADO:' na tela
    POP AX                      ;restaura o valor da pilha em AX

    CALL SAIDEC_MOD             ;chama subrotina SAIDEC_MOD
    RET
OPMODULO ENDP

DECIMAL_HEXA PROC
    MOV AH, 09h
    LEA DX, MSG_DECIMAL
    INT 21h                     ;exibe a mensagem 'Digite um número decimal:' na tela

    CALL ENTDEC                 ;chama subrotina ENTDEC
    MOV BX, AX                  ;move o valor de AX para BX

    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;exibe a mensagem 'RESULTADO:' na tela

    CALL SAIHEX                 ;chama subrotina SAIHEX
    RET
DECIMAL_HEXA ENDP

HEXA_DECIMAL PROC
    MOV AH, 09h
    LEA DX, MSG_HEXA
    INT 21h                     ;exibe a mensagem 'Digite um número hexadecimal:' na tela

    CALL ENTHEX                 ;chama subrotina ENTHEX
    MOV AX, BX                  ;move o valor de BX para AX

    PUSH AX                     ;salva o valor de AX na pilha
    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;exibe a mensagem 'RESULTADO:' na tela
    POP AX                      ;restaura o que está na pilha em AX

    CALL SAIDEC                 ;chama subrotina SAIDEC
    RET
HEXA_DECIMAL ENDP

BIN_HEXA PROC
    MOV AH, 09h
    LEA DX, MSG_BINARIO
    INT 21h                     ;exibe a mensagem 'Digite um número binário' na tela

    CALL ENTBIN                 ;chama subrotina ENTBIN

    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;exibe a mensagem 'RESULTADO: ', na tela

    CALL SAIHEX                 ;chama subrotina SAIDEC
    RET
BIN_HEXA ENDP

HEXA_BIN PROC
    MOV AH, 09h
    LEA DX, MSG_HEXA
    INT 21h                     ;exibe a mensagem: 'Digite um número hexadecimal' na tela

    CALL ENTHEX                 ;chama subrotina ENTHEX

    MOV AH, 09h
    LEA DX, MSG_RES
    INT 21h                     ;exibe a mensagem: 'RESULTADO:' na tela

    CALL SAIBIN                 ;chama subrotina SAIBIN
    RET
HEXA_BIN ENDP

CONTINUAR_ASK PROC
    MOV AH, 09h
    LEA DX, MSG_CONTINUAR
    INT 21h                     ;exibe a mensagem continuar?

    MOV AH, 01h                 ;lendo um caractere
    INT 21h

    CMP AL, 115                 ;comparando o caractere lido com 'S'
    JE  MENU                    ;se não for igual, pula a exit -> usuário deseja sair do programa
    JMP EXIT                    ;se for igual, pula para o menu de escolha
CONTINUAR_ASK ENDP

PRINCIPAL PROC
    MOV AX,@DATA                ;inicializando os registradores
    MOV DS,AX
    MOV ES,AX
MENU:
    CALL MENU_CALC              ;chama a subrotina MENU_CALC

COMPARE:
    CMP AL,97                   ;verifica se será realizada a operação de soma
    JE SOMA                     ;pula caso sim, continua se não

    CMP AL,98                   ;verifica se será realizada a operação de subtração
    JE SUBTRACAO                ;pula caso sim, continua se não

    CMP AL,99                   ;verifica se será realizada a operação de multiplicação
    JE MULTIPLICACAO            ;pula caso sim, continua se não

    CMP AL,100                  ;verifica se será realizada a operação de divisão
    JE DIVISAO                  ;pula caso sim

    CMP AL,101                  ;verifica se será realizada a operação de exponencial
    JE EXPONENCIAL              ;pula caso sim

    CMP AL,102                  ;verifica se será realizada a operação de elevado a 2
    JE POW_X_2                  ;pula caso sim

    CMP AL,103                  ;verifica se será realizada a operação de 10 elevado a Y
    JE POW_10_Y                 ;pula caso sim

    CMP AL,104                  ;verifica se será realizada a operação de logaritmo
    JE LOGARITMO                ;pula caso sim

    CMP AL,105                  ;verifica se será realizada a operação de módulo
    JE MODULO                   ;pula caso sim

    CMP AL,106                  ;verifica se será realizada a operação de raiz quadrada
    JE RAIZ_QUADRADA            ;pula caso sim

    CMP AL,107                  ;verifica se será realizada a operação de porcentagem
    JE PORCENTAGEM              ;pula caso sim

    CMP AL,108                  ;verifica se será realizada a operação de conversão DEC-BIN
    JE C_DEC_BIN                ;pula caso sim

    CMP AL,109                  ;verifica se será realizada a operação de conversão BIN-DEC
    JE C_BIN_DEC                ;pula caso sim

    CMP AL,110                  ;verifica se será realizada a operação de conversão DEC-HEX
    JE C_DEC_HEX                ;pula caso sim

    CMP AL,111                  ;verifica se será realizada a operação de conversão HEX-DEC
    JE C_HEX_DEC                ;pula caso sim

    CMP AL,112                  ;verifica se será realizada a operação de conversão BIN-HEX
    JE C_BIN_HEX                ;pula caso sim

    CMP AL,113                  ;verifica se será realizada a operação de conversão HEX-BIN
    JE C_HEX_BIN                ;pula caso sim

    CMP AL,48                   ;verifica se o programa será encerrado
    JNE MENU                    ;caso o caractere digitado não seja entre 0 e 8, é exibido a mensagem menu
    JMP EXIT                    ;se sim, o programa acaba

SOMA: 
    CALL OPSOMA                 ;chama subrotina OPSOMA
    CALL CONTINUAR_ASK          ;chama subrotina CONTINUAR_ASK

SUBTRACAO:
    CALL OPSUB                  ;chama subrotina OPSUB
    CALL CONTINUAR_ASK          ;chama subrotina CONTINUAR_ASK

MULTIPLICACAO:
    CALL OPMULT                 ;chama subrotina OPMULT
    CALL CONTINUAR_ASK          ;chama subrotina CONTINUAR_ASK

DIVISAO:
    CALL OPDIV                  ;chama subrotina OPDIV
    CALL CONTINUAR_ASK          ;chama subrotina CONTINUAR_ASK

EXPONENCIAL:
    CALL OPEXPONENCIAL          ;chama subrotina OPEXPONENCIAL
    CALL CONTINUAR_ASK          ;chama subrotina CONTINUAR_ASK

POW_X_2:
    CALL OP_POW_X_2             ;chama subrotina OP_POW_X_2
    CALL CONTINUAR_ASK          ;chama subrotina CONTINUAR_ASK

POW_10_Y:
    CALL OP_POW_10_Y            ;chama subrotina OP_POW_10_Y
    CALL CONTINUAR_ASK          ;chama subrotina CONTINUAR_ASK

C_DEC_BIN:
    CALL DECIMAL_BINARIO        ;chama a subrotina SAIBIN
    CALL CONTINUAR_ASK          ;chama subrotina CONTINUAR_ASK

C_BIN_DEC:
    CALL BINARIO_DECIMAL        ;chama subrotina BINARIO_DECIMAL
    CALL CONTINUAR_ASK          ;chama a subrotina CONTINUAR_ASK

RAIZ_QUADRADA:
    CALL SQUARE_ROOT            ;chama subrotina SQUARE_ROOT
    CALL CONTINUAR_ASK          ;chama a subrotina CONTINUAR_ASK

PORCENTAGEM:
    CALL OPPORCENTAGEM          ;chama a subrotina OPPORCENTAGEM
    CALL CONTINUAR_ASK          ;chama a subrotina CONTINUAR_ASK

LOGARITMO:
    CALL OPLOG                  ;chama subrotina OPLOG
    CALL CONTINUAR_ASK          ;chama a subrotina CONTINUAR_ASK

MODULO:
    CALL OPMODULO               ;chama a subrotina OPMODULO
    CALL CONTINUAR_ASK          ;chama a subrotina CONTINUAR_ASK

C_DEC_HEX:
    CALL DECIMAL_HEXA           ;chama a subrotina DECIMAL_HEXA
    CALL CONTINUAR_ASK          ;chama a subrotina CONTINUAR_ASK

C_HEX_DEC:
    CALL HEXA_DECIMAL           ;chama a subrotina HEXA-DECIMAL
    CALL CONTINUAR_ASK          ;chama a subrotina CONTINUAR_ASK

C_BIN_HEX:
    CALL BIN_HEXA               ;chama a subrotina BIN_HEXA
    CALL CONTINUAR_ASK          ;chama a subrotina CONTINUAR

C_HEX_BIN:
    CALL HEXA_BIN               ;chama a subrotina HEXA_BIN
    CALL CONTINUAR_ASK          ;chama a subrotina CONTINUAR_ASK

EXIT:
    MOV AH,4Ch                  ;fim do programa -> saída para o DOS
    INT 21h
PRINCIPAL ENDP
END PRINCIPAL