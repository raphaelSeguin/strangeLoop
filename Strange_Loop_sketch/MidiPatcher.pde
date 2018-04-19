class MidiPatcher {
  int[][] controlChanges;
  int[][] notes;
  //boolean[][] noteOnTriggers;
  //boolean[][] noteOffTriggers;
  float[][] min;
  float[][] max;
  float[][] init;

  MidiPatcher() {
    this.controlChanges = new int[16][128];
    this.notes = new int[16][128];
    this.min = new float[16][128];
    this.max = new float[16][128];
    this.init = new float[16][128];
    //this.noteOnTriggers = new boolean[16][128];
    //this.noteOffTriggers = new boolean[16][128];
    // initialisation
    for (int channel = 0; channel < 16; channel++) {
      for (int number = 0; number < 128; number++) {
        this.controlChanges[channel][number] = 0;
        this.notes[channel][number] = 0;
        this.min[channel][number] = 0;
        this.max[channel][number] = 127;
        this.init[channel][number] = 0;
        //this.noteOnTriggers[channel][number] = false;
        //this.noteOffTriggers[channel][number] = false;
      }
    }
  }
  float getCCmap(int channel,int number) {
    return map(this.controlChanges[channel-1][number], 0, 127, this.min[channel-1][number], this.max[channel-1][number]);
  }
  void resetAllCC() {
    println("resetAllCC");
    for (int channel = 0; channel < 16; channel++) {
      for (int number = 0; number < 128; number++) {
        resetCC(channel + 1, number);
      }
    }
  }
  
  void resetCC(int channel, int number) {
    float init = this.init[channel-1][number];
    float min = this.min[channel-1][number];
    float max = this.max[channel-1][number];
    this.controlChanges[channel-1][number] = (int)map(init, min, max, 0, 127);
    println("resetCC");
  }
  void setInit(int channel,int number, float val) {
    this.init[channel-1][number] = val;
    resetCC(channel, number);
  }
  void setMin(int channel,int number, float val) {
    this.min[channel-1][number] = val;
  }
  void setMax(int channel,int number, float val) {
    this.max[channel-1][number] = val;
  }
  void setMinMaxInit(int channel,int number, float valMin, float valMax, float valInit) {
    setMin(channel, number, valMin);
    setMax(channel, number, valMax);
    setInit(channel, number, valInit);
  }
  int getNote(int channel, int number) {
    return this.notes[channel-1][number];
  }
  int getControlChange(int channel,int number) {
    return this.controlChanges[channel-1][number];
  }
  
  // MidiBus
  
  void setNote(int channel, int number, int value) {
    this.notes[channel][number] = value;
    if ( value != 0 ) {
      checkNoteCallback(channel, number);
    }
  }
  void setControlChange(int channel, int number, int value) {
    this.controlChanges[channel][number] = value;
  }
  
  void checkNoteCallback(int channel, int number) {
    //println("checkNoteCallBack");
    if (channel == 0) {
      // --------------------------channel 1
      if (number == 0) {
        particleCloud.setGroupMode("history");
      } else if (number == 1) {
        particleCloud.setGroupMode("generation");
      } else if (number == 2) {
        particleCloud.setShapeMode(POINTS);
      } else if (number == 3) {
        particleCloud.setShapeMode(LINES);
      } else if (number == 4) {
        particleCloud.setShapeMode(TRIANGLES);
      } else if (number == 5) {
        particleCloud.setShapeMode(TRIANGLE_FAN);
      } else if (number == 6) {
        particleCloud.setShapeMode(TRIANGLE_STRIP);
      } else if (number == 7) {
        particleCloud.setShapeMode(QUADS);
      } else if (number == 8) {
        particleCloud.setShapeMode(QUAD_STRIP);
      } else if (number == 9) {
        
      } else if (number == 10) {
        
      } else if (number == 11) {
        
      } else if (number == 12) {
        
      } else if (number == 13) {
        
      } else if (number == 14) {
        
      } else if (number == 15) {
        
      } else if (number == 16) {
        
      } else if (number == 17) {
        
      } else if (number == 18) {
        
      } else if (number == 19) {
        
      } else if (number == 20) {
        
      } else if (number == 21) {
        
      } else if (number == 22) {
        
      } else if (number == 23) {
        
      } else if (number == 126) {
        initVars();
      } else if (number == 127) {
        resetAllCC();
        initVars();
      }
      //---------------------------channel 2
    } else if (channel == 1) {
      if (number == 0) {
        particleCloud.randomizePositions(width/2);
      }
    }
  }
}