# Jogo da Velha (Tic-tac-toe)

## Visão Geral
Este é um jogo da velha (Tic-tac-toe) implementado em Processing, uma biblioteca Java para criação de gráficos, animações e interações. O jogo oferece duas modalidades: jogador contra jogador e jogador contra computador.

## Estrutura do Projeto
O projeto consiste em um único arquivo `sketch_250331a.pde` que contém toda a lógica do jogo.

## Componentes Principais

### 1. Variáveis Globais
- `tabuleiro[3][3]`: Matriz que representa o tabuleiro do jogo
  - 0 = célula vazia
  - 1 = X
  - 2 = O
- `vezDoX`: Controla de qual jogador é a vez
- `jogoTerminado`: Indica se o jogo acabou
- `modoComputador`: Define se está no modo jogador vs computador
- `menuAtivo`: Controla a exibição do menu de seleção
- Cores personalizadas para X (vermelho), O (azul) e elementos do tabuleiro

### 2. Funções Principais

#### Setup e Inicialização
- `setup()`: Configura a janela do jogo e carrega a fonte
- `iniciarJogo()`: Reseta o tabuleiro e as variáveis do jogo

#### Interface Gráfica
- `draw()`: Função principal de renderização
- `desenharMenu()`: Renderiza o menu de seleção de modo de jogo
- `desenharTabuleiro()`: Desenha o tabuleiro e as peças
- `desenharX()` e `desenharO()`: Renderizam as peças do jogo
- `desenharBotaoReiniciar()`: Desenha o botão para reiniciar o jogo

#### Lógica do Jogo
- `mousePressed()`: Processa os cliques do mouse
- `fazerJogada()`: Executa uma jogada no tabuleiro
- `verificarVitoria()`: Verifica se há um vencedor
- `verificarEmpate()`: Verifica se o jogo empatou

#### Inteligência Artificial
- `fazerJogadaComputador()`: Implementa a lógica do computador
- `encontrarJogadaVencedora()`: Procura uma jogada que leva à vitória
- `encontrarJogadaAleatoria()`: Seleciona uma jogada aleatória válida

## Funcionalidades

### 1. Modos de Jogo
- **1 vs 1**: Dois jogadores alternam jogadas
- **Jogador vs Computador**: Jogador joga contra a IA

### 2. Interface
- Menu de seleção de modo de jogo
- Tabuleiro visual com X's e O's
- Painel de informações mostrando a vez do jogador
- Botão de reiniciar jogo
- Fundo com gradiente
- Design moderno com cores contrastantes

### 3. Inteligência Artificial
O computador utiliza uma estratégia simples:
1. Procura uma jogada que leva à vitória
2. Se não encontrar, bloqueia uma jogada vencedora do oponente
3. Se não houver jogadas críticas, faz uma jogada aleatória

## Como Jogar
1. Ao iniciar, selecione o modo de jogo desejado
2. Clique em uma célula vazia para fazer sua jogada
3. O jogo alterna entre X e O
4. O jogo termina quando:
   - Um jogador vence (3 em linha)
   - O jogo empata (tabuleiro cheio)
5. Use o botão "Reiniciar Jogo" para começar uma nova partida

## Características Técnicas
- Desenvolvido em Processing
- Interface gráfica interativa
- Sistema de turnos
- Verificação de vitória e empate
- IA básica para o modo contra computador
- Design responsivo e visualmente agradável

## Requisitos
- Processing IDE instalado
- Java Runtime Environment (JRE)

## Como Executar
1. Abra o Processing IDE
2. Carregue o arquivo `sketch_250331a.pde`
3. Clique no botão "Run" (ícone de play) ou pressione Ctrl+R

## Contribuição
Sinta-se à vontade para contribuir com melhorias no código, adicionando novas funcionalidades ou otimizando a IA do computador.

## Licença
Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes. 