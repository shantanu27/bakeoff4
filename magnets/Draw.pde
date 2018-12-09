void drawTaps() {
  if (currTarget.action==0)
    text("UP", width/2, 150);
  else
    text("DOWN", width/2, 150);
}

void drawPrompt() {
  fill(#131317);
  
  if (userDone) {
    //text("User completed " + trialCount + " trials", width/2, 50);
    //text("User took " + nfc((finishTime-startTime)/1000f/trialCount, 1) + " sec per target", width/2, 150);
    return;
  }
  
  //text("Trial " + (trialIndex+1) + " of " +trialCount, width/2, 50);
  //text("Target #" + (currTarget.target)+1, width/2, 100);
  text("" + currMagnet, 0, 0);
}

//int SQUARE_SIZE = 256;
//int rowTwo = 0;
//int rowOne = rowTwo - SQUARE_SIZE * 2;
//int colOne = -SQUARE_SIZE * 3 / 2;
//int colTwo = SQUARE_SIZE / 2;

//void drawSquares() {
//  drawSquare(0);
//  drawSquare(1);
//  drawSquare(2);
//  drawSquare(3);
//}

//void drawSquare(int square) {
//  drawSquare(square, false, 0, 0);
//}
//boolean drawSquare(int square, boolean clickMode, int xMouse, int yMouse) {  
//  int x = square % 2  == 0 ? colOne : colTwo;
//  int y = square / 2 == 0 ? rowOne: rowTwo;
      
//  if (clickMode) {
//    boolean xIn = xMouse > x && xMouse < x + SQUARE_SIZE;
//    boolean yIn = yMouse > y && yMouse < y + SQUARE_SIZE;
//    return xIn && yIn;
//  }
  
//  float[] point = squarePoints.get(square);
//  boolean highlighted = (currTarget.target == square);
//  if (point[0] == 0 && point[1] == 0)
//    fill(255, 0, 0);
//  else if (highlighted)
//    fill(0, 255, 0);
//  else
//    fill(180, 180, 180);
      
//  rect(x, y, SQUARE_SIZE, SQUARE_SIZE);
//  return false;
//}
