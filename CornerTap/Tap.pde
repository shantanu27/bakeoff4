short[] data;
int min, max;

KetaiAudioInput mic;
boolean micReady = false;

int MIC_THRESHOLD = 350; // how loud a tap has to be to be a "tap"

long lastTappedTime = 0;
int TAP_DEBOUNCE = 200;
String lastTappedCorner = null;
int TAP_INDICATOR_TRANSITION = 400;

float TAP_ACCEL_THRESHOLD = 1;
float TAP_ACCEL_INTERVAL = 100; // close tap has to be to accelerometer activity to be a "tap"
long lastTapAcceledTime = 0;

void setupTap() {
  requestPermission("android.permission.RECORD_AUDIO", "initAudio"); 
}

void resetTap() {
  //lastTappedTime = 0;
  lastTappedCorner = null;
}

void drawTap() {
  long currentTime = millis();
  
  int timeSinceLast = int(currentTime - lastTappedTime);
  float lerp = min(float(timeSinceLast) / TAP_INDICATOR_TRANSITION, 1.0);
  //println(timeSinceLast, lerp);
  fill(lerpColor(#cecece, #ffffff, lerp));
  //ellipseMode(CENTER);
  ellipse(width / 2, 0, height, height);
  
  if (!userDone) {
    int startX = currTarget.action == 0 ? 0 : width * 6 / 8;
    fill(COLORS.get(currTarget.target));
    rect(startX, 0, width / 4, width / 4);
    int selectedTarget = getSelectedTarget();
    fill(COLORS.get(selectedTarget));
    rect(startX, 0, width / 4, width / 20);
  }
  
}

void mousePressedTap() {
  if (!micReady || mic == null || !mic.isActive()) {
    mic.start();
    micReady = true;
  }
}

void initAudio(boolean granted) {
  mic = new KetaiAudioInput(this);
}

void onLinearAccelerationEventTap(float x, float y, float z) {
  if (abs(z) > TAP_ACCEL_THRESHOLD && z < 0)
    lastTapAcceledTime = millis();
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
    
    long currentTime = millis();
    int timeSinceLast = int(currentTime - lastTappedTime);
    if (max-min>MIC_THRESHOLD && currentTime - lastTapAcceledTime<TAP_ACCEL_INTERVAL && timeSinceLast>TAP_DEBOUNCE) {
      lastTappedTime = currentTime;
      lastTappedCorner = currCorner;
    }
}
