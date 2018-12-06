import ketai.sensors.*;


KetaiAudioInput mic;
short[] data;

long prevTapTime = -1;
int min = Integer.MAX_VALUE, max = Integer.MIN_VALUE;

int SINGLE_TAP = 0, DOUBLE_TAP = 1, NONE = -1;
int currentTap = NONE;
int counter = 1;

void setup()
{
  fullScreen();
  orientation(LANDSCAPE);

  fill(255, 0, 0);
  textSize(48);
  requestPermission("android.permission.RECORD_AUDIO", "initAudio");
  
  prevTapTime = System.currentTimeMillis();  
}

void initAudio(boolean granted)
{
  if (granted)
  {
    mic = new KetaiAudioInput(this);
    println("Audio recording permission granted");
  } else {
    println("Audio recording permission denied");
  }
}


void draw()
{
  background(128);
  if (data != null)
  {  
    min = Integer.MAX_VALUE;
    max = Integer.MIN_VALUE;
    
    for (int i = 0; i < data.length; i++)
    {
      if (i != data.length-1) {
        float datai = map(data[i], -32768, 32767, height, 0);
        float datai1 = map(data[i+1], -32768, 32767, height, 0);
        
        line(i, datai, i+1, datai1);
    }
  }

    if (mic != null && mic.isActive()) {
      text("READING MIC", width/2, height/2);
      
      if (currentTap == NONE) text("NO TAP", width/2, height/2-50);
      if (currentTap == SINGLE_TAP) text("SINGLE TAP", width/2, height/2-50);
      if (currentTap == DOUBLE_TAP) text("DOUBLE TAP", width/2, height/2-50);
      
    } else
      text("NOT READING MIC", width/2, height/2);
  }
}


void onAudioEvent(short[] _data)
{
    data= _data;
  
    min = Integer.MAX_VALUE;
    max = Integer.MIN_VALUE;
    
    for (int i = 0; i < data.length; i++)
    {
      if (i != data.length-1) {
        float datai = map(data[i], -32768, 32767, height, 0);
        float datai1 = map(data[i+1], -32768, 32767, height, 0);
        
        if (datai < min) min = (int) datai;
        if (datai1 < min) min = (int) datai1;
        if (datai > max) max = (int) datai;
        if (datai1 > max) max = (int) datai1;
      }
    }
    
    if (max-min > 350) {
      long currentTime = System.currentTimeMillis();
      if (currentTime - prevTapTime < 400) {
        println(counter + ". DOUBLE TAP");
        currentTap = DOUBLE_TAP;
      } else {
        println(counter + ". SINGLE TAP");
        currentTap = SINGLE_TAP;
      }
      
      counter++;
      prevTapTime = currentTime;
    } else {
      currentTap = NONE;
    }
  
}

void mousePressed()
{
  if (mic != null && mic.isActive())
    mic.stop(); 
  else
    mic.start();
}
