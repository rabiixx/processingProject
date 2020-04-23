import processing.sound.*;

SoundFile file;

float[] ampArr = { 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0 };
int ampLevel = 6;

float[] rateArr = { 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0 };
int rateLevel = 6;

Player player1;

int[] srcPoint = new int[2];
int[] destPoint = new int[2];
PShape bot;

    /* This is only for debuggin reasons */
//final int seed = 1;
//randomSeed(seed);


void setup() {

    size(1024, 1024);
    background(#2c3e50);
    shapeMode(CENTER);
    smooth(4);

    srcPoint[0] = int( random(0, width - 20) );
    srcPoint[1] = int( random(0, height - 20) );
    destPoint[0] = int( random(0, width - 20) );
    destPoint[1] = int( random(0, height - 20) );

    bot = loadShape("burger.svg"); 
    
    println("Src: (" + srcPoint[0] + ", " + srcPoint[1] + ")");
    println("Dest: (" + destPoint[0] + ", " + destPoint[1] + ")");
  
    player1 = new Player(srcPoint, 60, 60, "snorlax.svg");
  
    // Load a soundfile from the /data folder of the sketch and play it back
    file = new SoundFile(this, "beep1.wav");
    file.stop();
  
}

void draw() {
    background(#2c3e50);
    
    shape(bot, destPoint[0], destPoint[1], 40, 40);
    
    /* Source and Destination */     
    stroke(#0fb9b1);
    fill(#c0392b);
    ellipse(srcPoint[0], srcPoint[1], 10, 10);
    
    stroke(#c0392b);
    fill(#0fb9b1);
    ellipse(destPoint[0], destPoint[1], 10, 10);
    
    player1.run();
}

void keyPressed() {
    println(calcCloseness(srcPoint, destPoint));
    player1.pressed( (key == 'a' || key == 'A' || keyCode == LEFT), (key == 'd' || key == 'D' || keyCode == RIGHT),
                     (key == 'w' || key == 'W' || keyCode == UP), (key == 's' || key == 'S' || keyCode == DOWN));
}

void keyReleased() {
    println(calcCloseness(srcPoint, destPoint));
    player1.released( (key == 'a' || key == 'A' || keyCode == LEFT), (key == 'd' || key == 'D' || keyCode == RIGHT),
                      (key == 'w' || key == 'W' || keyCode == UP), (key == 's' || key == 'S' || keyCode == DOWN));
}

float calcCloseness(int[] srcPoint, int[] destPoint) {
  float distancia = sqrt( pow( (srcPoint[0] - destPoint[0]), 2) + pow( (srcPoint[1] - destPoint[1]), 2) );
  if (distancia>=100){
    file.stop();
  } else {
      file.play();
      file.loop();
      
    if(distancia>90 && distancia<100){
      file.amp(ampArr[1]);
      file.rate(rateArr[1]);
    } else if(distancia>80 && distancia<90){
      file.amp(ampArr[2]);
      file.rate(rateArr[2]);
    } else if(distancia>70 && distancia<80){
      file.amp(ampArr[3]);
      file.rate(rateArr[3]);
    } else if(distancia>60 && distancia<70){
      file.amp(ampArr[4]);
      file.rate(rateArr[4]);
    } else if(distancia>50 && distancia<60){
      file.amp(ampArr[5]);
      file.rate(rateArr[5]);
    } else if(distancia>40 && distancia<50){
      file.amp(ampArr[6]);
      file.rate(rateArr[6]);
    } else if(distancia>30 && distancia<40){
      file.amp(ampArr[7]);
      file.rate(rateArr[7]);
    } else if(distancia>20 && distancia<30){
      file.amp(ampArr[8]);
      file.rate(rateArr[8]);
    } else if(distancia>10 && distancia<20){
      file.amp(ampArr[9]);
      file.rate(rateArr[9]);
    } else {
      file.amp(ampArr[10]);
      file.rate(rateArr[10]);
    }
  }
  
  
  return distancia;
}

class Player {

    int[] pos = new int[2];
    float shapeWidth;
    float shapeHeight;
    String shapeURI;        /* Player Shpae URI */
    PShape playerShape;    /* Player Shape */
    float speed = 3.5;
    float dx = 0, dy = 0;


    /**
    * @param {[type]}
    * @param {[type]}
    * @param {[type]}
    * @param {[type]}
    * @param {[type]}
    */
    Player(int[] pos, float shapeWidth, float shapeHeight, String shapeURI) {
        this.pos = pos;
        this.shapeWidth = shapeWidth;
        this.shapeHeight = shapeHeight;
        this.shapeURI = shapeURI;
    }

    void run() {
        display();
        update();
    }

    void display() {
        playerShape = loadShape(shapeURI);
        shape(playerShape, pos[0], pos[1], shapeWidth, shapeHeight);
        
    }

    void update() {
        pos[0] += dx * speed;
        pos[1] += dy * speed;
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
