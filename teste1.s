.global _start

.data
    .align 3
    const_3_14: .double 3.14
    .align 3
    const_2_0: .double 2.0
    .align 3
    const_10: .double 10
    .align 3
    const_3: .double 3
    .align 3
    const_8: .double 8
    .align 3
    const_1_0: .double 1.0
    .align 3
    const_1: .double 1
    .align 3
    const_5_0: .double 5.0
    .align 3
    mem_VAR: .double 0.0
    .align 3
    const_10_0: .double 10.0
    .align 3
    const_0_0: .double 0.0
    .align 3
    mem_RESULTADO: .double 0.0
    .align 3
    resultados: .space 800       @ espaço para 100 doubles
    numResultados: .word 0

.text
_start:

    @ (START) - início do programa

 @ Comando RPN: ( 3.14 2.0 + ) 
    LDR R4, =const_3_14
    VLDR D0, [R4]        @ carrega double 3.14
    LDR R4, =const_2_0
    VLDR D1, [R4]        @ carrega double 2.0
    VADD.F64 D2, D0, D1    @ D0 + D1
    @ Armazena resultado no histórico
    LDR R0, =numResultados
    LDR R1, [R0]                @ R1 = numResultados atual
    LDR R2, =resultados
    LSL R3, R1, #3              @ offset = R1 * 8
    ADD R2, R2, R3
    VSTR D2, [R2]               @ guarda resultado
    ADD R1, R1, #1
    STR R1, [R0]                @ numResultados++

 @ Comando RPN: ( 10 3 / ) 
    LDR R4, =const_10
    VLDR D0, [R4]        @ carrega double 10
    LDR R4, =const_3
    VLDR D1, [R4]        @ carrega double 3
    VDIV.F64 D2, D0, D1    @ divisão inteira
    VCVT.S32.F64 S31, D2    @ trunca para inteiro
    VCVT.F64.S32 D2, S31    @ volta para double
    @ Armazena resultado no histórico
    LDR R0, =numResultados
    LDR R1, [R0]                @ R1 = numResultados atual
    LDR R2, =resultados
    LSL R3, R1, #3              @ offset = R1 * 8
    ADD R2, R2, R3
    VSTR D2, [R2]               @ guarda resultado
    ADD R1, R1, #1
    STR R1, [R0]                @ numResultados++

 @ Comando RPN: ( 10 3 % ) 
    LDR R4, =const_10
    VLDR D0, [R4]        @ carrega double 10
    LDR R4, =const_3
    VLDR D1, [R4]        @ carrega double 3
    @ resto: D0 % D1
    VDIV.F64 D2, D0, D1
    VCVT.S32.F64 S31, D2
    VCVT.F64.S32 D2, S31
    VMUL.F64 D2, D2, D1
    VSUB.F64 D2, D0, D2    @ resto
    @ Armazena resultado no histórico
    LDR R0, =numResultados
    LDR R1, [R0]                @ R1 = numResultados atual
    LDR R2, =resultados
    LSL R3, R1, #3              @ offset = R1 * 8
    ADD R2, R2, R3
    VSTR D2, [R2]               @ guarda resultado
    ADD R1, R1, #1
    STR R1, [R0]                @ numResultados++

 @ Comando RPN: ( 2.0 8 ^ ) 
    LDR R4, =const_2_0
    VLDR D0, [R4]        @ carrega double 2.0
    LDR R4, =const_8
    VLDR D1, [R4]        @ carrega double 8
    @ potenciação: D0 ^ D1
    VCVT.S32.F64 S31, D1
    VMOV R0, S31              @ R0 = expoente
    LDR R4, =const_1_0
    VLDR D2, [R4]    @ resultado = 1.0
potencia_0:
    CMP R0, #0
    BLE potencia_0_fim
    VMUL.F64 D2, D2, D0
    SUB R0, R0, #1
    B potencia_0
potencia_0_fim:
    @ Armazena resultado no histórico
    LDR R0, =numResultados
    LDR R1, [R0]                @ R1 = numResultados atual
    LDR R2, =resultados
    LSL R3, R1, #3              @ offset = R1 * 8
    ADD R2, R2, R3
    VSTR D2, [R2]               @ guarda resultado
    ADD R1, R1, #1
    STR R1, [R0]                @ numResultados++

 @ Comando RPN: ( 1 RES ) 
    LDR R4, =const_1
    VLDR D0, [R4]        @ carrega double 1
    @ RES: acessa resultado anterior (total - N)
    VCVT.S32.F64 S31, D0
    VMOV R0, S31                @ R0 = N inteiro
    LDR R1, =resultados
    LDR R2, =numResultados
    LDR R2, [R2]                @ R2 = contador total
    SUB R2, R2, R0              @ indice = total - N
    LSL R2, R2, #3              @ offset em bytes (double = 8 bytes)
    ADD R1, R1, R2              @ R1 = endereço de resultados[indice]
    VLDR D1, [R1]        @ resgata o valor para D1
    @ Armazena resultado no histórico
    LDR R0, =numResultados
    LDR R1, [R0]                @ R1 = numResultados atual
    LDR R2, =resultados
    LSL R3, R1, #3              @ offset = R1 * 8
    ADD R2, R2, R3
    VSTR D1, [R2]               @ guarda resultado
    ADD R1, R1, #1
    STR R1, [R0]                @ numResultados++

 @ Comando RPN: ( 5.0 VAR ) 
    LDR R4, =const_5_0
    VLDR D0, [R4]        @ carrega double 5.0
    LDR R0, =mem_VAR        @ store em VAR
    VSTR D0, [R0]

 @ Comando RPN: ( VAR ) 
    LDR R0, =mem_VAR        @ load de VAR
    VLDR D0, [R0]
    @ Armazena resultado no histórico
    LDR R0, =numResultados
    LDR R1, [R0]                @ R1 = numResultados atual
    LDR R2, =resultados
    LSL R3, R1, #3              @ offset = R1 * 8
    ADD R2, R2, R3
    VSTR D0, [R2]               @ guarda resultado
    ADD R1, R1, #1
    STR R1, [R0]                @ numResultados++

    @ WHILE - início do loop
while_1:
    @ Avalia condição do WHILE

 @ Comando RPN: ( VAR 10.0 < ) 
    LDR R0, =mem_VAR        @ load de VAR
    VLDR D0, [R0]
    LDR R4, =const_10_0
    VLDR D1, [R4]        @ carrega double 10.0
    @ comparação relacional '<': D0 < D1
    VCMP.F64 D0, D1
    VMRS APSR_nzcv, FPSCR
    BLT rel_verdade_2
    LDR R4, =const_0_0
    VLDR D2, [R4]        @ false
    B rel_fim_3           @ foge do bloco verdade
rel_verdade_2:
    LDR R4, =const_1_0
    VLDR D2, [R4]        @ true
rel_fim_3:
    @ Armazena resultado no histórico
    LDR R0, =numResultados
    LDR R1, [R0]                @ R1 = numResultados atual
    LDR R2, =resultados
    LSL R3, R1, #3              @ offset = R1 * 8
    ADD R2, R2, R3
    VSTR D2, [R2]               @ guarda resultado
    ADD R1, R1, #1
    STR R1, [R0]                @ numResultados++
    LDR R4, =const_0_0
    VLDR D15, [R4]              @ 0.0 para comparação
    VCMP.F64 D2, D15
    VMRS APSR_nzcv, FPSCR
    BEQ while_1_fim             @ se condição == 0.0 (falso), sai do loop
    @ Corpo do WHILE

 @ Comando RPN: ( VAR 1.0 + VAR ) 
    LDR R0, =mem_VAR        @ load de VAR
    VLDR D0, [R0]
    LDR R4, =const_1_0
    VLDR D1, [R4]        @ carrega double 1.0
    VADD.F64 D2, D0, D1    @ D0 + D1
    LDR R0, =mem_VAR        @ store em VAR
    VSTR D2, [R0]
    B while_1               @ volta ao início do loop
while_1_fim:

    @ IF - Avalia condição

 @ Comando RPN: ( VAR 5.0 > ) 
    LDR R0, =mem_VAR        @ load de VAR
    VLDR D0, [R0]
    LDR R4, =const_5_0
    VLDR D1, [R4]        @ carrega double 5.0
    @ comparação relacional '>': D0 > D1
    VCMP.F64 D0, D1
    VMRS APSR_nzcv, FPSCR
    BGT rel_verdade_6
    LDR R4, =const_0_0
    VLDR D2, [R4]        @ false
    B rel_fim_7           @ foge do bloco verdade
rel_verdade_6:
    LDR R4, =const_1_0
    VLDR D2, [R4]        @ true
rel_fim_7:
    @ Armazena resultado no histórico
    LDR R0, =numResultados
    LDR R1, [R0]                @ R1 = numResultados atual
    LDR R2, =resultados
    LSL R3, R1, #3              @ offset = R1 * 8
    ADD R2, R2, R3
    VSTR D2, [R2]               @ guarda resultado
    ADD R1, R1, #1
    STR R1, [R0]                @ numResultados++
    LDR R4, =const_0_0
    VLDR D15, [R4]              @ 0.0 para comparação
    VCMP.F64 D2, D15
    VMRS APSR_nzcv, FPSCR
    BEQ if_else_4            @ se falso (0.0), pula pro else
    @ IF - Bloco THEN (Verdadeiro)

 @ Comando RPN: ( 1.0 RESULTADO ) 
    LDR R4, =const_1_0
    VLDR D0, [R4]        @ carrega double 1.0
    LDR R0, =mem_RESULTADO        @ store em RESULTADO
    VSTR D0, [R0]
    B if_fim_5               @ fim do then, pula o else
if_else_4:
    @ IF - Bloco ELSE (Falso)

 @ Comando RPN: ( 0.0 RESULTADO ) 
    LDR R4, =const_0_0
    VLDR D0, [R4]        @ carrega double 0.0
    LDR R0, =mem_RESULTADO        @ store em RESULTADO
    VSTR D0, [R0]
if_fim_5:

 @ Comando RPN: ( VAR ) 
    LDR R0, =mem_VAR        @ load de VAR
    VLDR D0, [R0]
    @ Armazena resultado no histórico
    LDR R0, =numResultados
    LDR R1, [R0]                @ R1 = numResultados atual
    LDR R2, =resultados
    LSL R3, R1, #3              @ offset = R1 * 8
    ADD R2, R2, R3
    VSTR D0, [R2]               @ guarda resultado
    ADD R1, R1, #1
    STR R1, [R0]                @ numResultados++

    @ (END) - fim do programa

    @ Fim do programa
fim:
    B fim
