class Textbox {
   PVector position;
   PVector scale;
   
   
  Textbox(){
      float paddingX = width / 10;
      float paddingY = height / 10;
  
      scale = new PVector(width - paddingX , height - paddingY - 120);
      position = new PVector(paddingX / 2, paddingY / 2 + 100); 
  }
  
  
  void update(String text){
    textAlign(LEFT);

    textSize(40);
    fill(0,0,100);
    rect(position.x - 5, position.y - 5, scale.x + 5, scale.y + 5);
    fill(0,0,0);
    text(text, position.x, position.y, scale.x , scale.y - 40); 
  }
  
}
