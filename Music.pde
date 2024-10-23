import beads.*;
import java.util.ArrayList;
import java.util.List;

class Music {
  AudioContext ac;
  Clock bgClock;
  Lyric[] songLyrics;
  
  float songSpeed; 

  int index = 0; 
  int musicIndex = 0; 
  public boolean isPlaying; 

  Music(Lyric[] lyrics, float speed){
    ac = AudioContext.getDefaultContext();
    ac.start();
    songLyrics = lyrics;
    songSpeed = speed; 

  }
  
  String getActiveLyric(){
    if(musicIndex < songLyrics.length){
      return songLyrics[musicIndex].lyricText;
    } else {
      return null;
    }
  }
  
  
  void startMusic(){
    playBGMusic();
    index = 0;
    musicIndex = -1;
  }
  
  
  // change to list of lyrics
  void play(){
    // play each lyric in order
    if(!isPlaying){
      if(musicIndex < songLyrics.length - 1){
        musicIndex++;
        playLyric(songLyrics[musicIndex]);
        
        
      }
      else {
        //println("Song Played");
        stopBGMusic();
      }
    }
  }
  
 
  void playLyric(Lyric lyric){
    //println(lyric);
    
    isPlaying = true; 
    index = 0;
    Clock clock = new Clock(ac, 1000);
    clock.addMessageListener(
    //create listener method
      new Bead() {
        //this is the method that we override to make the Bead do something
        public void messageReceived(Bead message) {

          Clock c = (Clock)message;
          if(c.isBeat()) {
            if(index < lyric.getLength()){
              //play a sound for each word
              String word = lyric.getWordAt(index); 
              //println("Word: " + word);

              // find sound pitch and duration based on word
              float duration = 0;
              float avgKey = 0;
              for (int i = 0; i < word.length(); i++){
                
                avgKey += word.charAt(i); 
                duration += 30; 
              }
              // get average keycode of all letters in the word
              avgKey /= word.length();
              float freqMod = map(avgKey, 97, 122, 1, 12);
              
              // min pitch of 400, max of 800
              //float pitch = 400 + (100 * freqMod);
              playSound(freqMod, duration); 
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
  
  
  void playBGMusic(){
    // use different values to affect bg music
    bgClock = new Clock(ac, 1000);

    bgClock.addMessageListener(
    //create listener method
      new Bead() {
        //this is the method that we override to make the Bead do something
        public void messageReceived(Bead message) {
          Clock c = (Clock)message;
          if(c.getCount() % 8 == 0) {
            //int pitch; 
            Envelope gainEnv = new Envelope(0.01); 
            
            Noise n = new Noise();
            Gain g = new Gain(1, gainEnv);
            g.addInput(n);
            Panner p = new Panner(random(0.5, 1));
            //p.addInput(g);
            ac.out.addInput(g);
            gainEnv.addSegment(0, 60, new KillTrigger(p));
              
          }
          
       }
    } 
    );
    ac.out.addDependent(bgClock);
  }
  
  void stopBGMusic(){
    bgClock.kill();
  }
  
  
  
  // play a sound given duration and pitch
  void playSound(float pitch, float duration){
    println("Duration: " + duration);
    
    Envelope gainEnv = new Envelope(0.1); 
    // scale pitch value to make a more consistent sound
    pitch = Pitch.forceToScale((int)pitch, Pitch.dorian);
    float freq = Pitch.mtof(pitch + (int)random(2,4) * 12 + 32);
    println("Pitch: " + freq);

    WavePlayer wp = new WavePlayer(freq, Buffer.SINE);
    Gain g = new Gain(1, gainEnv);
    g.addInput(wp);
    ac.out.addInput(g);
  
    gainEnv.addSegment(0.1, duration);
    gainEnv.addSegment(0, duration, new KillTrigger(g));
  }
  
  
  
  // play a sound based on a key 
  void playKey(float keyChar){
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
