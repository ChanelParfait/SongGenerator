import java.util.ArrayList;
import java.util.List;


String inputText = "";
List<String> input = new ArrayList<>();
List<Integer> inputTimes = new ArrayList<>();

PVector textboxPos = new PVector(20,20);
PVector textboxSize;

float heightIncrement = 20;



void setup(){
  size(600,600);
  textboxSize = new PVector(width - 40 , height - 40);


}


void draw(){
  background(1);
  textSize(40);
  text(inputText, textboxPos.x, textboxPos.y, textboxSize.x , textboxSize.y); 
}

void keyPressed() {

  if(key != CODED){

    if(key == BACKSPACE){
      //remove last element
      if(input.size() > 0){
        input.remove(input.size() - 1);
        inputTimes.remove(inputTimes.size() - 1);

      }
      updateText();
      return; 
    }
    
    if(key == TAB ){
      return; 
    }
    
    
    String text = "";
    text+=key;
    inputTimes.add(millis());
    input.add(text);
    updateText();
  }
}


void updateText(){
  inputText = "";
  for(int i = 0; i < input.size(); i++){
    inputText += input.get(i);
  }
  println (input);
  println(inputTimes);
  println (input.size());
  println (inputTimes.size());
  //println("Text Width: " + textWidth(inputText));
  //println (textDescent()+textAscent());
  // check if total text height is greater than textbox height
    // 
  // 6548.133
  // current text height = 36

  
}
