// Variáveis globais
float paddleHeight = 150;
float paddleWidth = 20;
float ballSize = 20;
float ballSpeedX = 4;
float ballSpeedY = 4;
float maxBallSpeed = 12;
float speedIncrease = 0.1;

// Constantes do jogo
final int SCORE_LIMIT = 8;
final int TIME_ATTACK_DURATION = 120; // 2 minutos em segundos
final int SURVIVAL_SPEED_INCREASE_INTERVAL = 30; // Aumenta a velocidade a cada 30 segundos

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
float aiReactionTime = 1.5;
float aiPrediction = 0.4;
float aiError = 0.5;
float aiDelay = 0.3;
float aiTargetY = 0;
float aiLastUpdate = 0;

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
int gameMode = 0; // 0: Clássico, 1: Contra o Tempo, 2: Sobrevivência
int timeLeft = TIME_ATTACK_DURATION;
int survivalTime = 0;
int lastSpeedIncrease = 0;

// Efeitos visuais
ArrayList<PVector> particles = new ArrayList<PVector>();
ArrayList<PVector> ballTrail = new ArrayList<PVector>();
color[] colors = {#FF0000, #00FF00, #0000FF, #FFFF00, #FF00FF, #00FFFF};
color leftPaddleColor = #FFFFFF;
color rightPaddleColor = #FFFFFF;

// Configurações da engrenagem
float gearX = 750;
float gearY = 50;
float gearSize = 30;
float gearRotation = 0;

// Variáveis de Power-Ups
class PowerUp {
  float x, y;
  int type;
  float duration;
  
  PowerUp(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
    this.duration = 10; // 10 segundos de duração
  }
  
  void draw() {
    noStroke();
    switch(type) {
      case 0: // Aumentar raquete
        fill(0, 255, 0, 200);
        break;
      case 1: // Bola lenta
        fill(0, 0, 255, 200);
        break;
      case 2: // Escudo
        fill(255, 255, 0, 200);
        break;
      case 3: // Congelar IA
        fill(255, 0, 0, 200);
        break;
    }
    ellipse(x, y, 30, 30);
  }
}

ArrayList<PowerUp> powerUps = new ArrayList<PowerUp>();
float powerUpSpawnTimer = 0;
float powerUpSpawnInterval = 15; // Spawn a cada 15 segundos

// Variáveis de efeito de power-up
boolean hasPaddleSizeBoost = false;
float paddleSizeBoostTimer = 0;
boolean hasSlowBall = false;
float slowBallTimer = 0;
boolean hasShield = false;
float shieldTimer = 0;
boolean freezeAI = false;
float freezeAITimer = 0;

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
    
    // Verifica se a IA está congelada
    if (!freezeAI) {
      // IA da raquete direita com atraso e erro
      float currentTime = millis() / 1000.0;
      if (currentTime - aiLastUpdate > aiDelay) {
        aiTargetY = predictBallPosition();
        aiLastUpdate = currentTime;
      }
      
      float currentY = rightPaddleY + paddleHeight/2;
      float error = random(-aiError, aiError) * paddleHeight;
      
      if (abs(aiTargetY + error - currentY) > 5) {
        if (aiTargetY + error > currentY) {
          rightPaddleSpeed = paddleSpeed * 0.6;
        } else {
          rightPaddleSpeed = -paddleSpeed * 0.6;
        }
      } else {
        rightPaddleSpeed *= paddleFriction;
      }
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
    
    // Atualiza o modo de jogo
    updateGameMode();
  }
  
  // Desenha as raquetes com cores personalizadas
  noStroke();
  fill(leftPaddleColor);
  rect(0, leftPaddleY, paddleWidth, paddleHeight);
  fill(rightPaddleColor);
  rect(width - paddleWidth, rightPaddleY, paddleWidth, paddleHeight);
  
  // Desenha o rastro da bola
  drawBallTrail();
  
  // Desenha a bola
  fill(255);
  ellipse(ballX, ballY, ballSize, ballSize);
  
  // Desenha a pontuação e informações do modo de jogo
  textSize(32);
  textAlign(CENTER);
  fill(255);
  text(leftScore, width/4, 50);
  text(rightScore, 3*width/4, 50);
  drawGameModeInfo();
  
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
  
  // Atualiza power-ups
  updatePowerUps();
  
  // Desenha power-ups
  drawPowerUps();
  
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
        float hitPoint = (ballY - leftPaddleY) / paddleHeight;
        float angle = map(hitPoint, 0, 1, -PI/4, PI/4);
        float speed = sqrt(ballSpeedX * ballSpeedX + ballSpeedY * ballSpeedY);
        speed = min(speed * 1.1, maxBallSpeed);
        ballSpeedX = speed * cos(angle);
        ballSpeedY = speed * sin(angle);
        createParticles(ballX, ballY);
      }
      
      if (ballX > width - paddleWidth - ballSize/2 && ballY > rightPaddleY && ballY < rightPaddleY + paddleHeight) {
        float hitPoint = (ballY - rightPaddleY) / paddleHeight;
        float angle = map(hitPoint, 0, 1, -PI/4, PI/4);
        float speed = sqrt(ballSpeedX * ballSpeedX + ballSpeedY * ballSpeedY);
        speed = min(speed * 1.1, maxBallSpeed);
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
      if (gameMode == 0 && (leftScore >= SCORE_LIMIT || rightScore >= SCORE_LIMIT)) {
        gameOver = true;
        winner = leftScore >= SCORE_LIMIT ? "Jogador Esquerdo" : "Computador";
      }
    } else {
      drawSettingsMenu();
    }
  } else if (!gameStarted) {
    // Menu principal
    textSize(48);
    textAlign(CENTER);
    fill(255);
    text("PONG ARCADE", width/2, height/2 - 50);
    textSize(24);
    text("Modo Atual: " + (gameMode == 0 ? "Clássico" : gameMode == 1 ? "Contra o Tempo" : "Sobrevivência"), width/2, height/2);
    text("Pressione ESPAÇO para começar", width/2, height/2 + 50);
    text("Pressione C para configurações", width/2, height/2 + 80);
  } else if (gameOver) {
    // Tela de game over
    textSize(48);
    textAlign(CENTER);
    fill(255);
    text("GAME OVER", width/2, height/2 - 50);
    textSize(24);
    text(winner + " venceu!", width/2, height/2 + 20);
    text("Pontuação: " + leftScore + " - " + rightScore, width/2, height/2 + 50);
    text("Pressione ESPAÇO para jogar novamente", width/2, height/2 + 90);
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
  float predictedY = ballY + ballSpeedY * timeToReach * aiPrediction;
  
  // Faz a bola quicar nas bordas superior e inferior
  while (predictedY < 0 || predictedY > height) {
    if (predictedY < 0) {
      predictedY = -predictedY;
    }
    if (predictedY > height) {
      predictedY = 2 * height - predictedY;
    }
  }
  
  // Adiciona um pequeno erro aleatório na previsão
  predictedY += random(-paddleHeight/4, paddleHeight/4);
  
  return predictedY;
}

void resetBall() {
  ballX = width/2;
  ballY = height/2;
  // Reduz a velocidade inicial
  float speed = random(4, 6);
  float angle = random(-PI/6, PI/6);
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
    if (gameOver) {
      resetGame();
    } else if (!gameStarted) {
      gameStarted = true;
    } else if (settingsOpen) {
      settingsOpen = false;
    }
  }
  
  if (key == '1' || key == '2' || key == '3') {
    gameMode = int(key) - 49; // Converte char para int (1->0, 2->1, 3->2)
  }
  
  if (key == 'q') {
    leftPaddleColor = color(random(255), random(255), random(255));
  }
  
  if (key == 'e') {
    rightPaddleColor = color(random(255), random(255), random(255));
  }
  
  if (key == 'c') {
    settingsOpen = !settingsOpen;
  }
}

void updateGameMode() {
  if (gameMode == 1) { // Contra o Tempo
    if (frameCount % 60 == 0) { // Atualiza a cada segundo
      timeLeft--;
      if (timeLeft <= 0) {
        gameOver = true;
        winner = leftScore > rightScore ? "Jogador Esquerdo" : "Computador";
      }
    }
  } else if (gameMode == 2) { // Sobrevivência
    survivalTime++;
    if (survivalTime - lastSpeedIncrease >= SURVIVAL_SPEED_INCREASE_INTERVAL * 60) {
      ballSpeedX *= 1.1;
      ballSpeedY *= 1.1;
      lastSpeedIncrease = survivalTime;
    }
  }
}

void drawBallTrail() {
  // Adiciona a posição atual da bola ao rastro
  ballTrail.add(new PVector(ballX, ballY));
  
  // Limita o tamanho do rastro
  if (ballTrail.size() > 20) {
    ballTrail.remove(0);
  }
  
  // Desenha o rastro
  for (int i = 0; i < ballTrail.size(); i++) {
    float alpha = map(i, 0, ballTrail.size(), 50, 255);
    fill(255, alpha);
    noStroke();
    ellipse(ballTrail.get(i).x, ballTrail.get(i).y, ballSize * 0.8, ballSize * 0.8);
  }
}

void drawGameModeInfo() {
  textSize(16);
  textAlign(LEFT);
  fill(255);
  
  if (gameMode == 1) { // Contra o Tempo
    int minutes = timeLeft / 60;
    int seconds = timeLeft % 60;
    text("Tempo: " + minutes + ":" + (seconds < 10 ? "0" : "") + seconds, 10, 30);
  } else if (gameMode == 2) { // Sobrevivência
    text("Velocidade: " + nf(sqrt(ballSpeedX * ballSpeedX + ballSpeedY * ballSpeedY), 1, 1), 10, 30);
  }
}

void resetGame() {
  leftScore = 0;
  rightScore = 0;
  gameOver = false;
  winner = "";
  timeLeft = TIME_ATTACK_DURATION;
  survivalTime = 0;
  lastSpeedIncrease = 0;
  ballSpeedX = 4;
  ballSpeedY = 4;
  ballTrail.clear();
  resetBall();
}

void updatePowerUps() {
  // Spawn de power-ups
  powerUpSpawnTimer += 1.0/60; // Assume 60 FPS
  if (powerUpSpawnTimer >= powerUpSpawnInterval) {
    // Chance de spawnar um power-up
    if (random(1) < 0.7) {
      float x = random(width/4, 3*width/4);
      float y = random(height/4, 3*height/4);
      powerUps.add(new PowerUp(x, y, int(random(4))));
    }
    powerUpSpawnTimer = 0;
  }
  
  // Verificar colisão com power-ups
  for (int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp pu = powerUps.get(i);
    
    // Verifica colisão com jogador
    if (dist(ballX, ballY, pu.x, pu.y) < (ballSize + 30)/2) {
      activatePowerUp(pu.type);
      powerUps.remove(i);
    }
  }
  
  // Gerenciar duração dos power-ups
  if (hasPaddleSizeBoost) {
    paddleSizeBoostTimer -= 1.0/60;
    if (paddleSizeBoostTimer <= 0) {
      hasPaddleSizeBoost = false;
      paddleHeight = 150; // Volta ao tamanho original
    }
  }
  
  if (hasSlowBall) {
    slowBallTimer -= 1.0/60;
    if (slowBallTimer <= 0) {
      hasSlowBall = false;
      maxBallSpeed = 12; // Volta à velocidade original
    }
  }
  
  if (hasShield) {
    shieldTimer -= 1.0/60;
    if (shieldTimer <= 0) {
      hasShield = false;
    }
  }
  
  if (freezeAI) {
    freezeAITimer -= 1.0/60;
    if (freezeAITimer <= 0) {
      freezeAI = false;
    }
  }
}

void activatePowerUp(int type) {
  switch(type) {
    case 0: // Aumentar raquete
      hasPaddleSizeBoost = true;
      paddleSizeBoostTimer = 10;
      paddleHeight = 250; // Aumenta significativamente
      break;
    case 1: // Bola lenta
      hasSlowBall = true;
      slowBallTimer = 10;
      maxBallSpeed = 6; // Reduz muito a velocidade
      break;
    case 2: // Escudo
      hasShield = true;
      shieldTimer = 10;
      break;
    case 3: // Congelar IA
      freezeAI = true;
      freezeAITimer = 10;
      break;
  }
}

void drawPowerUps() {
  // Desenha power-ups ativos
  for (PowerUp pu : powerUps) {
    pu.draw();
  }
  
  // Desenha efeitos de power-ups
  if (hasShield) {
    noFill();
    stroke(255, 255, 0, 100);
    strokeWeight(5);
    ellipse(width/2, height/2, width, height);
  }
}

void checkCollisions() {
  // Verifica colisão com as raquetes
  if (ballX < paddleWidth + ballSize/2 && ballY > leftPaddleY && ballY < leftPaddleY + paddleHeight) {
    // Lógica de colisão existente
    // ...
  }
  
  if (ballX > width - paddleWidth - ballSize/2 && ballY > rightPaddleY && ballY < rightPaddleY + paddleHeight) {
    // Se a IA tiver escudo, não marca ponto
    if (!hasShield) {
      // Lógica de colisão existente
      // ...
    }
  }
} 
