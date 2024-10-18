import beads.*;
import java.util.ArrayList;
import java.util.List;


List<String> lyrics = new ArrayList<>();
Song song;

PVector textboxPos = new PVector(20,20);
PVector textboxSize;

boolean canInput = true;
Text txt = new Text();
Music music = new Music();


void setup(){
  size(600,600);
  textboxSize = new PVector(width - 40 , height - 40);

}

void draw(){
  background(1);
  textSize(40);
  text(txt.getString(), textboxPos.x, textboxPos.y, textboxSize.x , textboxSize.y); 
  
  if(!canInput){
    
    music.play(lyrics); 
  }
}




void keyPressed() {
  if(canInput){
    txt.onKeyPress();
  }
  
  if(key == TAB){
      canInput = false;
      println("create song");

      song = new Song(txt.getString());
  }
}


void mousePressed(){
  // play music
  println(txt.getString());
  
  
}
