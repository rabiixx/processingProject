import processing.sound.*;
import java.util.Calendar;
import java.util.Date;


/* This is only for debuggin reasons */
//final int seed = 1;
//randomSeed(seed);

/* Screen Resolution */
final int displayWidth = 800;
final int displayHeight = 600;

SoundFile distanceSound;
SoundFile winSound;
Game game;
Game [] PartidasJugadas = new Game[15];
int numeroPartidasJugadas = 0;
int numeroPartidas = 1;
long mediaJuego = 0;
String snorlax = "snorlax.svg";
String burger = "burger.svg";

void setup() {

    size(displayWidth, displayHeight);
    background(#2c3e50);
    shapeMode(CENTER);
    //smooth(4);
    //frameRate(30);

    winSound = new SoundFile(this, "winSound.mp3");
    winSound.amp(0.6);

    distanceSound = new SoundFile(this, "beep1.wav");

    game = new Game();
  
}

void draw() {

    background(#2c3e50);
    
    
    game.run();

    if (game.checkFinished() && numeroPartidas!=numeroPartidasJugadas) {
        PartidasJugadas[numeroPartidasJugadas] = game;
        numeroPartidasJugadas++;
        
        game.getGameDuration();
        winSound.play();
        //delay( int(winSound.duration() * 1000) );
        if(numeroPartidas!=numeroPartidasJugadas){
          game = new Game();
        } else {
            textSize(20);
            for (int i = 0; i < numeroPartidasJugadas; i++){
              PartidasJugadas[i].getGameDuration();
              mediaJuego  = mediaJuego + (PartidasJugadas[i].getGameDuration());
              println("Partida numero: " + (i+1));
              println("Duracion: " + (PartidasJugadas[i].getGameDuration() )  + " milisegundos.");
            
            }
            //La media sale mal
            //En duracion sale un redondeo y en mediaJuego guarda todo (creo)
            println("La media de juego entre las " + numeroPartidasJugadas + " primeras partidas es de " + (mediaJuego / numeroPartidasJugadas) + " milisegundos.");
        }
        
    } else if (game.checkFinished() && numeroPartidas==numeroPartidasJugadas){
       text("Haz click con el ratón.", 10, 260);     
       text("La media de juego entre las " + numeroPartidasJugadas + " partidas es de " + (mediaJuego / numeroPartidasJugadas) + " milisegundos.", 10, 200); 
      
    }

}
void mouseReleased(){
  if (numeroPartidas==numeroPartidasJugadas){
     exit(); 
  }
 
}
/* Events cant be fired iside classes */ 
void keyPressed() {
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
    char gamemode;
    long startTime, finishTime;


    Player player1, target;

    /* Default Constrcutor */
    Game() {
        this.target = new Player(burger);
        
        do{
          this.player1 = new Player(snorlax);
        } while( sqrt( pow( (target.pos[0] - player1.pos[0]), 2) + pow( (target.pos[1] - player1.pos[1]), 2) ) < 500 ) ;
        //this.startTime = Calendar.getInstance().getTime();
        this.startTime = System.currentTimeMillis();
        distanceSound.loop();
        distanceSound.amp(0.1);
        distanceSound.rate(0.1);
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
            gamemode = key;
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
                case '1':
                    distanceSound.amp( lvl );
                    distanceSound.rate( dftRate );
                    break;
                case '2':
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
            //finishTime = Calendar.getInstance().getTime();
            finishTime = System.currentTimeMillis();
            distanceSound.stop();
            return true;
        }
      
        return false;
    }


    /* Calcultas difference between two Java Dates */
    long getGameDuration() {
        long diff = 0;
        try {

            diff = (finishTime - startTime) ;
            /*
            long diffSeconds = diff / 1000 % 60;
            long diffMinutes = diff / (60 * 1000) % 60;
            long diffHours = diff / (60 * 60 * 1000) % 24;
            long diffDays = diff / (24 * 60 * 60 * 1000);
            
            println(diffDays + " days, ");
            println(diffHours + " hours, ");
            println(diffMinutes + " minutes, ");
            println(diffSeconds + " seconds.");
            */
            
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return diff;
    }
}


class Player {

    int[] pos = new int[2];                 /* Player Position */
    float shapeWidth = 60;                  /* Default Shape Widht */
    float shapeHeight = 60;                 /* Default Shape Height */ 
    //String shapeURI = "snorlax.svg";        /* Default Player Shpae URI */
    String shapeURI;
    PShape playerShape;                     /* Player Shape */
    float speed = 3.5;                      /* Default Speed */
    float dx = 0, dy = 0; 

    
    /* Default Player Constructor */
    Player(String shapeURI) {
        super();
        this. shapeURI = shapeURI;
        
        initAtRandomPosition();
        playerShape = loadShape(shapeURI);
        
    }

    /* Alternative Player Constructor */
    Player(float shapeWidth, float shapeHeight, String shapeURI) {
        this.shapeWidth = shapeWidth;
        this.shapeHeight = shapeHeight;
        this.shapeURI = shapeURI;
        playerShape = loadShape(shapeURI);
    }

    void initAtRandomPosition() {
        this.pos[0] = int( random(shapeWidth / 2, width - shapeWidth / 2) );
        this.pos[1] = int( random(shapeHeight / 2, height - shapeHeight / 2) );
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

        if ( (pos[1] + dy * speed) >= (shapeHeight / 2) && ( (pos[1] + dy * speed) <= (height - (shapeHeight / 2)) ) ) {
            pos[1] += dy * speed;
        }

 //       println("pos(" + pos[0] + ", " + pos[1] + ")");
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
