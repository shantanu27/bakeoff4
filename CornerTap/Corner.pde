String LEFT = "LEFT";
String RIGHT = "RIGHT";
String currCorner = null;

void onGravityEvent(float x, float y, float z) {
  if (x > 0) {
    setCorner(LEFT);
  }
  else {
    setCorner(RIGHT);
  }
}

void setCorner(String nextCorner) {
  //if (nextCorner != currCorner) {
  //  println(nextCorner);
  //}
  currCorner = nextCorner;
}
