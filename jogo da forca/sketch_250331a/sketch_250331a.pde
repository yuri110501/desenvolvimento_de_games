// Variáveis globais
String[][] palavras = {
  // Nível Fácil (palavras curtas e comuns)
  {
    "CASA", "BOLA", "GATO", "CACHORRO", "LIVRO",
    "MESA", "CADEIRA", "JANELA", "PORTA", "ÁRVORE",
    "FLOR", "SOL", "LUA", "MAR", "RIO"
  },
  // Nível Médio (palavras médias e um pouco mais complexas)
  {
    "COMPUTADOR", "INTERNET", "PROGRAMACAO", "ALGORITMO", "DESENVOLVIMENTO",
    "APLICACAO", "SOFTWARE", "HARDWARE", "SISTEMA", "REDE",
    "DADOS", "INFORMATICA", "TECNOLOGIA", "PROCESSAMENTO", "INFORMACAO"
  },
  // Nível Difícil (palavras longas e mais complexas)
  {
    "DESENVOLVIMENTO", "PROGRAMACAO", "APLICACAO", "COMPUTADOR", "ALGORITMO",
    "INTERFACE", "SOFTWARE", "HARDWARE", "SISTEMA", "REDE",
    "DADOS", "INFORMATICA", "TECNOLOGIA", "PROCESSAMENTO", "INFORMACAO"
  }
};

String palavra;  // Palavra a ser adivinhada
String palavraAtual = "";      // Palavra com as letras descobertas
ArrayList<Character> letrasUsadas = new ArrayList<Character>();
ArrayList<Character> letrasErradas = new ArrayList<Character>();
int vidas = 6;                 // Número de vidas
boolean jogoTerminado = false;
String mensagem = "Escolha um nível para começar!";
PFont fonte;
color corForca = color(139, 69, 19);    // Marrom
color corLetra = color(255, 255, 255);  // Branco
color corLetraErrada = color(255, 0, 0); // Vermelho
color corLetraCerta = color(0, 255, 0);  // Verde
int nivelAtual = -1;  // -1 significa que nenhum nível foi escolhido

void setup() {
  size(800, 600);
  fonte = createFont("Arial", 32);
  textFont(fonte);
}

void iniciarJogo() {
  // Escolhe uma palavra aleatória do nível atual
  palavra = palavras[nivelAtual][int(random(palavras[nivelAtual].length))];
  
  // Inicializa a palavra atual com underscores
  palavraAtual = "";
  for (int i = 0; i < palavra.length(); i++) {
    palavraAtual += "_";
  }
  
  // Limpa as listas de letras
  letrasUsadas.clear();
  letrasErradas.clear();
  
  // Reseta as vidas e o estado do jogo
  vidas = 6;
  jogoTerminado = false;
  mensagem = "Digite uma letra para começar!";
}

void draw() {
  // Desenha o fundo com gradiente
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(color(50, 50, 50), color(30, 30, 30), inter);
    stroke(c);
    line(0, i, width, i);
  }
  
  // Desenha o painel de informações com efeito de sombra
  fill(0, 0, 0, 200);
  noStroke();
  rect(0, 0, width, 100);
  
  // Desenha a mensagem com sombra
  fill(0, 0, 0, 100);
  textAlign(CENTER);
  textSize(24);
  text(mensagem, width/2 + 2, 42);
  
  fill(255);
  text(mensagem, width/2, 40);
  
  // Desenha as vidas restantes com sombra
  fill(0, 0, 0, 100);
  text("Vidas: " + vidas, width/2 + 2, 72);
  
  fill(255);
  text("Vidas: " + vidas, width/2, 70);
  
  // Desenha o botão de engrenagem (sempre visível durante o jogo)
  if (nivelAtual != -1) {
    desenharBotaoEngrenagem();
  }
  
  // Se nenhum nível foi escolhido, desenha os botões de nível
  if (nivelAtual == -1) {
    desenharBotoesNivel();
  } else {
    // Desenha a forca
    desenharForca();
    
    // Desenha a palavra
    desenharPalavra();
    
    // Desenha as letras usadas
    desenharLetrasUsadas();
    
    // Se o jogo terminou, desenha o botão de reiniciar
    if (jogoTerminado) {
      desenharBotaoReiniciar();
    }
  }
}

void desenharBotoesNivel() {
  float y = height/2 - 100;
  float largura = 200;
  float altura = 50;
  float espaco = 20;
  
  // Botão Fácil
  float x = width/2 - largura/2;
  if (mouseX >= x && mouseX <= x + largura && mouseY >= y && mouseY <= y + altura) {
    fill(50);
  } else {
    fill(0);
  }
  stroke(255);
  strokeWeight(2);
  rect(x, y, largura, altura, 10);
  
  // Botão Médio
  if (mouseX >= x && mouseX <= x + largura && mouseY >= y + altura + espaco && mouseY <= y + altura * 2 + espaco) {
    fill(50);
  } else {
    fill(0);
  }
  rect(x, y + altura + espaco, largura, altura, 10);
  
  // Botão Difícil
  if (mouseX >= x && mouseX <= x + largura && mouseY >= y + (altura + espaco) * 2 && mouseY <= y + (altura + espaco) * 3) {
    fill(50);
  } else {
    fill(0);
  }
  rect(x, y + (altura + espaco) * 2, largura, altura, 10);
  
  // Textos dos botões
  fill(255);
  textAlign(CENTER);
  textSize(24);
  text("Nível Fácil", width/2, y + 32);
  text("Nível Médio", width/2, y + altura + espaco + 32);
  text("Nível Difícil", width/2, y + (altura + espaco) * 2 + 32);
}

void desenharForca() {
  float x = 150;  // Movido mais para a esquerda
  float y = 400;
  
  stroke(corForca);
  strokeWeight(4);
  
  // Base da forca
  line(x - 50, y, x + 50, y);
  
  // Poste vertical
  line(x, y, x, y - 300);
  
  // Topo da forca
  line(x, y - 300, x + 150, y - 300);
  
  // Corda
  line(x + 150, y - 300, x + 150, y - 250);
  
  // Desenha o boneco se houver erros
  if (letrasErradas.size() > 0) {
    // Cabeça
    noFill();
    stroke(corLetra);
    strokeWeight(3);
    ellipse(x + 150, y - 220, 40, 40);
    
    if (letrasErradas.size() > 1) {
      // Corpo
      line(x + 150, y - 200, x + 150, y - 100);
    }
    
    if (letrasErradas.size() > 2) {
      // Braço esquerdo
      line(x + 150, y - 180, x + 100, y - 140);
    }
    
    if (letrasErradas.size() > 3) {
      // Braço direito
      line(x + 150, y - 180, x + 200, y - 140);
    }
    
    if (letrasErradas.size() > 4) {
      // Perna esquerda
      line(x + 150, y - 100, x + 120, y - 40);
    }
    
    if (letrasErradas.size() > 5) {
      // Perna direita
      line(x + 150, y - 100, x + 180, y - 40);
    }
  }
}

void desenharPalavra() {
  float x = width/2 - (palavra.length() * 20);
  float y = 200;
  
  textAlign(LEFT);
  textSize(40);
  
  // Adiciona sombra ao texto
  fill(0, 0, 0, 100);
  for (int i = 0; i < palavraAtual.length(); i++) {
    text("_", x + i * 40 + 2, y + 2);
  }
  
  for (int i = 0; i < palavraAtual.length(); i++) {
    char letra = palavraAtual.charAt(i);
    if (letra == '_') {
      fill(255);
      text("_", x + i * 40, y);
    } else {
      fill(corLetraCerta);
      text(letra, x + i * 40, y);
    }
  }
}

void desenharLetrasUsadas() {
  float x = 50;
  float y = 500;
  
  textAlign(LEFT);
  textSize(20);
  
  // Letras erradas com fundo
  fill(0, 0, 0, 150);
  noStroke();
  rect(x - 10, y - 25, 300, 30, 10);
  
  fill(corLetraErrada);
  text("Letras erradas: ", x, y);
  for (int i = 0; i < letrasErradas.size(); i++) {
    text(letrasErradas.get(i), x + 150 + i * 20, y);
  }
  
  // Letras usadas com fundo
  fill(0, 0, 0, 150);
  noStroke();
  rect(x - 10, y + 5, 300, 30, 10);
  
  fill(255);
  text("Letras usadas: ", x, y + 30);
  for (int i = 0; i < letrasUsadas.size(); i++) {
    text(letrasUsadas.get(i), x + 150 + i * 20, y + 30);
  }
}

void desenharBotaoEngrenagem() {
  float engrenagemX = width - 60;
  float engrenagemY = 30;
  float engrenagemTamanho = 40;
  
  // Efeito de hover na engrenagem
  if (mouseX >= engrenagemX - engrenagemTamanho/2 && 
      mouseX <= engrenagemX + engrenagemTamanho/2 && 
      mouseY >= engrenagemY - engrenagemTamanho/2 && 
      mouseY <= engrenagemY + engrenagemTamanho/2) {
    fill(50);
  } else {
    fill(0);
  }
  
  stroke(255);
  strokeWeight(2);
  ellipse(engrenagemX, engrenagemY, engrenagemTamanho, engrenagemTamanho);
  
  // Desenha os dentes da engrenagem
  for (int i = 0; i < 8; i++) {
    float angulo = i * PI / 4;
    float x1 = engrenagemX + cos(angulo) * engrenagemTamanho/2;
    float y1 = engrenagemY + sin(angulo) * engrenagemTamanho/2;
    float x2 = engrenagemX + cos(angulo) * (engrenagemTamanho/2 + 10);
    float y2 = engrenagemY + sin(angulo) * (engrenagemTamanho/2 + 10);
    line(x1, y1, x2, y2);
  }
  
  // Desenha o centro da engrenagem
  fill(0);
  ellipse(engrenagemX, engrenagemY, engrenagemTamanho/3, engrenagemTamanho/3);
}

void desenharBotaoReiniciar() {
  float x = width/2 - 100;
  float y = height - 100;
  float largura = 200;
  float altura = 50;
  
  // Efeito de hover
  if (mouseX >= x && mouseX <= x + largura && mouseY >= y && mouseY <= y + altura) {
    fill(50);
  } else {
    fill(0);
  }
  
  stroke(255);
  strokeWeight(2);
  rect(x, y, largura, altura, 10);
  
  // Desenha o texto com sombra
  fill(0, 0, 0, 100);
  textAlign(CENTER);
  textSize(24);
  text("Jogar Novamente", width/2 + 2, y + 32);
  
  fill(255);
  text("Jogar Novamente", width/2, y + 30);
}

void mousePressed() {
  if (nivelAtual == -1) {
    float y = height/2 - 100;
    float largura = 200;
    float altura = 50;
    float espaco = 20;
    float x = width/2 - largura/2;
    
    // Verifica clique no botão Fácil
    if (mouseX >= x && mouseX <= x + largura && mouseY >= y && mouseY <= y + altura) {
      nivelAtual = 0;
      iniciarJogo();
    }
    // Verifica clique no botão Médio
    else if (mouseX >= x && mouseX <= x + largura && mouseY >= y + altura + espaco && mouseY <= y + altura * 2 + espaco) {
      nivelAtual = 1;
      iniciarJogo();
    }
    // Verifica clique no botão Difícil
    else if (mouseX >= x && mouseX <= x + largura && mouseY >= y + (altura + espaco) * 2 && mouseY <= y + (altura + espaco) * 3) {
      nivelAtual = 2;
      iniciarJogo();
    }
  } else {
    // Verifica clique no botão de engrenagem (sempre visível durante o jogo)
    float engrenagemX = width - 60;
    float engrenagemY = 30;
    float engrenagemTamanho = 40;
    
    if (mouseX >= engrenagemX - engrenagemTamanho/2 && 
        mouseX <= engrenagemX + engrenagemTamanho/2 && 
        mouseY >= engrenagemY - engrenagemTamanho/2 && 
        mouseY <= engrenagemY + engrenagemTamanho/2) {
      nivelAtual = -1;  // Volta para a seleção de nível
      mensagem = "Escolha um nível para começar!";
    }
    // Verifica clique no botão Jogar Novamente (apenas quando o jogo terminou)
    else if (jogoTerminado) {
      float x = width/2 - 100;
      float y = height - 100;
      if (mouseX >= x && mouseX <= x + 200 && mouseY >= y && mouseY <= y + 50) {
        iniciarJogo();
      }
    }
  }
}

void keyPressed() {
  if (jogoTerminado) {
    return;
  }
  
  // Converte a tecla pressionada para maiúscula
  char letra = Character.toUpperCase(key);
  
  // Verifica se a tecla pressionada é uma letra
  if (letra >= 'A' && letra <= 'Z') {
    // Verifica se a letra já foi usada
    if (letrasUsadas.contains(letra)) {
      mensagem = "Esta letra já foi usada!";
      return;
    }
    
    // Adiciona a letra à lista de letras usadas
    letrasUsadas.add(letra);
    
    // Verifica se a letra está na palavra
    boolean acertou = false;
    String novaPalavra = "";
    
    for (int i = 0; i < palavra.length(); i++) {
      if (palavra.charAt(i) == letra) {
        novaPalavra += letra;
        acertou = true;
      } else {
        novaPalavra += palavraAtual.charAt(i);
      }
    }
    
    if (acertou) {
      palavraAtual = novaPalavra;
      mensagem = "Acertou! Continue tentando!";
      
      // Verifica se o jogador venceu
      if (palavraAtual.equals(palavra)) {
        jogoTerminado = true;
        mensagem = "Parabéns! Você venceu!";
      }
    } else {
      letrasErradas.add(letra);
      vidas--;
      mensagem = "Errou! Tente novamente!";
      
      // Verifica se o jogador perdeu
      if (vidas <= 0) {
        jogoTerminado = true;
        mensagem = "Game Over! A palavra era: " + palavra;
      }
    }
  } else {
    // Se não for uma letra, mostra mensagem de ajuda
    mensagem = "Digite uma letra (A-Z) para jogar!";
  }
} 
