float[] lastMagneticFieldEvent = {0, 0};
HashMap<Integer, Integer> magnetColors = new HashMap<Integer, Integer>();
int currMagnet = 0;
int realCurrMagnet = 0;
float STILL = 1;


void setupMagnet() {
  magnetColors.put(0, RED);
  magnetColors.put(1, YELLOW);
  magnetColors.put(2, GREEN);
  magnetColors.put(3, BLUE);
}

void onMagneticFieldEvent(float x, float y, float z) {
    realCurrMagnet = getMagnet(y, z);
}

void onLinearAccelerationEvent(float x, float y, float z) {
  if (x < STILL)
    currMagnet = realCurrMagnet;
}

void drawMagnet() {
  //println(currTarget.target, currMagnet);
  int trialColor = magnetColors.get(currTarget.target);
  int currColor = magnetColors.get(currMagnet);
  
  fill(trialColor);
  rect(0, height / 6, width, height / 6);
  fill(currColor);
  rect(0, 0, width, height / 6);
}

int getMagnet(float y, float z) {
  if (abs(y) > abs(z)) {
    return y > 0 ? 1 : 3;
  }
  return z > 0 ? 0 : 2;
}

//void mousePressedMagnet(int x, int y) {
//  for (int i = 0; i < 4; i++) {
//    if (drawSquare(i, true, x, y))
//      calibrateSquare(i);
//  }
//}

//int getMagnetSquare(float x, float y) {
//  float min = Integer.MAX_VALUE;
//  int minIndex = 0;
  
//  for (int i = 0; i < 4; i++) {
//    float[] point = squarePoints.get(i);
//    if (point[0] != 0 && point[1] != 0) {
//      float dist = dist(x, y, point[0], point[1]);
//      if (dist < min) {
//        min = dist;
//        minIndex = i;
//      }
//    }
//  }
  
//  return minIndex;
//}
