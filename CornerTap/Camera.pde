import ketai.camera.*;

KetaiCamera cam;
String WARM = "WARM";
String COOL = "COOL";
String currColor = WARM;
color currColorValue = 0;

int BRIGHTNESS_THRESHOLD = 67;

void setupCamera() {
  cam = new KetaiCamera(this, 320, 240, 24);
}

void onCameraPreviewEvent()
{
  cam.read();
  currColorValue = getAverageColor(cam);
  float warmDist = deltaE(currColorValue, #fe7311);
  float coolDist = deltaE(currColorValue, #18999f);
  
  //int minColor = 0;
  //float minDist = Integer.MAX_VALUE;
  //for (int i = 0; i < 4; i++) {
  //  float dist = deltaE(currColorValue, magnetColors.get(i));
  //  if (dist < minDist) {
  //    minDist = dist;
  //    minColor = i;
  //  }
  //}
  
  boolean tapping = millis() - lastTapAcceledTime < 100;
  //if (deltaE(#222222, currColorValue) > BRIGHTNESS_THRESHOLD) {
  if (!tapping) {
    //currColor = minColor;
    currColor = warmDist < coolDist ? WARM : COOL;
  }
}

color getAverageColor(KetaiCamera cam) {
  int sumR = 0;
  int sumG = 0;
  int sumB = 0;
  for (int i = 0; i < cam.width; i++) {
    for (int j = 0; j < cam.height; j++) {
      color c = cam.get(i, j);
      sumR += red(c);
      sumG += green(c);
      sumB += blue(c);
    }
  }
  int pixelCount = cam.width * cam.height;
  //println(sum / cam.width / cam.height);
  return color(sumR / pixelCount, sumG / pixelCount, sumB / pixelCount);
}

float getColorDistance(color c1, color c2) {
  return dist(red(c1), blue(c1), green(c1), red(c2), blue(c2), green(c2));
}

void mousePressedCamera() {
  if (cam == null || !cam.isStarted()) {
    cam.start();
    cam.setCameraID(2);
    cam.setZoom(2);
  }
  //cam.enableFlash();
  cam.manualSettings();
}

///////////////////////////////////////////////////////////////
//CALCULATE DISTANCE BEETWEEN TWO COLORS
public float deltaE(int col1, int col2) {
  float result = 0;

  float[] xyz1 = rgb2xyz(col1);  
  float[] lab1 = xyz2lab(xyz1);

  float[] xyz2 = rgb2xyz(col2);
  float[] lab2 = xyz2lab(xyz2);

  float c1 = sqrt(lab1[1]*lab1[1]+lab1[2]*lab1[2]);
  float c2 = sqrt(lab2[1]*lab2[1]+lab2[2]*lab2[2]);
  float dc = c1-c2;
  float dl = lab1[0]-lab2[0];
  float da = lab1[1]-lab2[1];
  float db = lab1[2]-lab2[2];
  float dh = sqrt((da*da)+(db*db)-(dc*dc));
  float first = dl;
  double second = (float) dc/(1+0.045*c1);
  double third = dh/(1+0.015*c1);
  result = (sqrt((float) (first*first+second*second+third*third)));

  return result;
}

public float [] rgb2xyz(int rgb) {

  float[] result = new float[3];

  double red = red(rgb)/255;
  double green = green(rgb)/255;
  double blue = blue(rgb)/255;

  if (red>0.04045) {
    red = (red+0.055)/1.055;
    red = pow((float)red, (float)2.4);
  } else {
    red = red/12.92;
  }
  if (green>0.04045) {
    green = (green+0.055)/1.055;
    green = pow((float)green, (float)2.4);
  } else {
    green = green/12.92;
  }
  if (blue>0.04045) {
    blue = (blue+0.055)/1.055;
    blue = pow((float)blue, (float)2.4);
  } else {
    blue = blue/12.92;
  }

  blue *=100;
  red *=100;
  green *=100;

  result[0] =(float) (red * 0.4124 + green * 0.3576 + blue * 0.1805);
  result[1] = (float) (red * 0.2126 + green * 0.7152 + blue * 0.0722);
  result[2] = (float) (red * 0.0193 + green * 0.1192 + blue * 0.9505);

  return result;
}

public float [] xyz2lab(float[] xyz) {

  float[] result = new float[3];

  double x = xyz[0]/95.047;
  double y = xyz[1]/100;
  double z = xyz[2]/108.883;

  if (x>0.008856) {
    x = pow((float) x, (float) 0.333);
  } else {
    x = 7.787*x + 16/116;
  }
  if (y>0.008856) {
    y = pow((float) y, (float) 0.3333);
  } else {
    y = (7.787*y) + (16/116);
  }
  if (z>0.008856) {
    z = pow((float) z, (float) 0.333);
  } else {
    z = 7.787*z + 16/116;
  }

  result[0]= (float) (116*y -16);
  result[1]= (float) (500*(x-y));
  result[2]= (float) (200*(y-z));

  return result;
}
