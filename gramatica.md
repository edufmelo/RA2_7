# Gramática da Linguagem (EBNF) - Padrão feito em sala/slides

## Estrutura Principal
<programa> ::= <inicio_prog> <lista_comandos> <fim_prog>
<inicio_prog> ::= ABRE_PAREN KEYWORD_START FECHA_PAREN
<lista_comandos>  ::= <comando> <lista_comandos> | ε
<comando> ::= ABRE_PAREN <conteudo_comando> FECHA_PAREN

## Definição de Comando
<conteudo_comando> ::= <expr_matematica> | <atribuicao> | <comando_if> | <comando_while> | <comando_res> | MEMORIA

## Estruturas de Controle (RPN)
<comando_if> ::= <comando_cond> <comando_bloco> <comando_bloco> KEYWORD_IF
<comando_while> ::= <comando_cond> <comando_bloco> KEYWORD_WHILE

## Expressões e Condições
<comando_cond> ::= <comando>
<comando_bloco> ::= <comando>
<expr_matematica> ::= <termo> <termo> OPERADOR
<expr_relacional> ::= <termo> <termo> OPERADOR_REL
<termo> ::= NUMERO | MEMORIA | <comando>

## Outros
<atribuicao> ::= <termo> MEMORIA
<comando_res> ::= NUMERO KEYWORD_RES

### Obs.: 
- ε = vazio
- Maiúsculas = terminais *(tópico 28.7.1 7.1.)*
- Minúsculas = não-terminais *(tópico 28.7.1 7.1.)*