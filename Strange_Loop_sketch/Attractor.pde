// pseudo abstract class ATTRACTOR

class Attractor {
  float scale;
  float strength;
  float[] params;
  Attractor(float scale, float strength) {
    this.scale = scale;
    this.strength = strength;
  }

  PVector attract(PVector v) {
    // test pour overload 
    return v.add(new PVector(1, 1, 1));
  }
  void setScale(float v) {
    this.scale = v;
  }
  void setStrength(float v) {
    this.strength = v;
  }
  void setParams() {
  }
}

////////////////////////////////////////////////////////////// Thomas

class Thomas extends Attractor {
  float b;
  Thomas(float scale, float strength) {
    super(scale, strength);
    this.b = 0.32899;
    println("Thomas attractor created");
  }
  void setParams(float p1) {
    this.b = p1;
  }
  PVector attract(PVector v) {
    float x = v.x;
    float y = v.y;
    float z = v.z;
    float nx, ny, nz, dx, dy, dz;
    x /= this.scale;
    y /= this.scale;
    z /= this.scale;
    dx = sin(y) - this.b * x;
    dy = sin(z) - this.b * y;
    dz = sin(x) - this.b * z;
    nx = x + (dx * this.strength);
    ny = y + (dy * this.strength);
    nz = z + (dz * this.strength);
    nx *= this.scale;
    ny *= this.scale;
    nz *= this.scale;
    return new PVector(nx, ny, nz);
  }
}

////////////////////////////////////////////////////////////// Lorenz

class Lorenz extends Attractor {
  float sigma, rho, beta;
  Lorenz(float scale, float strength) {
    super(scale, strength);
    this.sigma = 10.;
    this.rho = 28.;
    this.beta = 8./3.;
    println("Lorenz attractor created");
  }
  void setParams(float p1, float p2, float p3) {
    this.sigma = p1;
    this.rho = p2;
    this.beta = p3;
  }
  PVector attract(PVector v) {
    float x = v.x;
    float y = v.y;
    float z = v.z;
    float nx, ny, nz, dx, dy, dz;
    x /= this.scale;
    y /= this.scale;
    z /= this.scale;
    dx = this.sigma * (y - x);
    dy = x * (this.rho - z) - y;
    dz = (x * y) - (this.beta * z);
    nx = x + (dx * this.strength);
    ny = y + (dy * this.strength);
    nz = z + (dz * this.strength);
    nx *= this.scale;
    ny *= this.scale;
    nz *= this.scale;
    return new PVector(nx, ny, nz);
  }
}

class Brown extends Attractor {
  float scale;
  float strength;
  float[] params;
  Brown(float scale, float strength) {
    super(scale, strength);
    this.scale = scale;
    this.strength = strength;
  }

  PVector attract(PVector v) {
    return v.add(new PVector(random(-this.strength, this.strength), random(-this.strength, this.strength), random(-this.strength, this.strength)));
  }
  void setScale(float v) {
    this.scale = v;
  }
  void setStrength(float v) {
    this.strength = v;
  }
  void setParams() {
    
  }
}

class Voxelator extends Attractor{
  Voxelator(float scale, float strength) {
    super(scale, strength);
  }

  PVector attract(PVector v) {
    float 
    xres = (round(v.x/this.scale)*this.scale - v.x) * this.strength,
    yres = (round(v.y/this.scale)*this.scale - v.y) * this.strength,
    zres = (round(v.z/this.scale)*this.scale - v.z) * this.strength;                  
    return v.add( xres, yres, zres);
  }
  void setParams() {}
}

class Perlin extends Attractor {
  
  Perlin(float scale, float strength) {
    super(scale, strength);
  }
  PVector attract(PVector v) {  
    // ..........
    return v;
  }
}



/*
Rossler
 dx = -y -z
 dy = x + (a * y)
 dz = b + z * (x - c)
 a = 0.2
 b = 0.2
 c = 5.7
 */


/*
Pickover
 */