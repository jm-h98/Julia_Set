float angle, ca = -0.8, cb = 0.156, startAngle = 0, endAngle = 0.15, speed = (1.0 / 3000.0), rR = 1, rG = 20, rB = 3,
  yAngle = -0.156, xAngle = -0.8, xSpeed = speed, ySpeed = speed;
boolean play = false, recording = false, start = true, switched = false;
int count = 0, maxiterations = 500;

void setup() {
  //fullScreen();
  size(1920, 1080, P2D);
  frameRate(60);
  angle = startAngle;
}

void draw() {
  background(255);
  smooth();
  
  if(play){
    ca = cos(angle) * xAngle;
    cb = -cos(angle) * yAngle;
    println(angle);
    
    count++;
    if(recording){
      int allFrames = (int) ((endAngle - startAngle) / speed);
      float completion = ((float) count / (float) allFrames * 100.0);
      println(((int) (completion * 10) / 10.0) + "% abgeschlossen bei " + (int) frameRate + "fps. " + count + " von " + allFrames + " frames berechnet, also " + ((int) (((float) allFrames - (float) count) / frameRate) / 60) + "min verbleibend.");
    }
    angle += speed;
    xAngle += xSpeed;
    yAngle += ySpeed;
    start = false;
    
    if(angle >= endAngle){
      speed *= -1.0;
      xSpeed *= -1.0;
      ySpeed *= -1.0;
    }
      
    if(angle < 0){
      recording = false;
      System.exit(0);
    }
  }
  
  float w = 5;
  float h = (w * height) / width;
  float xmin = -w/2;
  float ymin = -h/2;
  loadPixels();
  
  float xmax = xmin + w;
  float ymax = ymin + h;
  
  float dx = (xmax - xmin) / (width);
  float dy = (ymax - ymin) / (height);

  float y = ymin;
  for (int j = 0; j < height; j++) {
    float x = xmin;
    for (int i = 0; i < width; i++) {
      float a = x;
      float b = y;
      int n = 0;
      while (n < maxiterations) {
        float aa = a * a;
        float bb = b * b;
        if (aa + bb > 16.0) {
          break;
        }
        float twoab = 2.0 * a * b;
        //unterschied zu mandelbrot, sonst aa - bb + x; twoab + y
        a = aa - bb + ca;
        b = twoab + cb;
        n++;
      }
      
      pixels[i+j*width] = getColor(n, maxiterations);
      x += dx;
    }
    y += dy;
  }
  
  updatePixels();
  if(recording)
    saveFrame("frames/######.png");
}

color getColor(int n, int maxiterations){
  if (n < maxiterations && n > 0) {
    int i = n % 16;
    color[] mapping = new color[16];
    mapping[0] = color(66, 30, 15);
    mapping[1]= color(25, 7, 26);
    mapping[2]= color(9, 1, 47);
    mapping[3]= color(4, 4, 73);
    mapping[4]= color(0, 7, 100);
    mapping[5]= color(12, 44, 138);
    mapping[6]= color(24, 82, 177);
    mapping[7]= color(57, 125, 209);
    mapping[8]= color(134, 181, 229);
    mapping[9]= color(211, 236, 248);
    mapping[10]= color(241, 233, 191);
    mapping[11]= color(248, 201, 95);
    mapping[12]= color(255, 170, 0);
    mapping[13]= color(204, 128, 0);
    mapping[14]= color(153, 87, 0);
    mapping[15]= color(106, 52, 3);
    return mapping[i];
}
else return color(0,0,0);
}

void lol(){
  ca = map(mouseX, 0, width, -1, 1);//-0.70176;
  cb = map(mouseY, 0, height, -1, 1);//-0.3842;
}

void keyPressed(){
  if(key == 'p'){
    play = !play;
    recording = !recording;
  }
  if(key == 'r')
    recording = !recording;
}

void mouseClicked(){
  lol();
}
