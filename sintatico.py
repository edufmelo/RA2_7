"""
Integrantes do grupo (ordem alfabética):
- Daniel de Almeida Santos Bina - @danielbina
- Eduardo Ferreira de Melo - @edufmelo
- João Eduardo Faccin Leineker - @joaooleineker

- Nome do grupo no Canvas: RA2 7
"""
import sys

# Importamos o analisador da Fase 1 para ler o arquivo e extrair os tokens.
# Renomeamos de "analisador.py" para "lexico.py" para evitar confusão com o de análise sintática.
from lexico import Token, lerArquivo, parseExpressao, salvarArquivo

def gerarTokens(linhas_brutas):
    linhas_tokens = []

    for linha in linhas_brutas:
        vetor_tokens = []
        
        # Gera os tokens usando léxico -> armazena em vetor_tokens
        parseExpressao(linha, vetor_tokens)
        
        if vetor_tokens:
            # Formata -> TIPO:VALOR
            tokens_formatados = []
            for token in vetor_tokens:
                print(f"Token gerado: Tipo='{token.tipo}', Valor='{token.valor}'") # debug para ver os tokens gerados
                tokens_formatados.append(f"{token.tipo}:{token.valor}")
            
            # Junta com espaços e adiciona a lista de linhas de tokens
            linha_completa = " ".join(tokens_formatados)
            linhas_tokens.append(linha_completa)

    # Utiliza função do léxico para salvar o arquivo tokens.txt
    salvarArquivo('tokens.txt', linhas_tokens)

def lerTokens(nome_arquivo):
    lista_de_linhas = []
    
    try:
        with open(nome_arquivo, 'r') as arquivo_texto: # with -> garante que o arquivo será fechado
            for linha_bruta in arquivo_texto:
                # Validação extra (analisar necessidade depois)
                linha_limpa = linha_bruta.strip() # remove espaços em branco (como implementado no léxico)
                if not linha_limpa:
                    continue # pula linhas vazias
            
                tokens_da_linha = []
                
                # Divide a linha pelos espaços para pegar cada "TIPO:VALOR"
                pedacos_de_texto = linha_limpa.split(' ')
                
                for pedaco in pedacos_de_texto:
                    # Divide entre tipo e valor usando o separador ":"
                    if ':' in pedaco:
                        tipo_extraido, valor_extraido = pedaco.split(':', 1)
                        
                        # Cria o objeto Token (usando a classe importada do lexico.py)
                        novo_token = Token(tipo_extraido, valor_extraido)
                        tokens_da_linha.append(novo_token)
                
                if tokens_da_linha:
                    lista_de_linhas.append(tokens_da_linha)
                    
        return lista_de_linhas

    except FileNotFoundError:
        print(f"Erro: O arquivo '{nome_arquivo}' não foi encontrado.")
        sys.exit(1)
        
def construirGramatica():
    pass

def parsear():
    pass

def gerarArvore():
    pass

def main():
    if len(sys.argv) < 2:
        print("Uso: python sintatico.py <arquivo_teste>")
        return

    # Arquivo teste passado via terminal
    arquivo_codigo_fonte = sys.argv[1]
    
    linhas_brutas = []
    lerArquivo(arquivo_codigo_fonte, linhas_brutas)

    # Temos que gerar os tokens.txt a partir do arquivo teste passado via terminal do sintático
    gerarTokens(linhas_brutas) # gera o tokens.txt usando parseExpressao do léxico

    arquivo_tokens = 'tokens.txt' # nome fixo do arquivo de tokens gerado pela função acima
    tokens = lerTokens(arquivo_tokens)

    # Testes para debug dos tokens lidos
    print(f"Foram lidas {len(tokens)} linhas de código válidas.")
    
    if tokens:
        primeiro = tokens[0][1] # pega linha 0, token 1 -> KEYWORD_START:START (tipo, valor)
        print(f"Exemplo do 1º token da 1ª linha: [Tipo: {primeiro.tipo} | Valor: {primeiro.valor}]")
  
if __name__ == "__main__":
    main()