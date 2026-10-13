float hourNow;
float minuteNow;
int secondNow;
int xLoc; //clock position
int yLoc; //clock position
int hourLen = 115;
int minuteLen = 150;
int secondLen = 200;

void setup() {
  size(1000, 1000);
  frameRate(1); // one frame = one second, so draw() runs once per second
  secondNow = second();
  minuteNow = minute() + secondNow / 60.0;
  hourNow = hour() + minuteNow / 60.0;
  xLoc = 500;
  yLoc = 500;
}//setup

void draw() {
  drawSky();
  drawBuilding();
  drawFace();
  drawVines();
  drawHands();
  updateTime(); // last, so the first frame shows the real start time
}//draw

/**
 Keeps time without Processing's clock. Called once per frame (one second).
 */
void updateTime() {
  secondNow++;
  secondNow %= 60;
  minuteNow += 1 / 60.0;
  minuteNow %= 60;
  hourNow += 1 / 3600.0;
  hourNow %= 24;
}//updateTime

/**
 Fills the background with a sky color that depends on the time of day.
 */
void drawSky() {
  int skyR, skyG, skyB;
  if (hourNow >= 6 && hourNow < 10) {
    //morning
    skyR = 150; skyG = 200; skyB = 255;
  }
  else if (hourNow >= 10 && hourNow < 16) {
    //afternoon
    skyR = 100; skyG = 150; skyB = 240;
  }
  else if (hourNow >= 16 && hourNow < 19) {
    //sunset
    skyR = 250; skyG = 150; skyB = 100;
  }
  else {
    //nighttime
    skyR = 20; skyG = 20; skyB = 50;
  }
  background(skyR, skyG, skyB);
}//drawSky

/**
 Draws the building and side towers behind the clock.
 */
void drawBuilding() {
  noStroke();
  fill(72, 32, 41);
  rect(xLoc - 230, yLoc - 400, 460, 800);
  rect(xLoc - 300, yLoc - 400, 600, 60);
  rect(xLoc - 300, yLoc + 340, 600, 60);
  fill(75);
  rect(xLoc - 500, yLoc - 100, 150, 600);
  rect(xLoc + 350, yLoc - 100, 150, 600);
  fill(100);
  rect(xLoc - 400, yLoc + 400, 800, 100);
}//drawBuilding

/**
 Draws the white clock face.
 */
void drawFace() {
  noStroke();
  fill(255);
  circle(xLoc, yLoc, 440);
}//drawFace

/**
 Draws green vines along the direction of each hand.
 */
void drawVines() {
  drawVinesAlong(getAngle(hourNow, 12), hourLen);
  drawVinesAlong(getAngle(minuteNow, 60), minuteLen);
  drawVinesAlong(getAngle(secondNow, 60), secondLen);
}//drawVines

/**
 Starts 10 vines at evenly spaced points from the center out along the given angle.
 */
void drawVinesAlong(float angle, int len) {
  stroke(50, 200, 100);
  strokeWeight(2);
  for (int i = 1; i <= 10; i++) {
    int distFromCenter = (len - 10) * i / 10;
    int startX = (int) (xLoc + distFromCenter * cos(angle));
    int startY = (int) (yLoc + distFromCenter * sin(angle));
    drawVine(startX, startY, 5);
  }
}//drawVinesAlong

/**
 Draws one vine of len connected random segments going downward (reused from the lightning project).
 */
void drawVine(int x, int y, int len) {
  while (len > 0) {
    int nextX = (int) random(x - 2, x + 2);
    int nextY = (int) random(y, y + 10);
    line(x, y, nextX, nextY);
    x = nextX;
    y = nextY;
    len--;
  }
}//drawVine

/**
 Draws the three hands. Each one has its own color and thickness, and the
 second hand is drawn last so it stays visible on top.
 */
void drawHands() {
  stroke(0);
  strokeWeight(10);
  drawHand(getAngle(hourNow, 12), hourLen);

  strokeWeight(5);
  drawHand(getAngle(minuteNow, 60), minuteLen);

  stroke(200, 30, 30);
  strokeWeight(2);
  drawHand(getAngle(secondNow, 60), secondLen);
}//drawHands

/**
 Draws one hand as a line from the center of the clock at the given angle and length.
 */
void drawHand(float angle, int len) {
  line(xLoc, yLoc, xLoc + len * cos(angle), yLoc + len * sin(angle));
}//drawHand

/**
 Converts a clock value into an angle in radians. value / maxValue is the fraction of a
 full turn, and HALF_PI is subtracted so 0 points straight up instead of right.
 */
float getAngle(float value, float maxValue) {
  return value * (TWO_PI / maxValue) - HALF_PI;
}//getAngle
