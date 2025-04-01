// Variáveis globais
float paddleHeight = 100;
float paddleWidth = 20;
float ballSize = 20;
float ballSpeedX = 5;
float ballSpeedY = 5;
float maxBallSpeed = 15;
float speedIncrease = 0.2;

// Posições dos elementos
float leftPaddleY;
float rightPaddleY;
float ballX;
float ballY;

// Velocidades das raquetes
float leftPaddleSpeed = 0;
float rightPaddleSpeed = 0;
float paddleSpeed = 12;
float paddleAcceleration = 0.8;
float paddleFriction = 0.8;

// IA da raquete direita
float aiReactionTime = 1.2;
float aiPrediction = 0.5;

// Níveis de dificuldade
int currentLevel = 1;
int maxLevel = 5;
float[] levelReactionTimes = {2.0, 1.5, 1.2, 0.8, 0.5}; // Tempos de reação para cada nível
float[] levelPredictions = {0.3, 0.4, 0.5, 0.7, 0.9}; // Previsão para cada nível

// Pontuação
int leftScore = 0;
int rightScore = 0;

// Estados do jogo
boolean gameStarted = false;
boolean gameOver = false;
String winner = "";
boolean settingsOpen = false;

// Efeitos visuais
ArrayList<PVector> particles = new ArrayList<PVector>();
color[] colors = {#FF0000, #00FF00, #0000FF, #FFFF00, #FF00FF, #00FFFF};

// Configurações da engrenagem
float gearX = 750;
float gearY = 50;
float gearSize = 30;
float gearRotation = 0;

void setup() {
  size(800, 600);
  
  // Inicializa as posições
  leftPaddleY = height/2 - paddleHeight/2;
  rightPaddleY = height/2 - paddleHeight/2;
  ballX = width/2;
  ballY = height/2;
  
  // Define a velocidade inicial da bola
  resetBall();
}

void draw() {
  background(0);
  
  // Desenha a linha central pontilhada
  stroke(255, 100);
  for (float y = 0; y < height; y += 30) {
    line(width/2, y, width/2, y + 15);
  }
  
  // Atualiza as posições das raquetes
  if (gameStarted && !gameOver && !settingsOpen) {
    // Atualiza velocidade da raquete esquerda
    if (keyPressed) {
      if (key == 'w') {
        leftPaddleSpeed -= paddleAcceleration;
      }
      if (key == 's') {
        leftPaddleSpeed += paddleAcceleration;
      }
    }
    
    // IA da raquete direita
    float targetY = predictBallPosition();
    float currentY = rightPaddleY + paddleHeight/2;
    
    // Calcula a direção do movimento usando a mesma velocidade do jogador
    if (abs(targetY - currentY) > levelReactionTimes[currentLevel - 1]) {
      if (targetY > currentY) {
        rightPaddleSpeed = paddleSpeed; // Define a velocidade máxima diretamente
      } else {
        rightPaddleSpeed = -paddleSpeed; // Define a velocidade máxima diretamente
      }
    } else {
      rightPaddleSpeed *= paddleFriction; // Aplica fricção quando não precisa se mover
    }
    
    // Aplica fricção
    leftPaddleSpeed *= paddleFriction;
    rightPaddleSpeed *= paddleFriction;
    
    // Limita a velocidade máxima
    leftPaddleSpeed = constrain(leftPaddleSpeed, -paddleSpeed, paddleSpeed);
    rightPaddleSpeed = constrain(rightPaddleSpeed, -paddleSpeed, paddleSpeed);
    
    // Atualiza posições
    leftPaddleY += leftPaddleSpeed;
    rightPaddleY += rightPaddleSpeed;
    
    // Limita as posições das raquetes
    leftPaddleY = constrain(leftPaddleY, 0, height - paddleHeight);
    rightPaddleY = constrain(rightPaddleY, 0, height - paddleHeight);
  }
  
  // Desenha as raquetes com efeito de brilho
  noStroke();
  fill(255, 200);
  rect(0, leftPaddleY, paddleWidth, paddleHeight);
  rect(width - paddleWidth, rightPaddleY, paddleWidth, paddleHeight);
  
  // Desenha a bola com efeito de brilho
  fill(255);
  ellipse(ballX, ballY, ballSize, ballSize);
  
  // Desenha a pontuação e nível com efeito de brilho
  textSize(32);
  textAlign(CENTER);
  fill(255, 200);
  text(leftScore, width/4, 50);
  text(rightScore, 3*width/4, 50);
  text("Nível: " + currentLevel, width/2, 50);
  
  // Desenha a engrenagem
  drawGear();
  
  // Desenha as partículas
  for (int i = particles.size() - 1; i >= 0; i--) {
    PVector p = particles.get(i);
    fill(colors[i % colors.length], 150);
    ellipse(p.x, p.y, 5, 5);
    p.x += random(-2, 2);
    p.y += random(-2, 2);
    p.z -= 0.1;
    if (p.z <= 0) particles.remove(i);
  }
  
  if (gameStarted && !gameOver) {
    if (!settingsOpen) {
      // Atualiza a posição da bola
      ballX += ballSpeedX;
      ballY += ballSpeedY;
      
      // Verifica colisão com as bordas superior e inferior
      if (ballY < ballSize/2 || ballY > height - ballSize/2) {
        ballSpeedY *= -1;
        createParticles(ballX, ballY);
      }
      
      // Verifica colisão com as raquetes
      if (ballX < paddleWidth + ballSize/2 && ballY > leftPaddleY && ballY < leftPaddleY + paddleHeight) {
        // Calcula o ponto de colisão relativo à raquete (0 a 1)
        float hitPoint = (ballY - leftPaddleY) / paddleHeight;
        
        // Ajusta o ângulo baseado no ponto de colisão
        float angle = map(hitPoint, 0, 1, -PI/4, PI/4);
        
        // Calcula a velocidade baseada no ângulo
        float speed = sqrt(ballSpeedX * ballSpeedX + ballSpeedY * ballSpeedY);
        speed = min(speed * 1.1, maxBallSpeed); // Aumenta a velocidade
        
        // Aplica o novo movimento
        ballSpeedX = speed * cos(angle);
        ballSpeedY = speed * sin(angle);
        
        createParticles(ballX, ballY);
      }
      
      if (ballX > width - paddleWidth - ballSize/2 && ballY > rightPaddleY && ballY < rightPaddleY + paddleHeight) {
        // Calcula o ponto de colisão relativo à raquete (0 a 1)
        float hitPoint = (ballY - rightPaddleY) / paddleHeight;
        
        // Ajusta o ângulo baseado no ponto de colisão
        float angle = map(hitPoint, 0, 1, -PI/4, PI/4);
        
        // Calcula a velocidade baseada no ângulo
        float speed = sqrt(ballSpeedX * ballSpeedX + ballSpeedY * ballSpeedY);
        speed = min(speed * 1.1, maxBallSpeed); // Aumenta a velocidade
        
        // Aplica o novo movimento
        ballSpeedX = -speed * cos(angle);
        ballSpeedY = speed * sin(angle);
        
        createParticles(ballX, ballY);
      }
      
      // Verifica se a bola passou das raquetes
      if (ballX < 0) {
        rightScore++;
        resetBall();
      }
      
      if (ballX > width) {
        leftScore++;
        resetBall();
      }
      
      // Verifica vitória
      if (leftScore >= 5 || rightScore >= 5) {
        gameOver = true;
        winner = leftScore >= 5 ? "Jogador Esquerdo" : "Computador";
      }
    } else {
      // Menu de configurações
      drawSettingsMenu();
    }
  } else if (!gameStarted) {
    // Menu principal
    textSize(48);
    textAlign(CENTER);
    fill(255);
    text("PONG", width/2, height/2 - 50);
    textSize(24);
    text("Nível: " + currentLevel, width/2, height/2);
    text("Pressione ESPAÇO para começar", width/2, height/2 + 50);
    text("Pressione 1-5 para mudar o nível", width/2, height/2 + 80);
  } else if (gameOver) {
    // Tela de game over
    textSize(48);
    textAlign(CENTER);
    fill(255);
    text("GAME OVER", width/2, height/2 - 50);
    textSize(24);
    text(winner + " venceu!", width/2, height/2 + 20);
    text("Pressione ESPAÇO para jogar novamente", width/2, height/2 + 60);
  }
}

void drawGear() {
  pushMatrix();
  translate(gearX, gearY);
  rotate(gearRotation);
  
  // Desenha a engrenagem
  stroke(255, 200);
  strokeWeight(2);
  fill(255, 100);
  
  // Círculo central
  ellipse(0, 0, gearSize, gearSize);
  
  // Dentes da engrenagem
  for (int i = 0; i < 8; i++) {
    float angle = i * PI / 4;
    float x = cos(angle) * gearSize/2;
    float y = sin(angle) * gearSize/2;
    rect(x - 5, y - 10, 10, 20);
  }
  
  popMatrix();
  
  // Atualiza a rotação
  gearRotation += 0.02;
}

void drawSettingsMenu() {
  // Fundo semi-transparente
  fill(0, 200);
  rect(0, 0, width, height);
  
  // Título
  textSize(48);
  textAlign(CENTER);
  fill(255);
  text("Configurações", width/2, height/2 - 100);
  
  // Níveis
  textSize(24);
  for (int i = 1; i <= maxLevel; i++) {
    float x = width/2 - 100 + (i-1) * 50;
    float y = height/2;
    
    // Botão do nível
    if (i == currentLevel) {
      fill(255, 200);
      ellipse(x, y, 40, 40);
      fill(0);
    } else {
      fill(255, 100);
      ellipse(x, y, 40, 40);
      fill(255);
    }
    text(i, x, y + 8);
  }
  
  // Instruções
  textSize(20);
  fill(255, 200);
  text("Clique em um número para mudar o nível", width/2, height/2 + 50);
  text("Pressione ESC para voltar", width/2, height/2 + 80);
}

void mousePressed() {
  if (gameStarted && !gameOver) {
    // Verifica clique na engrenagem
    float d = dist(mouseX, mouseY, gearX, gearY);
    if (d < gearSize/2) {
      settingsOpen = !settingsOpen;
    }
    
    // Verifica clique nos níveis no menu de configurações
    if (settingsOpen) {
      for (int i = 1; i <= maxLevel; i++) {
        float x = width/2 - 100 + (i-1) * 50;
        float y = height/2;
        float d2 = dist(mouseX, mouseY, x, y);
        if (d2 < 20) {
          currentLevel = i;
        }
      }
    }
  }
}

float predictBallPosition() {
  // Calcula onde a bola estará quando chegar à raquete direita
  float timeToReach = (width - paddleWidth - ballX) / ballSpeedX;
  float predictedY = ballY + ballSpeedY * timeToReach * levelPredictions[currentLevel - 1];
  
  // Faz a bola quicar nas bordas superior e inferior
  while (predictedY < 0 || predictedY > height) {
    if (predictedY < 0) {
      predictedY = -predictedY;
    }
    if (predictedY > height) {
      predictedY = 2 * height - predictedY;
    }
  }
  
  return predictedY;
}

void resetBall() {
  ballX = width/2;
  ballY = height/2;
  // Aumenta a velocidade inicial
  float speed = random(5, 8);
  float angle = random(-PI/4, PI/4);
  ballSpeedX = speed * cos(angle);
  ballSpeedY = speed * sin(angle);
}

void createParticles(float x, float y) {
  for (int i = 0; i < 10; i++) {
    particles.add(new PVector(x, y, 1));
  }
}

void keyPressed() {
  if (key == ' ') {
    if (!gameStarted || gameOver) {
      gameStarted = true;
      gameOver = false;
      leftScore = 0;
      rightScore = 0;
      resetBall();
    }
  } else if (key >= '1' && key <= '5') {
    currentLevel = key - '0';
  } else if (key == ESC) {
    settingsOpen = false;
  }
} 
