class ParticleCloud {
  PVector[][] positions;
  boolean[] show;
  int number;
  int memorySize;
  int memoryPointer;
  int memoryDepth;
  String displayMode;
  String groupMode; // history / generation
  int shapeMode;
  // POINTS, LINES, TRIANGLES, TRIANGLE_FAN, TRIANGLE_STRIP, QUADS, and QUAD_STRIP

  //
  //         FINIR d'implémenter avec memoryDepth toutes les méthodes
  //
  //

  ParticleCloud(int number, int memorySize) {
    this.number = number;
    this.positions = new PVector[memorySize][number];
    this.show = new boolean[number];
    this.memorySize = memorySize;
    this.memoryPointer = 0;
    this.memoryDepth = 0;
    this.displayMode = "lines"; // default
    this.groupMode = "history";
    this.shapeMode = LINES;
    for (int i = 0; i < positions.length; i++) {
      for (int j = 0; j < positions[i].length; j++) {
        this.positions[i][j] = new PVector(0, 0, 0);
      }
      this.show[i] = true;
    }
  }
  void setDisplayMode(String mode) {
    this.displayMode = mode;
  }
  void setGroupMode(String mode) {
    this.groupMode = mode;
  }
  void setShapeMode(int mode) {
    this.shapeMode = mode;
  }
  void showAll() {
    for (int i = 0; i < show.length; i++) {
      show[i] = true;
    }
  }
  void hideAll() {
    for (int i = 0; i < show.length; i++) {
      show[i] = false;
    }
  }
  void showRandom(float proba) {
    for (int i = 0; i < show.length; i++) {
      show[i] = random(1) < proba;
    }
  }
  void memoryShift() {
    for (int i = 0; i < this.positions[this.memoryPointer].length; i++) {
      this.positions[(this.memoryPointer + 1) % this.memorySize][i] = this.positions[this.memoryPointer][i];
    }
    this.memoryPointer += 1;
    this.memoryPointer %= this.memorySize;
    this.memoryDepth = this.memoryDepth < this.memorySize ? this.memoryDepth + 1 : this.memoryDepth;
  }
  void display(int generations) {
    switch (this.groupMode) {
    case "generation" :
      for (int i = 0; i < generations; i++) {
        int pointer = (this.memoryPointer + this.memorySize - i) % this.memorySize;
        beginShape(this.shapeMode);
        for (int n = 0; n < positions[pointer].length; n++) {
          if (this.show[n]) {
            vertex(this.positions[pointer][n].x, this.positions[pointer][n].y, this.positions[pointer][n].z);
          }
        }
        endShape();
      }
      break;
    case "history" : 
      for (int n = 0; n < this.number; n++) { 
        beginShape(this.shapeMode);
        if (this.show[n]) {
          for (int i = 0; i < generations; i++) {
            int pointer = (this.memoryPointer + this.memorySize - i) % this.memorySize;
            vertex(this.positions[pointer][n].x, this.positions[pointer][n].y, this.positions[pointer][n].z);
          }
        }
        endShape();
      }
      break;
    }
  }
  void randomizePositions(float radius) {
    for (int i = 0; i < positions[this.memoryPointer].length; i++) {
      // rayon-longitude-latitude
      float longitude = random(-PI, PI);
      float latitude = random(-HALF_PI, HALF_PI);
      this.positions[this.memoryPointer][i].x = radius * cos(latitude) * cos(longitude);
      this.positions[this.memoryPointer][i].y = radius * cos(latitude) * sin(longitude);
      this.positions[this.memoryPointer][i].z = radius * sin(latitude);
    }
  }
  void applyForce(PVector force) {
    for (int i = 0; i < positions[this.memoryPointer].length; i++) {
      this.positions[this.memoryPointer][i].add(force);
    }
  }
  void applyAttractor(Attractor a) {
    for (int i = 0; i < positions[this.memoryPointer].length; i++) {
      this.positions[this.memoryPointer][i] = a.attract(this.positions[this.memoryPointer][i]);
    }
  }
}