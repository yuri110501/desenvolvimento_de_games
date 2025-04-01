# Jogo do Marciano

## Descrição
O Jogo do Marciano é um jogo educativo desenvolvido em Processing que implementa uma versão visual e interativa do jogo de adivinhação. O objetivo é encontrar um marciano que está escondido em uma das 100 árvores numeradas, usando o conceito de busca por maior ou menor número.

## Requisitos
- Processing IDE
- Java Runtime Environment (JRE)

## Instalação
1. Baixe e instale o Processing IDE do site oficial: https://processing.org/download/
2. Clone ou baixe este repositório
3. Abra o arquivo `sketch_250331a.pde` no Processing IDE
4. Clique no botão "Run" (ícone de play) para executar o jogo

## Como Jogar
1. O marciano se esconde em uma árvore aleatória (numerada de 1 a 100)
2. Digite um número para adivinhar em qual árvore o marciano está
3. O jogo fornecerá dicas se o número correto é maior ou menor
4. Continue tentando até encontrar o marciano
5. Quando encontrar, o marciano aparecerá e a árvore será destacada
6. Pressione 'R' para jogar novamente

## Controles
- **Teclas numéricas (0-9)**: Digite o número da árvore
- **ENTER**: Confirma sua tentativa
- **BACKSPACE**: Apaga a tentativa atual
- **R**: Reinicia o jogo

## Características do Jogo

### Interface Visual
- Céu com gradiente
- Sol animado
- 100 árvores numeradas com efeitos de sombreamento
- Marciano animado com efeitos de brilho
- Painel de informações semi-transparente
- Feedback visual para acertos

### Elementos do Jogo
1. **Árvores**
   - Organizadas em grade 10x10
   - Cada árvore possui:
     - Sombra
     - Tronco com gradiente
     - Copa com gradiente
     - Número identificador
     - Destaque especial quando é a árvore correta

2. **Marciano**
   - Corpo verde circular
   - Olhos com pupilas
   - Antenas com efeitos visuais
   - Efeito de brilho ao redor

3. **Interface do Usuário**
   - Painel de informações
   - Mensagens de feedback
   - Contador de tentativas
   - Número sendo digitado
   - Instruções de reinício

## Aspectos Educacionais
O jogo trabalha conceitos importantes como:
- Números e contagem (1-100)
- Comparação de valores (maior/menor)
- Estratégia de busca
- Feedback visual e textual
- Persistência e tentativa/erro

## Estrutura do Código

### Variáveis Globais
- `arvoreMarciano`: Posição do marciano
- `tentativaAtual`: Número sendo digitado
- `numeroTentativas`: Contador de tentativas
- `mensagem`: Feedback para o jogador
- `jogoTerminado`: Estado do jogo
- Variáveis de cores para personalização

### Funções Principais
1. `setup()`: Inicialização do jogo
2. `iniciarJogo()`: Reinicia o jogo
3. `draw()`: Renderização principal
4. `desenharInterface()`: Interface do usuário
5. `desenharArvores()`: Renderização das árvores
6. `desenharMarciano()`: Renderização do marciano
7. `keyPressed()`: Gerenciamento de entrada

## Desenvolvimento
O jogo foi desenvolvido em Processing, uma linguagem e IDE específica para criar aplicações visuais, gráficos e animações.

## Contribuições
Contribuições são bem-vindas! Sinta-se à vontade para:
1. Fazer um fork do projeto
2. Criar uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abrir um Pull Request

## Licença
Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes. 