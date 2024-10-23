import beads.*;
import controlP5.*;
import java.util.ArrayList;
import java.util.List;


ControlP5 cp5;

Song song;

boolean isSubmitted = false; 

Text txt = new Text();
PFont font;
color bgColour = color(0,0,0);
Textbox textbox;
Music music;


void setup(){
  size(1000,600);
  font = createFont("Bahnschrift", 32);
  textFont(font);
  textbox = new Textbox();
  colorMode(HSB, 100);
  
  cp5 = new ControlP5(this);
  setupUI();
}

void draw(){
  background(bgColour);
  
  if(isSubmitted){
    music.play(); 
    if(music.getActiveLyric() != null){
      fill(0,0,0);
      //println(music.getActiveLyric());
      textAlign(CENTER, CENTER);
      textSize(100); 
      text(music.getActiveLyric(), 0, 0, width, height);
    }
  } else {
    textbox.update(txt.getString());
    fill(0,0,99);
    textAlign(CENTER, CENTER);
    text("Write a Song", 0, 0, width, 100);
  }
  
}


void setupUI(){ 
   // alter this to fit into textbox
   cp5.addButton("submit")
   .setValue(0)
   .setPosition(width - 200 - 50 ,height - 100)
   .setSize(200,50)
    ;
   

    
   cp5.getController("submit")
   .setFont(font);
}

public void submit(int value) {
  //println("Submit: " + value);
  if(frameCount > 0){
      isSubmitted = true; 
      song = new Song(txt.getString());
      music = new Music(song.getLyrics(), 0);
      music.startMusic();
      txt.getTypingSpeed(); 
      bgColour = generateRandomColor();
      cp5.getController("submit")
      .setLabel("Replay");
   }

}

color generateRandomColor(){
  color c = color((int)random(100), (int)random(25, 70), (int)random(90,100));
  return c;
}




void keyPressed() {
  if(!isSubmitted){
    txt.onKeyPress();
  }

}


void mousePressed(){
  // play music
  println(txt.getString());
}
