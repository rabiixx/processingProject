	
import processing.sound.*;
SoundFile file;

float[] ampArr = { 0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0 };
int ampLevel = 6;

float[] rateArr = { 0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0 };
int rateLevel = 6;

void setup() {
  size(640, 360);
  background(255);
    
  // Load a soundfile from the /data folder of the sketch and play it back
  file = new SoundFile(this, "beep1.wav");
  file.play();
  file.loop();
  file.amp(ampArr[ampLevel]);
  file.rate(rateArr[rateLevel]);

}      
void draw() {
}


void keyPressed() {
	if (keyCode == UP) {
    if (ampArr[ampLevel] != 1.0) {
        file.amp(ampArr[++ampLevel]);
    }  
		println(ampArr[ampLevel]);	
  } else if (keyCode == DOWN) {
	  if (ampArr[ampLevel] != 0.0) {
        file.amp(ampArr[--ampLevel]);
    }  
    println(ampArr[ampLevel]);
  } else if (keyCode == RIGHT) {
    if (rateArr[rateLevel] != 1.0) {
        file.rate(rateArr[++rateLevel]);
    }  
    println(rateArr[rateLevel]);  
  } else if (keyCode == LEFT) {
    if (rateArr[rateLevel] != 0.0) {
        file.rate(rateArr[--rateLevel]);
    }  
    println(rateArr[rateLevel]);
  }	
  
}
