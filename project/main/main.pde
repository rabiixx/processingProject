
Player player1;

int[] srcPoint = new int[2];
int[] destPoint = new int[2];

    /* This is only for debuggin reasons */
//final int seed = 1;
//randomSeed(seed);



void setup() {
  
  println("WIdth: " + width);

    size(1024, 1024);
    background(#2c3e50);
    
    srcPoint[0] = int( random(0, width - 10) );
    srcPoint[1] = int( random(0, height - 10) );
    destPoint[0] = int( random(0, width - 10) );
    destPoint[1] = int( random(0, height - 10) );

    println("Src: (" + srcPoint[0] + ", " + srcPoint[1] + ")");
    println("Dest: (" + destPoint[0] + ", " + destPoint[1] + ")");
    
    player1 = new Player(srcPoint[0], srcPoint[1], 100, 100, "snorlax.svg");

}

void draw() {
    background(#2c3e50); 
    
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
    player1.pressed( (key == 'a' || key == 'A' || keyCode == LEFT), (key == 'd' || key == 'D' || keyCode == RIGHT),
                     (key == 'w' || key == 'W' || keyCode == UP), (key == 's' || key == 'S' || keyCode == DOWN));
}

void keyReleased() {
    player1.released( (key == 'a' || key == 'A' || keyCode == LEFT), (key == 'd' || key == 'D' || keyCode == RIGHT),
                     (key == 'w' || key == 'W' || keyCode == UP), (key == 's' || key == 'S' || keyCode == DOWN));
}

float calcCloseness(int[] srcPoint, int[] destPoint) {
    return sqrt( pow( (srcPoint[0] - destPoint[0]), 2) + pow( (srcPoint[1] - destPoint[1]), 2) );
}


class Player {

    float xpos;  
    float ypos;
    float shapeWidth;
    float shapeHeight;
    String shapeURI;    /* Player Shpae URI */
    PShape playerShape;    /* Player Shape */
    float speed = 5;
    float dx = 0, dy = 0;


    /**
    * @param {[type]}
    * @param {[type]}
    * @param {[type]}
    * @param {[type]}
    * @param {[type]}
    */
    Player(float xpos, float ypos, float shapeWidth, float shapeHeight, String shapeURI) {
        this.xpos = xpos;
        this.ypos = ypos;
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
        shape(playerShape, xpos, ypos, shapeWidth, shapeHeight);
    }

    void update() {
        xpos += dx * speed;
        ypos += dy * speed;
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
