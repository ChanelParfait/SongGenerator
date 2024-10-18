import beads.*;
import java.util.ArrayList;
import java.util.List;

class Music {
  AudioContext ac;
  

  int index = 0; 
  int musicIndex = 0; 
  public boolean isPlaying; 

  Music(){
    ac = AudioContext.getDefaultContext();
    ac.start();
  }
  
  // change to list of lyrics
  void play(List<String> lyrics){
    
    if(!isPlaying){
      if(musicIndex < lyrics.size()){
        playString(lyrics.get(musicIndex));
        musicIndex++;
      }
      else {
        //println("Song Played");
      }
    }
  }
  
  void playString(String str){
    println(str);
    isPlaying = true; 
    index = 0;
    Clock clock = new Clock(ac, 500);
    clock.addMessageListener(
    //create listener method
      new Bead() {
        //this is the method that we override to make the Bead do something
        public void messageReceived(Bead message) {
          
          Clock c = (Clock)message;
          if(c.isBeat()) {
            println("Beat");
            if(index < str.length()){
              // consider splitting string into a list of words 
              // and playing sounds based off the average code of that word
              playSound(str.charAt(index)); 
              index++; 
            } else {
              isPlaying = false;
              clock.kill();
            }
            
          }
       }
     } );
     
     ac.out.addDependent(clock);
  }
  
  void playSound(float keyChar){
    println(keyChar);
    println((char)keyChar);

    Envelope gainEnv = new Envelope(0.1); 
  
    if(keyChar >= 97 && keyChar <= 122){
      float freqMod = map(keyChar, 97, 122, 1, 1.5);
      WavePlayer wp = new WavePlayer(400 * freqMod, Buffer.SINE);
      Gain g = new Gain(1, gainEnv);
      g.addInput(wp);
      ac.out.addInput(g);
    
      gainEnv.addSegment(0.1, 20);
      gainEnv.addSegment(0, 20, new KillTrigger(g));
    }
  }
}
