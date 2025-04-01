// Variáveis globais
int arvoreMarciano;  // Árvore onde o marciano está escondido
int tentativaAtual;  // Número atual que o jogador está tentando
int numeroTentativas = 0;  // Contador de tentativas
String mensagem = "Digite um número entre 1 e 100 para encontrar o marciano!";
boolean jogoTerminado = false;
PFont fonte;
color corFundo = color(0, 100, 0);
color corArvore = color(0, 200, 0);
color corTronco = color(139, 69, 19);
color corDestaque = color(255, 255, 0);
color corTexto = color(255);

void setup() {
  size(800, 600);
  iniciarJogo();
  fonte = createFont("Arial", 24);
  textFont(fonte);
}

void iniciarJogo() {
  // Gera um número aleatório entre 1 e 100
  arvoreMarciano = int(random(1, 101));
  tentativaAtual = 0;
  numeroTentativas = 0;
  mensagem = "Digite um número entre 1 e 100 para encontrar o marciano!";
  jogoTerminado = false;
}

void draw() {
  // Desenha o céu com gradiente
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(color(135, 206, 235), color(0, 100, 0), inter);
    stroke(c);
    line(0, i, width, i);
  }
  
  // Desenha o sol
  fill(255, 255, 0);
  noStroke();
  ellipse(50, 50, 60, 60);
  
  // Desenha as árvores
  desenharArvores();
  
  // Desenha o marciano se o jogo estiver terminado
  if (jogoTerminado) {
    desenharMarciano(arvoreMarciano);
  }
  
  // Interface do usuário
  desenharInterface();
}

void desenharInterface() {
  // Painel de informações
  fill(0, 0, 0, 150);
  noStroke();
  rect(0, 0, width, 100);
  
  // Mensagem principal
  fill(corTexto);
  textAlign(CENTER);
  textSize(24);
  text(mensagem, width/2, 40);
  
  // Contador de tentativas
  textSize(20);
  text("Tentativas: " + numeroTentativas, width/2, 70);
  
  // Mostra o número atual sendo digitado
  if (tentativaAtual > 0) {
    textSize(30);
    text(tentativaAtual, width/2, 100);
  }
  
  // Mostra instrução para reiniciar
  if (jogoTerminado) {
    textSize(16);
    text("Pressione R para jogar novamente", width/2, 120);
  }
}

void desenharArvores() {
  for (int i = 1; i <= 100; i++) {
    float x = (i % 10) * 80 + 40;
    float y = (i / 10) * 60 + 100;
    
    // Desenha sombra da árvore
    fill(0, 0, 0, 50);
    noStroke();
    ellipse(x, y + 45, 40, 10);
    
    // Desenha o tronco com gradiente
    for (int j = 0; j < 40; j++) {
      float inter = map(j, 0, 40, 0, 1);
      color c = lerpColor(color(139, 69, 19), color(101, 67, 33), inter);
      stroke(c);
      line(x - 5, y + j, x + 5, y + j);
    }
    
    // Desenha a copa da árvore com gradiente
    for (int j = 0; j < 40; j++) {
      float inter = map(j, 0, 40, 0, 1);
      color c = lerpColor(color(0, 200, 0), color(0, 150, 0), inter);
      stroke(c);
      line(x - 20 + j/2, y - j, x + 20 - j/2, y - j);
    }
    
    // Número da árvore
    fill(255);
    textSize(12);
    textAlign(CENTER);
    text(i, x, y + 60);
    
    // Se o jogo estiver terminado e esta for a árvore correta, destaca-a
    if (jogoTerminado && i == arvoreMarciano) {
      stroke(corDestaque);
      strokeWeight(3);
      noFill();
      ellipse(x, y - 20, 40, 40);
      
      // Efeito de brilho
      for (int j = 0; j < 3; j++) {
        stroke(corDestaque, 100 - j * 30);
        strokeWeight(3 - j);
        ellipse(x, y - 20, 40 + j * 10, 40 + j * 10);
      }
    }
  }
}

void desenharMarciano(int arvore) {
  float x = (arvore % 10) * 80 + 40;
  float y = (arvore / 10) * 60 + 60;
  
  // Efeito de brilho ao redor do marciano
  for (int i = 0; i < 3; i++) {
    fill(0, 255, 0, 50 - i * 15);
    noStroke();
    ellipse(x, y, 40 + i * 10, 40 + i * 10);
  }
  
  // Corpo do marciano
  fill(0, 255, 0);
  noStroke();
  ellipse(x, y, 30, 30);
  
  // Olhos
  fill(255);
  ellipse(x - 5, y - 5, 5, 5);
  ellipse(x + 5, y - 5, 5, 5);
  
  // Pupilas
  fill(0);
  ellipse(x - 5, y - 5, 2, 2);
  ellipse(x + 5, y - 5, 2, 2);
  
  // Antenas
  stroke(0, 255, 0);
  strokeWeight(2);
  line(x - 8, y - 15, x - 8, y - 8);
  line(x + 8, y - 15, x + 8, y - 8);
  
  // Bolinhas nas antenas
  fill(0, 255, 0);
  ellipse(x - 8, y - 15, 4, 4);
  ellipse(x + 8, y - 15, 4, 4);
  
  // Efeito de brilho nas antenas
  for (int i = 0; i < 2; i++) {
    stroke(0, 255, 0, 100 - i * 50);
    strokeWeight(1);
    line(x - 8, y - 15 - i * 2, x - 8, y - 8);
    line(x + 8, y - 15 - i * 2, x + 8, y - 8);
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    iniciarJogo();
    return;
  }
  
  if (jogoTerminado) return;
  
  if (key >= '0' && key <= '9') {
    String numero = "";
    if (tentativaAtual > 0) {
      numero = str(tentativaAtual) + key;
    } else {
      numero = str(key);
    }
    tentativaAtual = int(numero);
    
    if (tentativaAtual > 100) {
      tentativaAtual = 100;
    }
  } else if (key == ENTER) {
    numeroTentativas++;
    
    if (tentativaAtual == arvoreMarciano) {
      mensagem = "Parabéns! Você encontrou o marciano na árvore " + arvoreMarciano + "!";
      jogoTerminado = true;
    } else if (tentativaAtual < arvoreMarciano) {
      mensagem = "O marciano está em uma árvore com número MAIOR que " + tentativaAtual;
    } else {
      mensagem = "O marciano está em uma árvore com número MENOR que " + tentativaAtual;
    }
    
    tentativaAtual = 0;
  } else if (key == BACKSPACE) {
    tentativaAtual = 0;
    mensagem = "Digite um número entre 1 e 100 para encontrar o marciano!";
  }
} 
