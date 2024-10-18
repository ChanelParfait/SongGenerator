import java.util.ArrayList;
import java.util.List;

class Lyric{
  // a lyric is a sequence of words (a sentence)
  String[] lyric;
  
  Lyric(String text){
      println("Lyric: " + text);
      String trimmed = text.trim();
      lyric = trimmed.split("[,\\.\\s]");
      
      for(String word : lyric){
        
        println("W: " + word);
      }
      
  } 
  
  String getWordAt(int index){
    
    return lyric[index];
  }
}
