float[] lastMagneticFieldEvent = {0, 0};
HashMap<Integer, Integer> magnetColors = new HashMap<Integer, Integer>();

String currCol = LEFT;
int LEFT_THRESHOLD = 0;
//int STILL = 1;


void onMagneticFieldEvent(float x, float y, float z) {
  currCol = x < LEFT_THRESHOLD ? RIGHT : LEFT;
  //println(x, y);
}

//void onLinearAccelerationEventMagnet(float x, float y, float z) {
//  if (x < STILL)
//    currMagnet = realCurrMagnet;
//}
