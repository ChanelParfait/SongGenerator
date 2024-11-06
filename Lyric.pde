import java.util.ArrayList;
import java.util.List;

class Lyric{
  // a lyric is a sequence of words (a sentence)
  String[] lyric;
  String lyricText;
  
  Lyric(String text){
      //println("Lyric: " + text);
      lyricText = text;
      String trimmed = text.trim();
      lyric = trimmed.split("[,\\.\\s]");
      
      for(String word : lyric){
        
        //println("W: " + word);
      }
      
  } 
  
  String getWordAt(int index){
    
    return lyric[index];
  }
  
  int getLength(){
    return lyric.length;
  }
}
