class Song{
  
  Lyric[] lyrics;

  Song(String text){
    println("Song: " + text);

    String[] lyricStrings = new String[30];
    lyricStrings = text.split("[,\\.]");

    lyrics = new Lyric[lyricStrings.length];

    
    for(int i = 0; i < lyrics.length; i++){
      // create a lyric for every sentence
      lyrics[i] = new Lyric(lyricStrings[i]);
      

    }
  }
  
  Lyric[] getLyrics(){
    return lyrics;
  }
}
