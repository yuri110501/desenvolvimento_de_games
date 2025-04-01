# Jogo da Forca em Processing

## Descrição
Este é um jogo da forca desenvolvido em Processing, uma linguagem de programação focada em criar aplicações visuais e interativas. O jogo oferece três níveis de dificuldade e uma interface gráfica moderna com efeitos visuais.

## Requisitos
- Processing IDE (versão 3.0 ou superior)
- Java Runtime Environment (JRE)

## Instalação
1. Baixe e instale o Processing IDE do site oficial: https://processing.org/download/
2. Clone ou baixe este repositório
3. Abra o arquivo `sketch_250331a.pde` no Processing IDE
4. Clique no botão "Run" (ícone de play) para executar o jogo

## Como Jogar
1. Ao iniciar o jogo, você verá três opções de nível:
   - Fácil: Palavras curtas e comuns
   - Médio: Palavras médias e um pouco mais complexas
   - Difícil: Palavras longas e mais complexas

2. Selecione um nível clicando no botão correspondente

3. O jogo começará mostrando:
   - A forca
   - A palavra a ser adivinhada (com underscores)
   - Seu número de vidas (6 no total)

4. Para jogar:
   - Digite uma letra usando seu teclado
   - Se a letra estiver na palavra, ela será revelada
   - Se a letra estiver errada, você perderá uma vida
   - Letras já usadas não podem ser repetidas

5. O jogo termina quando:
   - Você adivinha a palavra corretamente (vitória)
   - Você perde todas as vidas (derrota)

6. Após o fim do jogo, você pode:
   - Clicar no botão de engrenagem para voltar à seleção de nível
   - Reiniciar o jogo no mesmo nível

## Estrutura do Código

### Variáveis Globais
```java
String[][] palavras;      // Matriz com palavras por nível
String palavra;          // Palavra atual a ser adivinhada
String palavraAtual;     // Palavra com letras reveladas
ArrayList<Character> letrasUsadas;  // Letras já tentadas
ArrayList<Character> letrasErradas; // Letras incorretas
int vidas;              // Número de vidas restantes
```

### Funções Principais
- `setup()`: Inicializa o jogo
- `draw()`: Renderiza a interface
- `iniciarJogo()`: Inicia uma nova partida
- `keyPressed()`: Processa entrada do teclado
- `mousePressed()`: Processa cliques do mouse

### Funções de Desenho
- `desenharBotoesNivel()`: Desenha os botões de seleção de nível
- `desenharForca()`: Desenha a forca e o boneco
- `desenharPalavra()`: Mostra a palavra atual
- `desenharLetrasUsadas()`: Exibe letras já utilizadas

## Personalização
Você pode personalizar o jogo modificando:

1. Palavras:
   - Edite o array `palavras` para adicionar ou remover palavras
   - Cada nível pode ter até 15 palavras

2. Visual:
   - Modifique as cores alterando as variáveis `corForca`, `corLetra`, etc.
   - Ajuste o tamanho da janela em `size(800, 600)`
   - Mude a fonte em `createFont("Arial", 32)`

3. Dificuldade:
   - Ajuste o número de vidas em `vidas = 6`
   - Modifique a complexidade das palavras por nível

## Dicas para Desenvolvimento
1. Para adicionar novas palavras:
   ```java
   String[][] palavras = {
       {"NOVA_PALAVRA", "OUTRA_PALAVRA", ...},
       // ... outros níveis
   };
   ```

2. Para mudar cores:
   ```java
   color corForca = color(139, 69, 19);    // Marrom
   color corLetra = color(255, 255, 255);  // Branco
   ```

3. Para ajustar o tamanho da janela:
   ```java
   void setup() {
       size(800, 600);  // Largura x Altura
   }
   ```

## Solução de Problemas
1. Se o jogo não iniciar:
   - Verifique se o Processing está instalado corretamente
   - Certifique-se de que todas as bibliotecas necessárias estão instaladas

2. Se as palavras não aparecerem:
   - Verifique se o array `palavras` está preenchido corretamente
   - Certifique-se de que as palavras estão em maiúsculas

3. Se o jogo travar:
   - Feche e reabra o Processing
   - Verifique se não há loops infinitos no código

## Contribuição
Sinta-se à vontade para contribuir com o projeto:
1. Faça um fork do repositório
2. Crie uma branch para sua feature
3. Faça commit das mudanças
4. Push para a branch
5. Abra um Pull Request

## Licença
Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## Créditos
Desenvolvido como um projeto educacional para demonstrar conceitos de programação em Processing. 