import beads.*;

PVector textboxPos = new PVector(20,20);
PVector textboxSize;

boolean canInput = true;
Text txt = new Text();
Music music = new Music();


void setup(){
  size(600,600);
  textboxSize = new PVector(width - 40 , height - 40);
  

  //String str = "hello darkness my old friend";
  //music.playString(str); 
}

void draw(){
  background(1);
  textSize(40);
  text(txt.getString(), textboxPos.x, textboxPos.y, textboxSize.x , textboxSize.y); 
  
}




void keyPressed() {
  if(canInput){
    txt.onKeyPress();
  }
}


void mousePressed(){
  //canInput = false; 
  println(txt.getString());
  music.playString(txt.getString()); 
  
}
