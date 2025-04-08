// Jogo da Memória com Imagens - Versão Completa
// Desenvolvido com clean code e boas práticas

// Enums globais
enum GameState {
    MENU, PREVIEW, PLAYING, GAME_OVER, SETTINGS
}

enum Difficulty {
    EASY, MEDIUM, HARD
}

class MemoryGame {
    // Configurações do jogo
    // Para cada dificuldade: [FÁCIL, MÉDIO, DIFÍCIL]
    final int[][] GRID_CONFIG = {
        {3, 2},  // Fácil: 3x2
        {4, 4},  // Médio: 4x4
        {6, 4}   // Difícil: 6x4
    };
    final int[] PREVIEW_TIME = {300, 180, 120}; // 5s, 3s, 2s a 60 FPS
    final int[] MAX_ATTEMPTS = {20, 15, 10};    // Tentativas por dificuldade
    
    // Tamanho das cartas adaptável por dificuldade
    final int[] CARD_SIZES = {120, 120, 90}; // Tamanho para cada dificuldade
    int CARD_SIZE; // Será definido com base na dificuldade
    final int CARD_MARGIN = 10;
    
    // Configuração de rede - definir como false para usar apenas imagens geradas
    boolean online = false;
    
    // Animação e efeitos
    final int CARD_FLIP_FRAMES = 8;  // Duração da animação de virar carta
    
    // Atributos do jogo
    private int[] cards;
    private boolean[] revealed;
    private boolean[] matched;
    private float[] cardFlipProgress; // 0 = fechada, 1 = aberta
    
    private int GRID_ROWS;
    private int GRID_COLS;
    
    // Estados do jogo
    private GameState currentState;
    private Difficulty currentDifficulty = Difficulty.MEDIUM;
    private int selectedCard1 = -1;
    private int selectedCard2 = -1;
    private int matchedPairs = 0;
    private int attempts = 0;
    private int maxAttempts;
    
    // Sistema de tempo e pontuação
    private int previewTimer;
    private int gameTimer;
    private int score;
    private int[] highScores = {0, 0, 0}; // Recordes para cada dificuldade
    
    // Recursos visuais
    private PImage[] cardImages;
    private PImage cardBack;
    private PFont gameFont;
    
    MemoryGame() {
        // Carregar recursos
        try {
            gameFont = createFont("Arial", 16, true);
        } catch (Exception e) {
            println("Erro ao carregar fonte: " + e.getMessage());
            // Usar fonte padrão se necessário
        }
        
        // Configurar tamanho inicial da grade
        GRID_ROWS = GRID_CONFIG[currentDifficulty.ordinal()][0];
        GRID_COLS = GRID_CONFIG[currentDifficulty.ordinal()][1];
        maxAttempts = MAX_ATTEMPTS[currentDifficulty.ordinal()];
        CARD_SIZE = CARD_SIZES[currentDifficulty.ordinal()];
        
        // Criar imagens do verso das cartas
        cardBack = createCardBackImage();
        
        // Iniciar no menu principal
        currentState = GameState.MENU;
        
        // Inicializar pontuações
        for (int i = 0; i < highScores.length; i++) {
            highScores[i] = 0;
        }
    }
    
    private void loadImages() {
        println("Criando imagens para o jogo...");
        println("Tamanho das cartas: " + CARD_SIZE + "x" + CARD_SIZE);
        
        // Recriar a imagem do verso da carta com o tamanho correto
        cardBack = createCardBackImage();
        
        // Calcular número de pares necessários
        int pairsCount = (GRID_ROWS * GRID_COLS) / 2;
        cardImages = new PImage[pairsCount];
        
        // Usar apenas imagens geradas localmente
        for (int i = 0; i < pairsCount; i++) {
            // Gerar imagem com formas e cores diferentes
            cardImages[i] = createCardImage(i);
            println("Imagem " + (i+1) + " de " + pairsCount + " criada");
        }
        
        println("Carregamento de imagens concluído!");
    }
    
    private PImage createCardBackImage() {
        // Criar uma imagem para o verso da carta
        PImage img = createImage(CARD_SIZE, CARD_SIZE, ARGB);
        img.loadPixels();
        
        // Preencher com um padrão
        for (int y = 0; y < CARD_SIZE; y++) {
            for (int x = 0; x < CARD_SIZE; x++) {
                // Criar um padrão simples
                if ((x / 10 + y / 10) % 2 == 0) {
                    img.pixels[y * CARD_SIZE + x] = color(80, 80, 90);
                } else {
                    img.pixels[y * CARD_SIZE + x] = color(60, 60, 70);
                }
                
                // Borda da carta
                if (x < 3 || y < 3 || x >= CARD_SIZE - 3 || y >= CARD_SIZE - 3) {
                    img.pixels[y * CARD_SIZE + x] = color(40, 40, 45);
                }
            }
        }
        
        img.updatePixels();
        return img;
    }
    
    private PImage createCardImage(int index) {
        // Criar uma imagem para a carta
        PImage img = createImage(CARD_SIZE, CARD_SIZE, ARGB);
        img.loadPixels();
        
        // Gerar cores mais vibrantes para cada carta
        color bgColor = color(240, 240, 240);
        color[] colors = {
            color(255, 87, 51),   // Laranja vibrante
            color(29, 233, 182),  // Turquesa
            color(255, 45, 85),   // Rosa choque
            color(88, 86, 214),   // Roxo
            color(255, 204, 0),   // Amarelo
            color(0, 122, 255),   // Azul
            color(76, 217, 100),  // Verde
            color(255, 149, 0),   // Laranja
            color(94, 53, 177),   // Roxo escuro
            color(255, 59, 48)    // Vermelho
        };
        
        color mainColor = colors[index % colors.length];
        color secondaryColor = colors[(index + 5) % colors.length];
        
        // Preencher fundo
        for (int y = 0; y < CARD_SIZE; y++) {
            for (int x = 0; x < CARD_SIZE; x++) {
                img.pixels[y * CARD_SIZE + x] = bgColor;
                
                // Borda da carta
                if (x < 3 || y < 3 || x >= CARD_SIZE - 3 || y >= CARD_SIZE - 3) {
                    img.pixels[y * CARD_SIZE + x] = color(180, 180, 180);
                }
            }
        }
        
        // Desenhar forma baseada no índice
        switch (index % 10) {
            case 0: // Círculo
                drawCircle(img, mainColor);
                break;
            case 1: // Quadrado
                drawSquare(img, mainColor);
                break;
            case 2: // Triângulo
                drawTriangle(img, mainColor);
                break;
            case 3: // Estrela
                drawStar(img, mainColor);
                break;
            case 4: // Coração
                drawHeart(img, mainColor);
                break;
            case 5: // Losango
                drawDiamond(img, mainColor);
                break;
            case 6: // Cruz
                drawCross(img, mainColor);
                break;
            case 7: // Lua
                drawMoon(img, mainColor);
                break;
            case 8: // Espiral
                drawSpiral(img, mainColor, secondaryColor);
                break;
            case 9: // Hexágono
                drawHexagon(img, mainColor);
                break;
        }
        
        img.updatePixels();
        return img;
    }
    
    // Funções para desenhar formas nas imagens das cartas
    private void drawCircle(PImage img, color c) {
        int center = CARD_SIZE / 2;
        int radius = CARD_SIZE / 3;
        
        for (int y = 0; y < CARD_SIZE; y++) {
            for (int x = 0; x < CARD_SIZE; x++) {
                float dist = sqrt(pow(x - center, 2) + pow(y - center, 2));
                if (dist < radius) {
                    img.pixels[y * CARD_SIZE + x] = c;
                }
            }
        }
    }
    
    private void drawSquare(PImage img, color c) {
        int margin = CARD_SIZE / 4;
        
        for (int y = margin; y < CARD_SIZE - margin; y++) {
            for (int x = margin; x < CARD_SIZE - margin; x++) {
                img.pixels[y * CARD_SIZE + x] = c;
            }
        }
    }
    
    private void drawTriangle(PImage img, color c) {
        int center = CARD_SIZE / 2;
        int height = CARD_SIZE / 2;
        
        for (int y = center; y < center + height; y++) {
            int width = (y - center) * 2;
            for (int x = center - width / 2; x < center + width / 2; x++) {
                if (x >= 0 && x < CARD_SIZE && y >= 0 && y < CARD_SIZE) {
                    img.pixels[y * CARD_SIZE + x] = c;
                }
            }
        }
    }
    
    private void drawStar(PImage img, color c) {
        int center = CARD_SIZE / 2;
        int radius = CARD_SIZE / 3;
        
        for (int angle = 0; angle < 360; angle += 5) {
            float rad = radians(angle);
            int r = (angle % 36 < 18) ? radius : radius / 2;
            int x = center + int(cos(rad) * r);
            int y = center + int(sin(rad) * r);
            
            if (x >= 0 && x < CARD_SIZE && y >= 0 && y < CARD_SIZE) {
                img.pixels[y * CARD_SIZE + x] = c;
                
                // Preencher um pouco em volta para tornar mais espesso
                for (int dx = -1; dx <= 1; dx++) {
                    for (int dy = -1; dy <= 1; dy++) {
                        int nx = x + dx;
                        int ny = y + dy;
                        if (nx >= 0 && nx < CARD_SIZE && ny >= 0 && ny < CARD_SIZE) {
                            img.pixels[ny * CARD_SIZE + nx] = c;
                        }
                    }
                }
            }
        }
    }
    
    private void drawHeart(PImage img, color c) {
        int center = CARD_SIZE / 2;
        int size = CARD_SIZE / 3;
        
        for (int y = 0; y < CARD_SIZE; y++) {
            for (int x = 0; x < CARD_SIZE; x++) {
                // Fórmula para desenhar um coração
                float dx = abs(x - center) / float(size);
                float dy = (y - center) / float(size);
                
                if (pow(dx, 2) + pow(dy - 0.5 * sqrt(abs(dx)), 2) < 1) {
                    img.pixels[y * CARD_SIZE + x] = c;
                }
            }
        }
    }
    
    private void drawDiamond(PImage img, color c) {
        int center = CARD_SIZE / 2;
        int size = CARD_SIZE / 3;
        
        for (int y = 0; y < CARD_SIZE; y++) {
            for (int x = 0; x < CARD_SIZE; x++) {
                if (abs(x - center) + abs(y - center) < size) {
                    img.pixels[y * CARD_SIZE + x] = c;
                }
            }
        }
    }
    
    private void drawCross(PImage img, color c) {
        int center = CARD_SIZE / 2;
        int size = CARD_SIZE / 5;
        
        for (int y = 0; y < CARD_SIZE; y++) {
            for (int x = 0; x < CARD_SIZE; x++) {
                if ((abs(x - center) < size) || (abs(y - center) < size)) {
                    img.pixels[y * CARD_SIZE + x] = c;
                }
            }
        }
    }
    
    private void drawMoon(PImage img, color c) {
        int center = CARD_SIZE / 2;
        int radiusOuter = CARD_SIZE / 3;
        int radiusInner = CARD_SIZE / 5;
        int offset = CARD_SIZE / 10;
        
        for (int y = 0; y < CARD_SIZE; y++) {
            for (int x = 0; x < CARD_SIZE; x++) {
                float distOuter = sqrt(pow(x - center, 2) + pow(y - center, 2));
                float distInner = sqrt(pow(x - (center + offset), 2) + pow(y - center, 2));
                
                if (distOuter < radiusOuter && distInner > radiusInner) {
                    img.pixels[y * CARD_SIZE + x] = c;
                }
            }
        }
    }
    
    // Novos desenhos para as cartas
    private void drawSpiral(PImage img, color c1, color c2) {
        int center = CARD_SIZE / 2;
        float maxRadius = CARD_SIZE * 0.4;
        
        for (float angle = 0; angle < 15 * PI; angle += 0.1) {
            float radius = maxRadius * angle / (15 * PI);
            int x = center + int(cos(angle) * radius);
            int y = center + int(sin(angle) * radius);
            
            if (x >= 0 && x < CARD_SIZE && y >= 0 && y < CARD_SIZE) {
                // Alternar cores
                color c = (int(angle / 0.5) % 2 == 0) ? c1 : c2;
                
                // Desenhar ponto mais espesso
                for (int dx = -2; dx <= 2; dx++) {
                    for (int dy = -2; dy <= 2; dy++) {
                        int nx = x + dx;
                        int ny = y + dy;
                        if (nx >= 0 && nx < CARD_SIZE && ny >= 0 && ny < CARD_SIZE) {
                            img.pixels[ny * CARD_SIZE + nx] = c;
                        }
                    }
                }
            }
        }
    }
    
    private void drawHexagon(PImage img, color c) {
        int center = CARD_SIZE / 2;
        int radius = CARD_SIZE / 3;
        
        for (int i = 0; i < 6; i++) {
            float angle1 = PI / 3 * i;
            float angle2 = PI / 3 * (i + 1);
            
            int x1 = center + int(cos(angle1) * radius);
            int y1 = center + int(sin(angle1) * radius);
            int x2 = center + int(cos(angle2) * radius);
            int y2 = center + int(sin(angle2) * radius);
            
            // Desenhar linha
            drawLine(img, x1, y1, x2, y2, c, 3);
            
            // Preencher hexágono
            fillHexagon(img, center, center, radius, c);
        }
    }
    
    private void drawLine(PImage img, int x1, int y1, int x2, int y2, color c, int thickness) {
        // Algoritmo de Bresenham para desenhar linha
        int dx = abs(x2 - x1);
        int dy = abs(y2 - y1);
        int sx = (x1 < x2) ? 1 : -1;
        int sy = (y1 < y2) ? 1 : -1;
        int err = dx - dy;
        
        while (true) {
            // Desenhar ponto espesso
            for (int tx = -thickness/2; tx <= thickness/2; tx++) {
                for (int ty = -thickness/2; ty <= thickness/2; ty++) {
                    int nx = x1 + tx;
                    int ny = y1 + ty;
                    if (nx >= 0 && nx < CARD_SIZE && ny >= 0 && ny < CARD_SIZE) {
                        img.pixels[ny * CARD_SIZE + nx] = c;
                    }
                }
            }
            
            if (x1 == x2 && y1 == y2) break;
            int e2 = 2 * err;
            if (e2 > -dy) { err -= dy; x1 += sx; }
            if (e2 < dx) { err += dx; y1 += sy; }
        }
    }
    
    private void fillHexagon(PImage img, int centerX, int centerY, int radius, color c) {
        // Preenchimento simples de hexágono
        for (int y = centerY - radius; y <= centerY + radius; y++) {
            for (int x = centerX - radius; x <= centerX + radius; x++) {
                if (x >= 0 && x < CARD_SIZE && y >= 0 && y < CARD_SIZE) {
                    // Usar distância Manhattan modificada para hexágono
                    float dx = abs(x - centerX);
                    float dy = abs(y - centerY);
                    if (dx * 0.5 + dy * 0.866 < radius * 0.75) {
                        img.pixels[y * CARD_SIZE + x] = c;
                    }
                }
            }
        }
    }

    void initializeGame() {
        // Configurar tamanho da grade baseado na dificuldade
        GRID_ROWS = GRID_CONFIG[currentDifficulty.ordinal()][0];
        GRID_COLS = GRID_CONFIG[currentDifficulty.ordinal()][1];
        maxAttempts = MAX_ATTEMPTS[currentDifficulty.ordinal()];
        CARD_SIZE = CARD_SIZES[currentDifficulty.ordinal()];
        
        // Carregar imagens de acordo com o número de pares
        loadImages();
        
        // Inicialização dos arrays
        int totalCards = GRID_ROWS * GRID_COLS;
        cards = new int[totalCards];
        revealed = new boolean[totalCards];
        matched = new boolean[totalCards];
        cardFlipProgress = new float[totalCards];

        // Gerar pares de cartas
        for (int i = 0; i < totalCards; i++) {
            cards[i] = i / 2;
            cardFlipProgress[i] = 0; // Todas as cartas começam fechadas
        }
        
        // Embaralhar cartas
        for (int i = totalCards - 1; i > 0; i--) {
            int j = int(random(i + 1));
            int temp = cards[i];
            cards[i] = cards[j];
            cards[j] = temp;
        }
        
        // Mostrar todas as cartas no início
        previewTimer = PREVIEW_TIME[currentDifficulty.ordinal()];
        for (int i = 0; i < totalCards; i++) {
            revealed[i] = true;
            cardFlipProgress[i] = 1; // Cartas totalmente abertas durante o preview
        }
        
        // Resetar valores do jogo
        currentState = GameState.PREVIEW;
        selectedCard1 = -1;
        selectedCard2 = -1;
        matchedPairs = 0;
        attempts = 0;
        gameTimer = 0;
        score = 0;
    }

    void update() {
        if (currentState == GameState.PREVIEW) {
            previewTimer--;
            if (previewTimer <= 0) {
                // Esconder todas as cartas após o tempo de preview
                for (int i = 0; i < cards.length; i++) {
                    revealed[i] = false;
                    // Iniciar animação de virar todas as cartas
                    thread("animateAllCardsFlip");
                }
                currentState = GameState.PLAYING;
            }
        } else if (currentState == GameState.PLAYING) {
            // Atualizar timer do jogo
            gameTimer++;
            
            // Atualizar animações das cartas
            updateCardAnimations();
        }
    }
    
    void updateCardAnimations() {
        for (int i = 0; i < cards.length; i++) {
            // Animar cartas sendo reveladas
            if (revealed[i] && cardFlipProgress[i] < 1) {
                cardFlipProgress[i] += 1.0 / CARD_FLIP_FRAMES;
                if (cardFlipProgress[i] > 1) cardFlipProgress[i] = 1;
            } 
            // Animar cartas sendo escondidas
            else if (!revealed[i] && cardFlipProgress[i] > 0) {
                cardFlipProgress[i] -= 1.0 / CARD_FLIP_FRAMES;
                if (cardFlipProgress[i] < 0) cardFlipProgress[i] = 0;
            }
        }
    }
    
    // Função executada em thread separada para animar todas as cartas juntas
    void animateAllCardsFlip() {
        for (int f = 0; f < CARD_FLIP_FRAMES; f++) {
            for (int i = 0; i < cards.length; i++) {
                cardFlipProgress[i] = max(0, 1 - (float)f / CARD_FLIP_FRAMES);
            }
            delay(1000 / 60); // Aproximadamente 60 FPS
        }
    }

    void display() {
        switch(currentState) {
            case MENU:
                displayMenu();
                break;
            case SETTINGS:
                displaySettings();
                break;
            case PREVIEW:
            case PLAYING:
                displayGameBoard();
                break;
            case GAME_OVER:
                displayGameOver();
                break;
        }
    }

    private void displayMenu() {
        background(240);
        textFont(gameFont);
        textAlign(CENTER, CENTER);
        
        // Título
        textSize(48);
        fill(0, 122, 255);
        text("JOGO DA MEMÓRIA", width/2, height/4);
        
        // Botões
        int buttonY = height/2;
        int buttonSpacing = 100;
        
        // Botão Iniciar
        displayButton("Iniciar Jogo", width/2, buttonY, 250, 60);
        
        // Botão Configurações
        displayButton("Configurações", width/2, buttonY + buttonSpacing, 250, 60);
        
        // Mostrar dificuldade atual
        textSize(20);
        fill(100);
        text("Dificuldade atual: " + getDifficultyName(currentDifficulty), width/2, height - 80);
        
        // Mostrar recorde
        text("Recorde: " + highScores[currentDifficulty.ordinal()], width/2, height - 50);
    }
    
    private void displaySettings() {
        background(240);
        textFont(gameFont);
        textAlign(CENTER, CENTER);
        
        // Título
        textSize(36);
        fill(0, 122, 255);
        text("CONFIGURAÇÕES", width/2, height/4);
        
        // Opções de dificuldade
        int buttonY = height/2 - 50;
        int buttonSpacing = 80;
        
        // Botão de Dificuldade Fácil
        if (currentDifficulty == Difficulty.EASY) fill(0, 180, 0, 100);
        else fill(0, 122, 255);
        rect(width/2 - 125, buttonY, 250, 60, 10);
        fill(255);
        textSize(24);
        text("Fácil", width/2, buttonY + 30);
        
        // Botão de Dificuldade Média
        if (currentDifficulty == Difficulty.MEDIUM) fill(0, 180, 0, 100);
        else fill(0, 122, 255);
        rect(width/2 - 125, buttonY + buttonSpacing, 250, 60, 10);
        fill(255);
        text("Médio", width/2, buttonY + buttonSpacing + 30);
        
        // Botão de Dificuldade Difícil
        if (currentDifficulty == Difficulty.HARD) fill(0, 180, 0, 100);
        else fill(0, 122, 255);
        rect(width/2 - 125, buttonY + 2 * buttonSpacing, 250, 60, 10);
        fill(255);
        text("Difícil", width/2, buttonY + 2 * buttonSpacing + 30);
        
        // Botão Voltar
        fill(150, 150, 150);
        rect(width/2 - 125, buttonY + 3 * buttonSpacing, 250, 60, 10);
        fill(255);
        text("Voltar", width/2, buttonY + 3 * buttonSpacing + 30);
    }

    private void displayGameBoard() {
        background(240);
        textFont(gameFont);
        
        // Calcular posição inicial para centralizar o tabuleiro
        float startX = (width - (GRID_COLS * (CARD_SIZE + CARD_MARGIN))) / 2;
        float startY = (height - (GRID_ROWS * (CARD_SIZE + CARD_MARGIN))) / 2;
        
        // Desenhar cartas com animação
        for (int i = 0; i < cards.length; i++) {
            int row = i / GRID_COLS;
            int col = i % GRID_COLS;
            
            float x = startX + col * (CARD_SIZE + CARD_MARGIN);
            float y = startY + row * (CARD_SIZE + CARD_MARGIN);
            
            // Efeito de escala para animação de flip
            float scaleFactor = abs(cardFlipProgress[i] - 0.5) * 2;
            
            pushMatrix();
            translate(x + CARD_SIZE/2, y + CARD_SIZE/2);
            scale(scaleFactor, 1);
            
            if (cardFlipProgress[i] > 0.5) {
                // Carta virada para cima
                if (matched[i]) {
                    // Cartas correspondidas (semi-transparentes)
                    tint(255, 100);
                    image(cardImages[cards[i]], -CARD_SIZE/2, -CARD_SIZE/2);
                    noTint();
                } else {
                    // Cartas reveladas
                    image(cardImages[cards[i]], -CARD_SIZE/2, -CARD_SIZE/2);
                }
            } else {
                // Carta virada para baixo
                image(cardBack, -CARD_SIZE/2, -CARD_SIZE/2);
            }
            
            popMatrix();
        }

        // Mostrar informações do jogo
        displayGameInfo();
        
        // Mostrar contador de preview
        if (currentState == GameState.PREVIEW) {
            textAlign(CENTER, CENTER);
            textSize(36);
            fill(0);
            text("Memorize! " + (previewTimer / 60 + 1), width/2, 50);
        }
    }

    private void displayGameInfo() {
        textSize(20);
        fill(0);
        textAlign(LEFT);
        
        // Mostrar dificuldade
        text("Dificuldade: " + getDifficultyName(currentDifficulty), 20, 30);
        
        // Mostrar tentativas
        text("Tentativas: " + attempts + "/" + maxAttempts, 20, 60);
        
        // Mostrar pares encontrados
        text("Pares: " + matchedPairs + "/" + (cards.length / 2), 20, 90);
        
        // Mostrar tempo
        int seconds = gameTimer / 60;
        text("Tempo: " + nf(seconds / 60, 2) + ":" + nf(seconds % 60, 2), 20, 120);
        
        // Mostrar pontuação atual
        textAlign(RIGHT);
        text("Pontuação: " + calculateScore(), width - 20, 30);
    }

    private void displayGameOver() {
        background(240);
        textFont(gameFont);
        textAlign(CENTER, CENTER);
        
        // Calcular pontuação final
        int finalScore = calculateScore();
        // Verificar se é um novo recorde
        boolean isNewHighScore = finalScore > highScores[currentDifficulty.ordinal()];
        if (isNewHighScore) {
            highScores[currentDifficulty.ordinal()] = finalScore;
        }
        
        // Título
        textSize(36);
        
        if (matchedPairs == cards.length / 2) {
            fill(0, 122, 255);
            text("PARABÉNS! VOCÊ VENCEU!", width/2, height/4 - 30);
        } else {
            fill(255, 45, 85);
            text("FIM DE JOGO", width/2, height/4 - 30);
        }
        
        // Mostrar estatísticas
        textSize(24);
        fill(0);
        int statsY = height/2 - 80;
        int lineHeight = 35;
        
        text("Pares encontrados: " + matchedPairs + "/" + (cards.length / 2), width/2, statsY);
        text("Tentativas utilizadas: " + attempts, width/2, statsY + lineHeight);
        
        int seconds = gameTimer / 60;
        text("Tempo: " + nf(seconds / 60, 2) + ":" + nf(seconds % 60, 2), width/2, statsY + 2 * lineHeight);
        
        // Mostrar pontuação
        fill(0, 180, 0);
        textSize(30);
        text("Pontuação: " + finalScore, width/2, statsY + 3 * lineHeight);
        
        // Mostrar novo recorde
        if (isNewHighScore) {
            fill(255, 200, 0);
            textSize(28);
            text("NOVO RECORDE!", width/2, statsY + 4 * lineHeight);
        }
        
        // Botões
        int buttonY = height - 140;
        
        // Botão de Nova Partida
        displayButton("Nova Partida", width/2, buttonY, 250, 60);
        
        // Botão de Menu Principal
        displayButton("Menu Principal", width/2, buttonY + 80, 250, 60);
    }
    
    // Helper para exibir botões padronizados
    private void displayButton(String text, float x, float y, float w, float h) {
        // Verificar se o mouse está sobre o botão
        boolean hover = mouseX > x - w/2 && mouseX < x + w/2 && 
                       mouseY > y - h/2 && mouseY < y + h/2;
        
        // Cor do botão
        if (hover) fill(0, 150, 255);
        else fill(0, 122, 255);
        
        // Desenhar botão
        rect(x - w/2, y - h/2, w, h, 10);
        
        // Texto do botão
        fill(255);
        textSize(24);
        textAlign(CENTER, CENTER);
        text(text, x, y);
    }
    
    // Calcular pontuação baseada em tempo, tentativas e dificuldade
    private int calculateScore() {
        if (currentState != GameState.GAME_OVER && matchedPairs < cards.length / 2) {
            // Pontuação durante o jogo
            return matchedPairs * 100;
        } else {
            // Pontuação final
            int timeBonus = max(0, 3000 - (gameTimer / 60) * 10); // Menos tempo = mais pontos
            int attemptBonus = max(0, maxAttempts - attempts) * 50; // Menos tentativas = mais pontos
            int difficultyMultiplier = currentDifficulty.ordinal() + 1; // Fácil=1, Médio=2, Difícil=3
            
            return (matchedPairs * 100 + timeBonus + attemptBonus) * difficultyMultiplier;
        }
    }
    
    // Converter enum de dificuldade para texto
    private String getDifficultyName(Difficulty diff) {
        switch(diff) {
            case EASY: return "Fácil";
            case MEDIUM: return "Médio";
            case HARD: return "Difícil";
            default: return "";
        }
    }

    void handleMousePressed() {
        switch(currentState) {
            case MENU:
                handleMenuClick();
                break;
            case SETTINGS:
                handleSettingsClick();
                break;
            case PLAYING:
                handleGameClick();
                break;
            case GAME_OVER:
                handleGameOverClick();
                break;
            // Ignorar cliques durante o preview
            case PREVIEW:
                break;
        }
    }

    private void handleMenuClick() {
        // Botão Iniciar
        if (isButtonClicked("Iniciar Jogo", width/2, height/2, 250, 60)) {
            initializeGame();
        }
        
        // Botão Configurações
        if (isButtonClicked("Configurações", width/2, height/2 + 100, 250, 60)) {
            currentState = GameState.SETTINGS;
        }
    }
    
    private void handleSettingsClick() {
        int buttonY = height/2 - 50;
        int buttonSpacing = 80;
        
        // Botão Fácil
        if (mouseX > width/2 - 125 && mouseX < width/2 + 125 &&
            mouseY > buttonY - 30 && mouseY < buttonY + 30) {
            currentDifficulty = Difficulty.EASY;
            CARD_SIZE = CARD_SIZES[currentDifficulty.ordinal()];
            // Recriar a carta de fundo para o novo tamanho
            cardBack = createCardBackImage();
        }
        
        // Botão Médio
        if (mouseX > width/2 - 125 && mouseX < width/2 + 125 &&
            mouseY > buttonY + buttonSpacing - 30 && mouseY < buttonY + buttonSpacing + 30) {
            currentDifficulty = Difficulty.MEDIUM;
            CARD_SIZE = CARD_SIZES[currentDifficulty.ordinal()];
            // Recriar a carta de fundo para o novo tamanho
            cardBack = createCardBackImage();
        }
        
        // Botão Difícil
        if (mouseX > width/2 - 125 && mouseX < width/2 + 125 &&
            mouseY > buttonY + 2 * buttonSpacing - 30 && mouseY < buttonY + 2 * buttonSpacing + 30) {
            currentDifficulty = Difficulty.HARD;
            CARD_SIZE = CARD_SIZES[currentDifficulty.ordinal()];
            // Recriar a carta de fundo para o novo tamanho
            cardBack = createCardBackImage();
        }
        
        // Botão Voltar
        if (mouseX > width/2 - 125 && mouseX < width/2 + 125 &&
            mouseY > buttonY + 3 * buttonSpacing - 30 && mouseY < buttonY + 3 * buttonSpacing + 30) {
            currentState = GameState.MENU;
        }
    }

    private void handleGameClick() {
        // Ignorar cliques se já houver duas cartas selecionadas ou animações em andamento
        if (selectedCard1 != -1 && selectedCard2 != -1) return;
        
        // Calcular posição inicial para centralizar o tabuleiro
        float startX = (width - (GRID_COLS * (CARD_SIZE + CARD_MARGIN))) / 2;
        float startY = (height - (GRID_ROWS * (CARD_SIZE + CARD_MARGIN))) / 2;
        
        // Verificar clique nas cartas
        for (int i = 0; i < cards.length; i++) {
            int row = i / GRID_COLS;
            int col = i % GRID_COLS;
            
            float x = startX + col * (CARD_SIZE + CARD_MARGIN);
            float y = startY + row * (CARD_SIZE + CARD_MARGIN);
            
            if (mouseX > x && mouseX < x + CARD_SIZE &&
                mouseY > y && mouseY < y + CARD_SIZE &&
                !revealed[i] && !matched[i]) {
                
                // Ignorar cliques durante animações
                boolean animationInProgress = false;
                for (int j = 0; j < cards.length; j++) {
                    if (cardFlipProgress[j] > 0 && cardFlipProgress[j] < 1) {
                        animationInProgress = true;
                        break;
                    }
                }
                
                if (!animationInProgress) {
                    revealCard(i);
                }
                break;
            }
        }
    }

    private void revealCard(int index) {
        revealed[index] = true;
        
        if (selectedCard1 == -1) {
            // Primeira carta selecionada
            selectedCard1 = index;
        } else {
            // Segunda carta selecionada
            selectedCard2 = index;
            attempts++;
            
            // Verificar correspondência após um curto delay
            thread("checkMatch");
        }
    }
    
    // Esta função será executada em uma thread separada
    void checkMatch() {
        // Deixar a animação de flip terminar
        delay(CARD_FLIP_FRAMES * 16);
        
        if (cards[selectedCard1] == cards[selectedCard2]) {
            // Par encontrado
            matched[selectedCard1] = true;
            matched[selectedCard2] = true;
            matchedPairs++;
            
            // Verificar condição de vitória
            if (matchedPairs == cards.length / 2) {
                currentState = GameState.GAME_OVER;
            }
        } else {
            // Par não corresponde
            revealed[selectedCard1] = false;
            revealed[selectedCard2] = false;
        }
        
        // Resetar seleção
        selectedCard1 = -1;
        selectedCard2 = -1;
        
        // Verificar condição de derrota
        if (attempts >= maxAttempts) {
            currentState = GameState.GAME_OVER;
        }
    }

    private void handleGameOverClick() {
        int buttonY = height - 140;
        
        // Botão Nova Partida
        if (isButtonClicked("Nova Partida", width/2, buttonY, 250, 60)) {
            initializeGame();
        }
        
        // Botão Menu Principal
        if (isButtonClicked("Menu Principal", width/2, buttonY + 80, 250, 60)) {
            currentState = GameState.MENU;
        }
    }
    
    // Helper para verificar clique em botão
    private boolean isButtonClicked(String text, float x, float y, float w, float h) {
        return mouseX > x - w/2 && mouseX < x + w/2 && 
               mouseY > y - h/2 && mouseY < y + h/2;
    }
}

// Variável global do jogo
MemoryGame game;

void setup() {
    size(800, 600);
    smooth();
    
    // Inicializar jogo
    game = new MemoryGame();
}

void draw() {
    game.update();
    game.display();
}

void mousePressed() {
    game.handleMousePressed();
}

// Funções de thread usadas pelo jogo
void animateAllCardsFlip() {
    if (game != null) {
        game.animateAllCardsFlip();
    }
}

void checkMatch() {
    if (game != null) {
        game.checkMatch();
    }
} 