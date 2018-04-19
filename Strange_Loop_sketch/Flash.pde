class Flash {
  int dateOfBirth;
  int dur;
  int red;
  int green;
  int blue;
  Flash(int dur, int red, int green, int blue) {
    this.dateOfBirth = millis();
    this.dur = dur;
    this.red = red;
    this.green = green;
    this.blue = blue;
  }
  float getPhase() {
    return (millis() - this.dateOfBirth) / (float)this.dur;
  }
  color getColor() {
    float phase = getPhase();
    float r = this.red * (1 - phase);
    float g = this.green * (1 - phase);
    float b = this.blue * (1 - phase);
    return color(r, g, b);
  }
  float getRed() {
    float phase = getPhase();
    float r = this.red * (1 - phase) * (1 - phase);
    return r;
  }
  float getGreen() {
    float phase = getPhase();
    float g = this.green * (1 - phase) * (1 - phase);
    return g;
  }
  float getBlue() {
    float phase = getPhase();
    float b = this.blue * (1 - phase) * (1 - phase);
    return b;
  }
}