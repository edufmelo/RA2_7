# Gramática da Linguagem RPN — Análise LL(1)

## 1. Regras de Produção (EBNF)

Convenção: **MAIÚSCULAS** = terminais | **minúsculas** = não-terminais | **ε** = vazio

```
programa         ::= comando_lista
comando_lista    ::= comando comando_lista | ε
comando          ::= ABRE_PAREN conteudo_comando FECHA_PAREN

conteudo_comando ::= KEYWORD_START
                   | KEYWORD_END
                   | NUMERO sufixo_numero
                   | MEMORIA sufixo_memoria
                   | comando sufixo_comando

sufixo_numero    ::= KEYWORD_RES
                   | NUMERO operador_final
                   | MEMORIA apos_mem
                   | comando operador_final

sufixo_memoria   ::= NUMERO operador_final
                   | MEMORIA apos_mem
                   | comando operador_final
                   | ε

sufixo_comando   ::= NUMERO operador_final
                   | MEMORIA apos_mem
                   | comando apos_cmd
                   | ε

operador_final   ::= OPERADOR
                   | OPERADOR_REL

apos_mem         ::= OPERADOR
                   | OPERADOR_REL
                   | ε

apos_cmd         ::= OPERADOR
                   | OPERADOR_REL
                   | KEYWORD_WHILE
                   | comando KEYWORD_IF
```

### Terminais da linguagem:
| Token | Exemplo |
|---|---|
| ABRE_PAREN | `(` |
| FECHA_PAREN | `)` |
| NUMERO | `3.14`, `10`, `2.0` |
| OPERADOR | `+`, `-`, `*`, `/`, `%`, `^`, `\|` |
| OPERADOR_REL | `<`, `>`, `==`, `!=`, `<=`, `>=` |
| MEMORIA | `VAR`, `RESULTADO`, `CONT` |
| KEYWORD_START | `START` |
| KEYWORD_END | `END` |
| KEYWORD_RES | `RES` |
| KEYWORD_IF | `IF` |
| KEYWORD_WHILE | `WHILE` |
| $ | fim da entrada |

---

## 2. Conjuntos FIRST

| Não-terminal | FIRST |
|---|---|
| programa | { ABRE_PAREN, ε } |
| comando_lista | { ABRE_PAREN, ε } |
| comando | { ABRE_PAREN } |
| conteudo_comando | { KEYWORD_START, KEYWORD_END, NUMERO, MEMORIA, ABRE_PAREN } |
| sufixo_numero | { KEYWORD_RES, NUMERO, MEMORIA, ABRE_PAREN } |
| sufixo_memoria | { NUMERO, MEMORIA, ABRE_PAREN, ε } |
| sufixo_comando | { NUMERO, MEMORIA, ABRE_PAREN, ε } |
| operador_final | { OPERADOR, OPERADOR_REL } |
| apos_mem | { OPERADOR, OPERADOR_REL, ε } |
| apos_cmd | { OPERADOR, OPERADOR_REL, KEYWORD_WHILE, ABRE_PAREN } |

---

## 3. Conjuntos FOLLOW

| Não-terminal | FOLLOW |
|---|---|
| programa | { $ } |
| comando_lista | { $ } |
| comando | { ABRE_PAREN, $, NUMERO, MEMORIA, FECHA_PAREN, OPERADOR, OPERADOR_REL, KEYWORD_WHILE, KEYWORD_IF } |
| conteudo_comando | { FECHA_PAREN } |
| sufixo_numero | { FECHA_PAREN } |
| sufixo_memoria | { FECHA_PAREN } |
| sufixo_comando | { FECHA_PAREN } |
| operador_final | { FECHA_PAREN } |
| apos_mem | { FECHA_PAREN } |
| apos_cmd | { FECHA_PAREN } |

---

## 4. Tabela de Análise LL(1)

| Não-terminal | ABRE_PAREN | FECHA_PAREN | NUMERO | MEMORIA | OPERADOR | OPERADOR_REL | KW_START | KW_END | KW_RES | KW_IF | KW_WHILE | $ |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| programa | comando_lista | — | — | — | — | — | — | — | — | — | — | comando_lista |
| comando_lista | cmd cmd_lista | — | — | — | — | — | — | — | — | — | — | ε |
| comando | ( cont_cmd ) | — | — | — | — | — | — | — | — | — | — | — |
| conteudo_cmd | cmd sfx_cmd | — | NUM sfx_num | MEM sfx_mem | — | — | KW_START | KW_END | — | — | — | — |
| sufixo_num | cmd op_final | — | NUM op_final | MEM apos_mem | — | — | — | — | KW_RES | — | — | — |
| sufixo_mem | cmd op_final | ε | NUM op_final | MEM apos_mem | — | — | — | — | — | — | — | — |
| sufixo_cmd | cmd apos_cmd | ε | NUM op_final | MEM apos_mem | — | — | — | — | — | — | — | — |
| operador_final | — | — | — | — | OPERADOR | OP_REL | — | — | — | — | — | — |
| apos_mem | — | ε | — | — | OPERADOR | OP_REL | — | — | — | — | — | — |
| apos_cmd | cmd KW_IF | — | — | — | OPERADOR | OP_REL | — | — | — | — | KW_WHILE | — |

> **Observação:** Nenhuma célula possui mais de uma produção → gramática é LL(1) ✓

---

## 5. Exemplos de Derivação

### `(3.14 2.0 +)` — Expressão aritmética
```
comando → ( conteudo_comando )
        → ( NUMERO sufixo_numero )
        → ( 3.14 NUMERO operador_final )
        → ( 3.14 2.0 OPERADOR )
        → ( 3.14 2.0 + )
```

### `(1 RES)` — Comando RES
```
comando → ( conteudo_comando )
        → ( NUMERO sufixo_numero )
        → ( 1 KEYWORD_RES )
        → ( 1 RES )
```

### `((VAR 10.0 <) ((VAR 1.0 +) VAR) WHILE)` — Laço WHILE
```
comando → ( conteudo_comando )
        → ( comando sufixo_comando )
        → ( (VAR 10.0 <) comando apos_cmd )
        → ( (VAR 10.0 <) ((VAR 1.0 +) VAR) KEYWORD_WHILE )
```