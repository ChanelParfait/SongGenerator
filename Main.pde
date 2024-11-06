import beads.*;
import controlP5.*;
import java.util.ArrayList;
import java.util.List;


ControlP5 cp5;

Song song;

boolean isSubmitted = false; 
int pitch = 1; 
int speed = 1; 
String[] scales = {"Major", "Minor", "Dorian", "Pentatonic"};
String scale = "Major";
Text txt = new Text();
PFont font;
PFont fontSmall;
color bgColour = color(0,0,0);
Textbox textbox;
Music music;


void setup(){
  size(1000,600);
  font = createFont("Bahnschrift", 32);
  fontSmall = createFont("Bahnschrift", 15);
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
    textAlign(LEFT, CENTER);
    text("Write a Song", 50, 0, width - 20, 100);
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
   
    cp5.addButton("restart")
     .setValue(0)
     .setPosition(width - 420 - 50 ,height - 100)
     .setSize(200,50)
     .hide()
    ;
    
    
   cp5.getController("restart")
   .setFont(font);

    // Scale Dropdown
    cp5.addScrollableList("scale")
       .setPosition(width / 3 + 100, 80)
       .setSize(100, 200)
       .setBarHeight(30)
       .setItemHeight(30)
       .addItems(scales)
       .close()
       ;
         
     cp5.getController("scale")
       .setFont(fontSmall);
       
    cp5.addSlider("pitch")
         .setLabel("Pitch Range")
         .setPosition(width / 2 + 80, 82)
         .setWidth(300)
         .setHeight(20)
         .setRange(1,12) 
         .setValue(0)
         .setNumberOfTickMarks(12)
         .setSliderMode(Slider.FLEXIBLE)
         ;
         
    cp5.getController("pitch")
           .setFont(fontSmall);
           
    cp5.addSlider("speed")
         .setPosition(width / 2 + 80, 35)
         .setWidth(300)
         .setHeight(20)
         .setRange(1,5) 
         .setValue(0)
         .setNumberOfTickMarks(5)
         .setSliderMode(Slider.FLEXIBLE)
         ;
         
    cp5.getController("speed")
           .setFont(fontSmall);
}

void scale(int n){
   println(scales[n]);
  
   scale = scales[n];
}




public void submit(int value) {
  // if no input is provided, do nothing
  if(txt.getString() == ""){ return; }
  // don't run on start
  if(frameCount > 0){
      isSubmitted = true; 
      // check if string is valid
      song = new Song(txt.getString());
      println("Pitch Max: " + pitch);
      println("Scale: " + scale);
      music = new Music(song.getLyrics(), speed, pitch, scale, txt.getTypingSpeed());
      music.startMusic();
       
      bgColour = generateRandomColor();
      cp5.getController("submit").setLabel("Replay");
      cp5.getController("restart").show();
      
      cp5.getController("scale").hide();
      cp5.getController("pitch").hide();
      cp5.getController("speed").hide();
   }

}

public void restart(int value) {
  // don't run on start
  if(frameCount > 0){
      isSubmitted = false; 
      // check if string is valid
      song = null;
      txt = new Text();
      music.stopMusic();
      music = null;
  
      cp5.getController("submit").setLabel("Submit");
      cp5.getController("restart").show();
      
      cp5.getController("scale").show();
      cp5.getController("pitch").show();
      cp5.getController("speed").show();
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
