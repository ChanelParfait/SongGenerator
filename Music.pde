import beads.*;
import java.util.ArrayList;
import java.util.List;

class Music {
  AudioContext ac;
  Clock bgClock;
  Lyric[] songLyrics;
  float pitch; 
  int[] pitchMode;
  int pitchMax= 4; 
  float randomiser;
  float songSpeed; 

  int index = 0; 
  int musicIndex = 0; 
  public boolean isPlaying; 

  Music(Lyric[] lyrics, float speed, int pitch, String scale, float rand){
    ac = AudioContext.getDefaultContext();
    ac.start();
    songLyrics = lyrics;
    songSpeed = speed; 
    pitchMax = pitch;
    setScale(scale);
    randomiser = rand; 
  }
  void stopMusic(){
    bgClock.kill();
    ac.stop();
  }
  
  void setScale(String scale){
    switch (scale) {
        case "Major":
            pitchMode = Pitch.major;
            break;
        case "Minor":
            pitchMode = Pitch.minor;
            break;
        case "Dorian":
            pitchMode = Pitch.dorian;
            break;
        case "Pentatonic":
            pitchMode = Pitch.pentatonic;
            break;
        default:
            println("Invalid Pitch Mode");
            pitchMode = Pitch.major;
            break;
    }
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
    isPlaying = true; 
    index = 0;
    // set pace of song
    Clock clock = new Clock(ac, 2000 / songSpeed);
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
                duration += 50; 
              }
              // get average keycode of all letters in the word
              avgKey /= word.length();
              float freqMod = map(avgKey, 97, 122, 1, pitchMax);
              
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
    bgClock = new Clock(ac, 2000 / songSpeed);

    bgClock.addMessageListener(
    //create listener method
      new Bead() {
        int pitch = Pitch.forceToScale((int)random(pitchMax), pitchMode);
        public void messageReceived(Bead message) {
          Clock c = (Clock)message;
          if(c.getCount() % 8 == 0) {
            //int pitch; 
            Envelope gainEnv = new Envelope(0.01); 
            
            Noise n = new Noise();
            Gain g = new Gain(1, gainEnv);
            g.addInput(n);
            Panner p = new Panner(random(0.5, 1));
            p.addInput(g);
            ac.out.addInput(g);
            gainEnv.addSegment(0, 60, new KillTrigger(p));
              
          }
          if(c.getCount() % 4 == 0) {
            if(randomiser > 3){
              int pitchAlt = pitch;
              if(random(1) < 0.2) 
              pitchAlt = Pitch.forceToScale((int)random(pitch), pitchMode) + (int)random(2) * 12;
              float freq = Pitch.mtof(pitchAlt + 32);
              WavePlayer wp = new WavePlayer(freq, Buffer.SQUARE);
              Envelope gainEnv = new Envelope(0); 
  
              Gain g = new Gain(1, gainEnv);
              g.addInput(wp);
              Panner p = new Panner(random(1));
              p.addInput(g);
              ac.out.addInput(p);
              gainEnv.addSegment(random(0.1), random(50));
              gainEnv.addSegment(0, random(400), new KillTrigger(p));
            }
            else{
              int pitchAlt = pitch;
              if(random(1) < 0.2) 
              pitchAlt = Pitch.forceToScale((int)random(pitch), pitchMode) + (int)random(7) * 12;
              float freq = Pitch.mtof(pitchAlt + 32);
              WavePlayer wp = new WavePlayer(freq, Buffer.SINE);
              Envelope gainEnv = new Envelope(0); 
              Gain g = new Gain(1, gainEnv);
              g.addInput(wp);
              ac.out.addInput(g);
              gainEnv.addSegment(random(0.5), random(50));
              gainEnv.addSegment(0, random(800), new KillTrigger(g));
            }
            
              
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
    pitch = Pitch.forceToScale((int)pitch, pitchMode);
    float freq = Pitch.mtof(pitch + 3 * 12 + 32);
    println("Pitch: " + pitch);

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
