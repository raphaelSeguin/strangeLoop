import themidibus.*;

import oscP5.*;
import netP5.*;

////////////////////////////////////////////////////////////// setup

void setup() {
  fullScreen(P3D, 2);
  noCursor();
  //size(800, 800, P3D);
  MidiBus.list();
  midi = new MidiBus(this, 0, 0);
  midiPatch = new MidiPatcher();

  // Attractors
  thomas = new Thomas(width/8, 0.1);
  lorenz = new Lorenz(40, 0.00);
  brown = new Brown(10, 0.001);
  voxelator = new Voxelator(50, 0.);

  // ParticleCloud
  particleCloud = new ParticleCloud(2000, 100);
  particleCloud.randomizePositions(width/2);
  particleCloud.showAll();

  oscP5 = new OscP5(this,57110);
  flashes = new ArrayList<Flash>();
  
  colorMode(HSB, 127, 127, 127);
  initVars();
  initParams();
}

////////////////////////////////////////////////////////////// draw

void draw() {
  backgroundColor();
  stroke(255);
  text("WIFI : _Strange_Loop", 20, height - 40);
  text("ip : 192.168.120.120:8000", 20, height - 20);
  translations();
  rotations();
  attractions();
  drawingParameters();
  displayMode();
  particleCloud.display(generations);
  if (frameCount % 50 == 0) {
    println("frame rate : " + frameRate);
  }
  particleCloud.memoryShift();
  
  if ( flashes.size() > 0) {
    for (int i = flashes.size() - 1; i >= 0; i-- ) {
      if (flashes.get(i).getPhase() > 1.) {
        flashes.remove(i);
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////// MidiBus
////////////////////////////////////////////////////////////////////////////////////////////////

void controllerChange(int channel, int number, int value) {
  midiPatch.setControlChange(channel, number, value);
}
void noteOn(int channel, int pitch, int velocity) {
  midiPatch.setNote(channel, pitch, velocity);
}
void noteOff(int channel, int pitch, int velocity) {
  midiPatch.setNote(channel, pitch, 0);
}

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////// functions
////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////// rotations
void rotations() {
  xRotVelPos = midiPatch.getCCmap(1, 11);
  yRotVelPos = midiPatch.getCCmap(1, 12);
  zRotVelPos = midiPatch.getCCmap(1, 13);
  xRotVelNeg = midiPatch.getCCmap(1, 14);
  yRotVelNeg = midiPatch.getCCmap(1, 15);
  zRotVelNeg = midiPatch.getCCmap(1, 16);
  xRot += xRotVelPos;
  yRot += yRotVelPos;
  zRot += zRotVelPos;
  xRot -= xRotVelNeg;
  yRot -= yRotVelNeg;
  zRot -= zRotVelNeg;
  rotateX(xRot);
  rotateY(yRot);
  rotateZ(zRot);
}
//////////////////////////////////////////////////////////////////////////////////////////////// translations
void translations() {

  xTrVelPos = midiPatch.getCCmap(1, 25);
  yTrVelPos = midiPatch.getCCmap(1, 26);
  zTrVelPos = midiPatch.getCCmap(1, 27);
  xTrVelNeg = midiPatch.getCCmap(1, 28);
  yTrVelNeg = midiPatch.getCCmap(1, 29);
  zTrVelNeg = midiPatch.getCCmap(1, 30);
  xTr += xTrVelPos;
  yTr += yTrVelPos;
  zTr += zTrVelPos;
  xTr -= xTrVelNeg;
  yTr -= yTrVelNeg;
  zTr -= zTrVelNeg;
  
  translate(xTr, yTr, zTr);
}

//////////////////////////////////////////////////////////////////////////////////////////////// backgroundColor
void backgroundColor() {
  float 
    red = midiPatch.getCCmap(1, 1), 
    green = midiPatch.getCCmap(1, 2), 
    blue = midiPatch.getCCmap(1, 3);
    
    red += getTotalRed();
    green += getTotalGreen();
    blue += getTotalBlue();
    constrain(red, 0, 255);
    constrain(green, 0, 255);
    constrain(blue, 0, 255);
    //alpha = midiPatch.getCCmap(1, 4);
    colorMode(RGB);
    background(red, green, blue);
    colorMode(HSB, 127, 127, 127);
  //background(0, 0, 0, 127);
}

//////////////////////////////////////////////////////////////////////////////////////////////// attractions
void attractions() {
  thomas.setParams(midiPatch.getCCmap(1, 17));
  thomas.setStrength(midiPatch.getCCmap(1, 18));
  thomas.setScale(midiPatch.getCCmap(1, 19));

  lorenz.setParams(midiPatch.getCCmap(1, 20), midiPatch.getCCmap(1, 21), midiPatch.getCCmap(1, 22));
  lorenz.setStrength(midiPatch.getCCmap(1, 23));
  lorenz.setScale(midiPatch.getCCmap(1, 24));

  brown.setStrength(midiPatch.getCCmap(1, 33));
  brown.setScale(midiPatch.getCCmap(1, 34));
  
  voxelator.setStrength(midiPatch.getCCmap(1,36));
  voxelator.setScale(midiPatch.getCCmap(1,37));

  particleCloud.applyAttractor(thomas);
  particleCloud.applyAttractor(lorenz);
  particleCloud.applyAttractor(brown);
  particleCloud.applyAttractor(voxelator);
}

//////////////////////////////////////////////////////////////////////////////////////////////// drawingParameters
void drawingParameters() {
  stroke(midiPatch.getCCmap(1, 5), midiPatch.getCCmap(1, 6), midiPatch.getCCmap(1, 7), midiPatch.getCCmap(1, 8));
  fill(midiPatch.getCCmap(1, 5), midiPatch.getCCmap(1, 6), midiPatch.getCCmap(1, 7), midiPatch.getCCmap(1, 8));
  strokeWeight(midiPatch.getCCmap(1, 9));
}

//////////////////////////////////////////////////////////////////////////////////////////////// displayMode


void displayMode() {
  generations = (int)midiPatch.getCCmap(1, 35);
}

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////// init param min max init
////////////////////////////////////////////////////////////////////////////////////////////////

void initParams() {
  // channel number min max init

  
  //////////////////////////////////////////// background
  // background H
  midiPatch.setMinMaxInit(1, 1, 0, 255, 0);
  // background S
  midiPatch.setMinMaxInit(1, 2, 0, 255, 0);
  // background B
  midiPatch.setMinMaxInit(1, 3, 0, 255, 0);
  // background alpha
  midiPatch.setMinMaxInit(1, 4, 0, 127, 127);

  //////////////////////////////////////////// stroke

  // stroke H
  midiPatch.setMinMaxInit(1, 5, 0, 127, 0);
  // stroke S
  midiPatch.setMinMaxInit(1, 6, 0, 127, 0);
  // stroke B
  midiPatch.setMinMaxInit(1, 7, 0, 127, 127);
  // stroke alpha
  midiPatch.setMinMaxInit(1, 8, 0, 127, 127);
  // strokeWeight
  midiPatch.setMinMaxInit(1, 9, 1, 200, 1);

  //////////////////////////////////////////// rotations

  // xRotVelPos
  midiPatch.setMinMaxInit(1, 11, 0, 0.03, 0.);
  // yRotVelPos
  midiPatch.setMinMaxInit(1, 12, 0, 0.03, 0);
  // zRotVelPos
  midiPatch.setMinMaxInit(1, 13, 0, 0.03, 0);
  // xRotVelNeg
  midiPatch.setMinMaxInit(1, 14, 0, 0.03, 0);
  // yRotVelNeg
  midiPatch.setMinMaxInit(1, 15, 0, 0.03, 0);
  // zRotVelNeg
  midiPatch.setMinMaxInit(1, 16, 0, 0.03, 0);

  //////////////////////////////////////////// attractors

  // thomas b
  midiPatch.setMinMaxInit(1, 17, 0.001, 0.5, 0.22);
  // thomas strength
  midiPatch.setMinMaxInit(1, 18, 0.00000001, 0.3, 0.005);
  // thomas scale
  midiPatch.setMinMaxInit(1, 19, 10, width/4, width/8);

  // lorenz sigma
  midiPatch.setMinMaxInit(1, 20, 5, 20, 10);
  // lorenz rho
  midiPatch.setMinMaxInit(1, 21, 14, 56, 28);
  // lorenz beta
  midiPatch.setMinMaxInit(1, 22, 1., 5, 8./3.);
  // lorenz strength 
  midiPatch.setMinMaxInit(1, 23, 0.0000001, 0.01, 0.0);
  // lorenz scale
  midiPatch.setMinMaxInit(1, 24, 5, 25, 10);

  // brown strength
  midiPatch.setMinMaxInit(1, 33, 0, 40, 0);
  // brown scale
  midiPatch.setMinMaxInit(1, 34, 0, 50, 0);


  // voxelator stregnth
  midiPatch.setMinMaxInit(1, 36, 0, 1., 0.);
    // voxelator scale
  midiPatch.setMinMaxInit(1, 37, 5, 100, 50);

  //////////////////////////////////////////// translations

  // xTrPos
  midiPatch.setMinMaxInit(1, 25, 0., 10., 0.);
  // yTrPos
  midiPatch.setMinMaxInit(1, 26, 0., 10., 0.);
  // zTrPos
  midiPatch.setMinMaxInit(1, 27, 0., 10., 0.);
  // xTrNeg
  midiPatch.setMinMaxInit(1, 28, 0., 10., 0.);
  // yTrNeg
  midiPatch.setMinMaxInit(1, 29, 0., 10., 0.);
  // zTrNeg
  midiPatch.setMinMaxInit(1, 30, 0., 10., 0.);
  
  //////////////////////////////////////////// generations
  
  midiPatch.setMinMaxInit(1, 35, 1, 100, 20);
}

void initVars() {
  xTr = width / 2;
  yTr = height / 2;
  zTr = - height / 2;
}


////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////// OSC
////////////////////////////////////////////////////////////////////////////////////////////////

void oscEvent(OscMessage oscMessage) {
  //println(oscMessage.arguments()); 
  int r = (int)oscMessage.get(0).floatValue();
  int g = (int)oscMessage.get(1).floatValue();
  int b = (int)oscMessage.get(2).floatValue();
  flashes.add( new Flash(1000, r, g, b));
}


float getTotalRed() {
  float red = 0;
  for (Flash f : flashes) {
    red += f.getRed();
  }
  if (flashes.size() != 0) {
    red = red/(float)flashes.size();
  }
  return red;
}

float getTotalGreen() {
  float green = 0;
  for (Flash f : flashes) {
    green += f.getGreen();
  }
  if (flashes.size() != 0) {
    green = green/(float)flashes.size();
  }
  return green;
}

float getTotalBlue() {
  float blue = 0;
  for (Flash f : flashes) {
    blue += f.getBlue();
  }
  if (flashes.size() != 0) {
    blue = blue/(float)flashes.size();
  }
  return blue;
}