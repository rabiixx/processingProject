import processing.sound.*;


Player player1;

int[] srcPoint = new int[2];
int[] destPoint = new int[2];
PShape bot;

    /* This is only for debuggin reasons */
//final int seed = 1;
//randomSeed(seed);


void setup() {
  
  println("WIdth: " + width);

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
    
    

}

void draw() {
    background(#2c3e50);
    
    shape(bot, 100, 100, 40, 40);
    
    /* Source and Destination */     
    stroke(#0fb9b1);
    fill(#c0392b);
    ellipse(srcPoint[0], srcPoint[1], 10, 10);
    
    stroke(#c0392b);
    fill(#0fb9b1);
    ellipse(destPoint[0], destPoint[1], 10, 10);
    
    player1.run();

    //println("Distance: "+ calcCloseness());
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
    return sqrt( pow( (srcPoint[0] - destPoint[0]), 2) + pow( (srcPoint[1] - destPoint[1]), 2) );
}

class Player {

    int[] pos = new int[2];
    float shapeWidth;
    float shapeHeight;
    String shapeURI;        /* Player Shpae URI */
    PShape playerShape;    /* Player Shape */
    float speed = 4;
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
