import java.util.ArrayList;
import java.util.Collections;
import ketai.sensors.*;

KetaiSensor sensor;

private class Target
{
  int target = 0;
  int action = 0;
}

int WHITE = #ffffff;
int RED = #fc2a22;
int YELLOW = #ffbc00;
int GREEN = #00ad44;
int BLUE = #3085fa;
int FONT_SIZE = 100;
HashMap<Integer, Integer> COLORS = new HashMap<Integer, Integer>();

int SUBMIT_DEBOUNCE = 300;
long lastSubmitTime = 0;

int TRIAL_COUNT = 5; //this will be set higher for the bakeoff
int trialIndex = 0;
ArrayList<Target> targets = new ArrayList<Target>();
Target currTarget;
int startTime = -1; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
boolean userDone = false;

void setup() {
  //size(600, 600); //you can change this to be fullscreen
  fullScreen();
  frameRate(60);
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(PORTRAIT);
  
  setupTap();
  setupCamera();
  
  COLORS.put(0, RED);
  COLORS.put(1, YELLOW);
  COLORS.put(2, GREEN);
  COLORS.put(3, BLUE);
  
  rectMode(CORNER);
  //textFont(createFont("Arial", FONT_SIZE)); //sets the font to Arial size 20
  textAlign(CENTER);

  reset();
}

void reset() {
  trialIndex = 0;
  targets = new ArrayList<Target>();
  currTarget = null;
  startTime = -1; // time starts when the first click is captured
  finishTime = 0; //records the time of the final click
  userDone = false;
  
  for (int i=0; i<TRIAL_COUNT; i++)  //don't change this!
  {
    Target t = new Target();
    t.target = ((int)random(1000))%4;
    t.action = ((int)random(1000))%2;
    targets.add(t);
    println("created target with " + t.target + "," + t.action);
  }

  Collections.shuffle(targets); // randomize the order of the button;
}

void draw() {
  submit();
  textSize(FONT_SIZE);

  //uncomment line below to see if sensors are updating
  //println("light val: " + light +", cursor accel vals: " + cursorX +"/" + cursorY);
  background(WHITE); //background is light grey
  noStroke(); //no stroke

  if (startTime == 0)
    startTime = millis();

  if (trialIndex>=targets.size() && !userDone)
  {
    userDone=true;
    finishTime = millis();
  }
  
  if (!userDone) {
    currTarget = targets.get(trialIndex);
  }

  if (startTime == -1) {
    return;
  }
  
  drawTap();
  drawPrompt();
}

void onLinearAccelerationEvent(float x, float y, float z) {
  onLinearAccelerationEventTap(x, y, z);
}

void mousePressed() {
  if (userDone) {
    reset();
  }
  else if (startTime == -1) {
    startTime = 0;
  }
  mousePressedTap();
  mousePressedCamera();
}

void submit() {
  if (userDone || trialIndex>=targets.size())
    return;
      
  if (currTarget == null)
    return;
    
  if (lastTappedCorner == null)
    return;
   
  boolean debounced = millis() - lastSubmitTime > SUBMIT_DEBOUNCE;
  if (debounced) {
    // criteria here
    boolean correctTarget = getSelectedTarget() == currTarget.target;
    boolean correctAction = (lastTappedCorner == LEFT && currTarget.action == 0) || (currCorner == RIGHT && currTarget.action == 1);
    
    if (correctTarget && correctAction) {
      onSubmit();
      trialIndex++;
    }
    else {
      onSubmit();
       
      if (trialIndex>0)
        trialIndex--;
    }
  }
}

int getSelectedTarget() {
  int selectedTarget = 0;
  if (currColor == WARM) {
    if (currCol == LEFT) { selectedTarget = 0; }
    else if (currCol == RIGHT) { selectedTarget = 1; }
  }
  else if (currColor == COOL) {
    if (currCol == LEFT) { selectedTarget = 2; }
    else if (currCol == RIGHT) { selectedTarget = 3; }
  } 
  
  return selectedTarget;
}

void onSubmit() {
  println(lastTappedCorner, getSelectedTarget());
  lastSubmitTime = millis();
  resetTap();
}
