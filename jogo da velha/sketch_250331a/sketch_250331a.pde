// Variáveis globais
int[][] tabuleiro = new int[3][3];  // 0 = vazio, 1 = X, 2 = O
boolean vezDoX = true;  // true = vez do X, false = vez do O
boolean jogoTerminado = false;
String mensagem = "Selecione o modo de jogo";
PFont fonte;
color corX = color(255, 50, 50);    // Vermelho
color corO = color(50, 50, 255);    // Azul
color corLinha = color(255, 255, 255);  // Branco
color corFundo = color(30, 30, 30);     // Cinza escuro
boolean modoComputador = false;  // true = modo contra computador, false = modo 2 jogadores
boolean menuAtivo = true;  // true = menu de seleção, false = jogo em andamento

void setup() {
  size(600, 700);
  fonte = createFont("Arial", 32);
  textFont(fonte);
  iniciarJogo();
}

void iniciarJogo() {
  // Limpa o tabuleiro
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      tabuleiro[i][j] = 0;
    }
  }
  vezDoX = true;
  jogoTerminado = false;
  menuAtivo = true;
  mensagem = "Selecione o modo de jogo";
}

void draw() {
  // Desenha o fundo com gradiente
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(color(50, 50, 50), color(30, 30, 30), inter);
    stroke(c);
    line(0, i, width, i);
  }
  
  // Desenha o painel de informações
  fill(0, 0, 0, 150);
  noStroke();
  rect(0, 0, width, 100);
  
  // Desenha a mensagem
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text(mensagem, width/2, 60);
  
  if (menuAtivo) {
    desenharMenu();
  } else {
    // Desenha o tabuleiro
    desenharTabuleiro();
    
    // Desenha o botão de reiniciar
    desenharBotaoReiniciar();
    
    // Se for modo computador e for a vez do O, faz a jogada
    if (modoComputador && !vezDoX && !jogoTerminado) {
      fazerJogadaComputador();
    }
  }
}

void desenharMenu() {
  float x = width/2 - 150;
  float y = 200;
  float largura = 300;
  float altura = 80;
  
  // Botão Modo 2 Jogadores
  fill(0);  // Fundo preto
  stroke(255);
  strokeWeight(2);
  rect(x, y, largura, altura, 10);
  
  fill(255);  // Texto branco
  textAlign(CENTER);
  textSize(24);
  text("1 vs 1", width/2, y + 50);
  
  // Botão Modo Computador
  y += 100;
  fill(0);  // Fundo preto
  rect(x, y, largura, altura, 10);
  fill(255);  // Texto branco
  text("Jogar contra a Máquina", width/2, y + 50);
}

void desenharTabuleiro() {
  float tamanho = 150;  // Tamanho de cada célula
  float inicioX = (width - tamanho * 3) / 2;
  float inicioY = 150;
  
  // Desenha as linhas do tabuleiro
  stroke(corLinha);
  strokeWeight(4);
  
  // Linhas horizontais
  for (int i = 1; i < 3; i++) {
    line(inicioX, inicioY + i * tamanho, inicioX + 3 * tamanho, inicioY + i * tamanho);
  }
  
  // Linhas verticais
  for (int i = 1; i < 3; i++) {
    line(inicioX + i * tamanho, inicioY, inicioX + i * tamanho, inicioY + 3 * tamanho);
  }
  
  // Desenha os X's e O's
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      float x = inicioX + j * tamanho;
      float y = inicioY + i * tamanho;
      
      if (tabuleiro[i][j] == 1) {
        desenharX(x, y, tamanho);
      } else if (tabuleiro[i][j] == 2) {
        desenharO(x, y, tamanho);
      }
    }
  }
}

void desenharX(float x, float y, float tamanho) {
  stroke(corX);
  strokeWeight(8);
  float margem = tamanho * 0.2;
  line(x + margem, y + margem, x + tamanho - margem, y + tamanho - margem);
  line(x + margem, y + tamanho - margem, x + tamanho - margem, y + margem);
}

void desenharO(float x, float y, float tamanho) {
  stroke(corO);
  strokeWeight(8);
  noFill();
  float margem = tamanho * 0.2;
  ellipse(x + tamanho/2, y + tamanho/2, tamanho - 2*margem, tamanho - 2*margem);
}

void desenharBotaoReiniciar() {
  float x = width/2 - 100;
  float y = height - 100;
  float largura = 200;
  float altura = 50;
  
  // Desenha o botão
  fill(0);  // Fundo preto
  stroke(255);
  strokeWeight(2);
  rect(x, y, largura, altura, 10);
  
  // Desenha o texto
  fill(255);  // Texto branco
  textAlign(CENTER);
  textSize(24);
  text("Reiniciar Jogo", width/2, y + 32);
}

void mousePressed() {
  if (menuAtivo) {
    float x = width/2 - 150;
    float y = 200;
    float largura = 300;
    float altura = 80;
    
    // Verifica clique no botão de 2 jogadores
    if (mouseX >= x && mouseX <= x + largura && 
        mouseY >= y && mouseY <= y + altura) {
      modoComputador = false;
      menuAtivo = false;
      mensagem = "Vez do jogador X";
    }
    
    // Verifica clique no botão de modo computador
    y += 100;
    if (mouseX >= x && mouseX <= x + largura && 
        mouseY >= y && mouseY <= y + altura) {
      modoComputador = true;
      menuAtivo = false;
      mensagem = "Vez do jogador X";
    }
    return;
  }
  
  if (jogoTerminado) {
    // Verifica se clicou no botão de reiniciar
    float x = width/2 - 100;
    float y = height - 100;
    if (mouseX >= x && mouseX <= x + 200 && mouseY >= y && mouseY <= y + 50) {
      iniciarJogo();
    }
    return;
  }
  
  // Se for modo computador e for a vez do O, não permite jogada
  if (modoComputador && !vezDoX) {
    return;
  }
  
  // Calcula a posição do clique no tabuleiro
  float tamanho = 150;
  float inicioX = (width - tamanho * 3) / 2;
  float inicioY = 150;
  
  int coluna = int((mouseX - inicioX) / tamanho);
  int linha = int((mouseY - inicioY) / tamanho);
  
  // Verifica se o clique foi dentro do tabuleiro
  if (linha >= 0 && linha < 3 && coluna >= 0 && coluna < 3) {
    // Verifica se a posição está vazia
    if (tabuleiro[linha][coluna] == 0) {
      fazerJogada(linha, coluna);
    }
  }
}

void fazerJogada(int linha, int coluna) {
  // Faz a jogada
  tabuleiro[linha][coluna] = vezDoX ? 1 : 2;
  
  // Verifica se o jogo terminou
  if (verificarVitoria()) {
    jogoTerminado = true;
    mensagem = (vezDoX ? "X" : "O") + " venceu!";
  } else if (verificarEmpate()) {
    jogoTerminado = true;
    mensagem = "Empate!";
  } else {
    // Passa a vez
    vezDoX = !vezDoX;
    mensagem = "Vez do jogador " + (vezDoX ? "X" : "O");
  }
}

void fazerJogadaComputador() {
  // Procura uma jogada vencedora
  int[] jogada = encontrarJogadaVencedora(2);
  if (jogada != null) {
    fazerJogada(jogada[0], jogada[1]);
    return;
  }
  
  // Bloqueia jogada vencedora do oponente
  jogada = encontrarJogadaVencedora(1);
  if (jogada != null) {
    fazerJogada(jogada[0], jogada[1]);
    return;
  }
  
  // Tenta jogar no centro
  if (tabuleiro[1][1] == 0) {
    fazerJogada(1, 1);
    return;
  }
  
  // Joga em uma posição aleatória
  ArrayList<int[]> posicoesVazias = new ArrayList<int[]>();
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == 0) {
        posicoesVazias.add(new int[]{i, j});
      }
    }
  }
  
  if (!posicoesVazias.isEmpty()) {
    int[] posicao = posicoesVazias.get(int(random(posicoesVazias.size())));
    fazerJogada(posicao[0], posicao[1]);
  }
}

int[] encontrarJogadaVencedora(int jogador) {
  // Verifica linhas
  for (int i = 0; i < 3; i++) {
    int[] jogada = verificarLinha(i, jogador);
    if (jogada != null) return jogada;
  }
  
  // Verifica colunas
  for (int j = 0; j < 3; j++) {
    int[] jogada = verificarColuna(j, jogador);
    if (jogada != null) return jogada;
  }
  
  // Verifica diagonais
  int[] jogada = verificarDiagonal(jogador);
  if (jogada != null) return jogada;
  
  return null;
}

int[] verificarLinha(int linha, int jogador) {
  int vazios = 0;
  int[] posicaoVazia = null;
  
  for (int j = 0; j < 3; j++) {
    if (tabuleiro[linha][j] == jogador) {
      vazios++;
    } else if (tabuleiro[linha][j] == 0) {
      posicaoVazia = new int[]{linha, j};
    }
  }
  
  if (vazios == 2 && posicaoVazia != null) {
    return posicaoVazia;
  }
  
  return null;
}

int[] verificarColuna(int coluna, int jogador) {
  int vazios = 0;
  int[] posicaoVazia = null;
  
  for (int i = 0; i < 3; i++) {
    if (tabuleiro[i][coluna] == jogador) {
      vazios++;
    } else if (tabuleiro[i][coluna] == 0) {
      posicaoVazia = new int[]{i, coluna};
    }
  }
  
  if (vazios == 2 && posicaoVazia != null) {
    return posicaoVazia;
  }
  
  return null;
}

int[] verificarDiagonal(int jogador) {
  // Diagonal principal
  int vazios = 0;
  int[] posicaoVazia = null;
  
  for (int i = 0; i < 3; i++) {
    if (tabuleiro[i][i] == jogador) {
      vazios++;
    } else if (tabuleiro[i][i] == 0) {
      posicaoVazia = new int[]{i, i};
    }
  }
  
  if (vazios == 2 && posicaoVazia != null) {
    return posicaoVazia;
  }
  
  // Diagonal secundária
  vazios = 0;
  posicaoVazia = null;
  
  for (int i = 0; i < 3; i++) {
    if (tabuleiro[i][2-i] == jogador) {
      vazios++;
    } else if (tabuleiro[i][2-i] == 0) {
      posicaoVazia = new int[]{i, 2-i};
    }
  }
  
  if (vazios == 2 && posicaoVazia != null) {
    return posicaoVazia;
  }
  
  return null;
}

boolean verificarVitoria() {
  // Verifica linhas
  for (int i = 0; i < 3; i++) {
    if (tabuleiro[i][0] != 0 && 
        tabuleiro[i][0] == tabuleiro[i][1] && 
        tabuleiro[i][1] == tabuleiro[i][2]) {
      return true;
    }
  }
  
  // Verifica colunas
  for (int j = 0; j < 3; j++) {
    if (tabuleiro[0][j] != 0 && 
        tabuleiro[0][j] == tabuleiro[1][j] && 
        tabuleiro[1][j] == tabuleiro[2][j]) {
      return true;
    }
  }
  
  // Verifica diagonais
  if (tabuleiro[0][0] != 0 && 
      tabuleiro[0][0] == tabuleiro[1][1] && 
      tabuleiro[1][1] == tabuleiro[2][2]) {
    return true;
  }
  
  if (tabuleiro[0][2] != 0 && 
      tabuleiro[0][2] == tabuleiro[1][1] && 
      tabuleiro[1][1] == tabuleiro[2][0]) {
    return true;
  }
  
  return false;
}

boolean verificarEmpate() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == 0) {
        return false;
      }
    }
  }
  return true;
} 
