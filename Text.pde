import java.util.ArrayList;
import java.util.List;

class Text {
  
  String textString = "";
  List<Character> inputStrings = new ArrayList<>();
  List<Integer> inputTimes = new ArrayList<>();
  
  Text(){}
  
  // returns typing speed in characters per second
  float getTypingSpeed(){
    // get the total typing time
    float typingTime = inputTimes.get(inputTimes.size() - 1) - inputTimes.get(0);
    typingTime /= 1000; 
    float speed =  (inputStrings.size() - 1) / typingTime; 
    println("typing time: " + typingTime);
    println("Speed: " + speed); 
    return 0; 
  
  }
  
  public String getString(){
    return textString;
  }
  
  public List<Character> getInputStrings(){
    return inputStrings;
  }
  
  public List<Integer> getInputTimes(){
    return inputTimes;
  }
  
  private void UpdateString(){
   // empty string 
   textString = "";
   // add all input strings to text string
    for(int i = 0; i < inputStrings.size(); i++){
      textString += inputStrings.get(i);
    }
    
    
     println (inputStrings);
     
    // println("Text Width: " + textWidth(inputText));
    // println (textDescent()+textAscent());
    // check if total text height is greater than textbox height
    // 
    // 6548.133
    // current text height = 36
  }
  
  public void onKeyPress(){
    // check if key isn't coded
    // this means it is a typable character
    if(key != CODED){
      if(key == BACKSPACE || key == DELETE){
        //check if any input has been provided
        if(inputStrings.size() > 0){
          // remove the last character from the list of strings
          inputStrings.remove(inputStrings.size() - 1);
          // remove last input times
          inputTimes.remove(inputTimes.size() - 1);
          UpdateString();

        }
        return; 
      }
    
      // ignore Tab 
      if (key == TAB ){
        return; 
      } 
      // convert key to a string
      //String str = "";
      //str += key;
      // add key to input strings
      inputStrings.add(key);
      // add current time to input times
      inputTimes.add(millis());
      UpdateString();
    }  
  }
  

}
