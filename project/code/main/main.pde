import processing.sound.*;
import java.util.Calendar;
import java.util.Date;

/* Screen Resolution */
final int displayWidth = 800;
final int displayHeight = 600;

/* Constants */
final int TOTAL_NUM_GAMES = 15;
final int NUM_GAMES_CAT = 5;

/* Game is over FLAG */
boolean FINISH_FLAG = false;

/* Game Sounds */
SoundFile distanceSound;            /* Proximity Sound */
SoundFile winSound;                 /* Target Reached Sounds */ 
SoundFile finishSound;              /* Game Finished Sound */

Game game;

long diffSec, diffMin, diffHour;    /* Game Duration Time Units */

/* This variables are used to avoid calculations in each iteration */
long ampMin, ampSec;                   
long rateSec, rateMin;
long ampRateSec, ampRateMin;

int numPlayedGames = 1;
int gamemode = 1;                   /* Game Mode: Amp, Rate or Amp & Rate */

int ampGamesTime = 0;              /* Amp Duration Time */
int rateGamesTime = 0;             /* Rate Duration Time */
int ampRateGamesTime = 0;          /* Amp & Rate Duration Time */

/* Player Shapes */
String snorlax = "snorlax.svg";     /* Player 1 Shape */
String burger = "burger.svg";       /* Target Shape */

void setup() {

    size(displayWidth, displayHeight);
    background(#2c3e50);
    shapeMode(CENTER);
    //smooth(4);
    //frameRate(30);

    winSound = new SoundFile(this, "winSound.mp3");
    winSound.amp(0.3);
    
    finishSound = new SoundFile(this, "finish.mp3");
    finishSound.amp(0.6);

    distanceSound = new SoundFile(this, "beep1.wav");

    game = new Game();
  
}

void draw() {

    background(#2c3e50);
    
    if (game.checkFinished()) {
        
        if (numPlayedGames == TOTAL_NUM_GAMES) {
          
            if (FINISH_FLAG == false) {
                
                finishSound.play();
                
                long totalTime = ampGamesTime + rateGamesTime + ampRateGamesTime;
                diffSec = totalTime / 1000 % 60;
                diffMin = totalTime / (60 * 1000) % 60;
                diffHour = totalTime / (60 * 60 * 1000) % 24;
                
                ampSec = (int) (ampGamesTime / NUM_GAMES_CAT) / 1000 % 60;
                ampMin = (int) (ampGamesTime / NUM_GAMES_CAT) / (60 * 1000) % 60;

                rateSec = (int) (rateGamesTime/NUM_GAMES_CAT) / 1000 % 60;
                rateMin = (int) (rateGamesTime / NUM_GAMES_CAT) / (60 * 1000) % 60;

                ampRateSec = (int) (ampRateGamesTime/NUM_GAMES_CAT) / 1000 % 60;
                ampRateMin = (int) (ampRateGamesTime / NUM_GAMES_CAT) / (60 * 1000) % 60;

                FINISH_FLAG = true;
            }
            
            textAlign(CENTER, CENTER);
            textSize(27);
            fill(#25CCF7);
            text("Amp Games Average Time: " + ampMin + " min, " + ampSec + " s", width / 2, height / 2 - 100);  
            text("Rate Games Average Time: " + rateMin + " min, " + rateSec + " seg", width / 2, height / 2 - 50);  
            text("Amp & Rate Games Average Time: " + ampRateMin + " min, " + ampRateSec + " seg", width / 2, height / 2);
            
            
            text("Total Time: " + diffHour + " horas, " + diffMin  + " min, " + diffSec + "s", width / 2, height / 2 + 50);
            textSize(20);
            text("Presiona cualquier tecla para salir...", width / 2, height / 2 + 150);
            
        } else if (numPlayedGames <= TOTAL_NUM_GAMES){
            winSound.play(); 
            
            if (numPlayedGames < 5) {
                ampGamesTime += game.getDuration();
                gamemode = 1;
            } else if (numPlayedGames < 10) {
                rateGamesTime += game.getDuration();
                gamemode = 2;
            } else {
                ampRateGamesTime += game.getDuration();
                gamemode = 3;
            }
            game = new Game();
            numPlayedGames++;
       }        
    } else {

        game.run();
        textSize(20);
        text("[+] Partida " + (numPlayedGames), 10, 30);  
        if (gamemode == 1) {
            text("[+] Modo de juego: AMP", 10, 60);    
        } else if (gamemode == 2) {
            text("[+] Modo de juego: RATE", 10, 60);    
        } else {
            text("[+] Modo de juego: AMP & RATE", 10, 60);    
        }
    }

}

/* Events cant be fired iside classes */ 
void keyPressed() {

    /* If game over, exit */
    if (FINISH_FLAG == true)
        exit();
    
    game.keyPressed();
}

void keyReleased() {
    game.keyReleased();
}

class Game {

    final int winDistance = 15;         /* Minimum Distance required to finish the game */
    final int noiseDistance = 500;      /* Minimum Distance required to rate and amp helps start */
    final float dftAmp = 0.5;
    final float dftRate = 0.5;
    
    long startTime, finishTime;


    Player player1, target;

    /* Default Constrcutor */
    Game() {
        this.player1 = new Player(snorlax);
        this.target = new Player(burger, 40.0, 40.0);
        while( sqrt( pow( (target.pos[0] - player1.pos[0]), 2) + pow( (target.pos[1] - player1.pos[1]), 2) ) < 400 ) {
            target.initAtRandomPosition();
            player1.initAtRandomPosition();
        };

        this.startTime = System.currentTimeMillis();
        distanceSound.loop();
        distanceSound.amp(0);
        distanceSound.rate(0);
        distanceSound.play();
    }

    void run() {
        player1.run();
        target.run();
        soundControl();
    }

    /* Key Pressed Event Handler */
    void keyPressed() {

        if ( (key == '1') || (key == '2') || (key == '3') ) {
            gamemode = Character.getNumericValue(key);
        } else {
          player1.pressed( (key == 'a' || key == 'A' || keyCode == LEFT), (key == 'd' || key == 'D' || keyCode == RIGHT),
                           (key == 'w' || key == 'W' || keyCode == UP), (key == 's' || key == 'S' || keyCode == DOWN));          
        }    
    }

    /* Key Release Event Handler */
    void keyReleased() {
        player1.released( (key == 'a' || key == 'A' || keyCode == LEFT), (key == 'd' || key == 'D' || keyCode == RIGHT),
                          (key == 'w' || key == 'W' || keyCode == UP), (key == 's' || key == 'S' || keyCode == DOWN));
    }


    /* Controls rate and amp level depending on the distance between players */
    void soundControl() {
    
        final float distance = player1.distanceTo(target.pos);

        if (distance < noiseDistance){
            
            final float lvl = (noiseDistance - distance) / noiseDistance;

            switch (gamemode) {
                case 1:
                    distanceSound.amp( lvl );
                    distanceSound.rate( dftRate );
                    break;
                case 2:
                    distanceSound.amp( dftAmp );
                    distanceSound.rate( lvl );
                    break;
                default:
                    distanceSound.rate( lvl );
                    distanceSound.amp( lvl );
                    break;
            }

        }else{
            distanceSound.amp( 0.1 );
            distanceSound.rate( 0.1 );
        }
    }


    /* Check if the game has finished */
    boolean checkFinished() {
        
        if ( player1.distanceTo(target.pos) < winDistance ) {
            
            finishTime = System.currentTimeMillis();
            distanceSound.stop();
            return true;
        }
      
        return false;
    }

    /* Calcultas difference between two Java Dates */
    long getDuration() {
        return finishTime - startTime;
    }
}


class Player {

    int[] pos = new int[2];                 /* Player Position */
    float shapeWidth = 60;                  /* Default Shape Widht */
    float shapeHeight = 60;                 /* Default Shape Height */ 
    String shapeURI;
    PShape playerShape;                     /* Player Shape */
    float speed = 3.5;                      /* Default Speed */
    float dx = 0, dy = 0; 

    
    /* Default Player Constructor */
    Player(String shapeURI) {
        this.shapeURI = shapeURI;
        initAtRandomPosition();
        playerShape = loadShape(shapeURI);
        
    }

    /* Alternative Player Constructor */
    Player(String shapeURI, float shapeWidth, float shapeHeight) {
        this.shapeWidth = shapeWidth;
        this.shapeHeight = shapeHeight;
        this.shapeURI = shapeURI;
        initAtRandomPosition();
        playerShape = loadShape(shapeURI);
    }

    void initAtRandomPosition() {
        this.pos[0] = int( random(shapeWidth / 2, width - shapeWidth / 2) );
        this.pos[1] = int( random( (shapeHeight / 2), height - shapeHeight / 2) );
    }

    void run() {
        display();
        update();
    }

    void display() {
        shape(this.playerShape, this.pos[0], this.pos[1], shapeWidth, shapeHeight);
    }

    float distanceTo(int[] destPoint) {
        return sqrt( pow( (this.pos[0] - destPoint[0]), 2) + pow( (this.pos[1] - destPoint[1]), 2) );
    }

    void update() {

        if ( ( pos[0] + (dx * speed) ) >= (shapeWidth / 2) && ( ( pos[0] + (dx * speed) ) <= (width - (shapeWidth / 2)) ) ) {
            pos[0] += dx * speed;
        }

        if ( (pos[1] + dy * speed) >= (shapeHeight / 2)&& ( (pos[1] + dy * speed) <= (height - (shapeHeight / 2)) ) ) {
            pos[1] += dy * speed;
        }
    }

    void pressed(boolean left, boolean right, boolean up, boolean down) {
        if (left)  dx = -1;
        if (right) dx =  1;
        if (up)    dy = -1;
        if (down)  dy =  1;
    }


    void released(boolean left, boolean right, boolean up, boolean down) { 
        if (left)  dx = 0;
        if (right) dx = 0;
        if (up)    dy = 0;
        if (down)  dy = 0;
    }

}
