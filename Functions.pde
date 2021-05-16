PImage[] splitImage(PImage img, int n, float k) {
  PImage list[] = new PImage[n];
  int w = img.width/n;
  int h = img.height;
  img.loadPixels();

  for (int i=0; i<n; i++) {
    list[i] = createImage(int(w), int(h), ARGB);
    //top left corner (globalX, globalY)
    //copy(img, globalX, globalY, globalW, globalH, localX, localY, localW, localH);
    list[i].copy(img, i * w, 0, w, h, 0, 0, w, h);
    list[i].resize(int(w*k), int(h*k));
  }
  img.updatePixels();

  return list;
}

PImage shields[] = new PImage[7];
PImage asteroid_images[][] = new PImage[2][];
PImage missile_images[] = new PImage[15];
PImage ship_images[] = new PImage[4];
PImage star_images[][] = new PImage[2][];
PImage explosion_images[][] = new PImage[15][];
PImage supergate_images[] = new PImage[29];

SoundFile sound_files[][] = new SoundFile[4][];
final int gate_sound = 0;
final int other_sound = 1;
final int weapons_sound = 2;
float volume = 0;

void loadAssets() {

  for (int i=0; i<supergate_images.length; i++) {
    String name = ((i < 9)? "0": "") + (i + 1) + ".png";
    supergate_images[i] = loadImage("images/gate/open/frame_" + name);
  }

  //load images
  star_images[0] = splitImage(loadImage("images/other/stars/orange_sun.png"), 58, 1);
  star_images[1] = splitImage(loadImage("images/other/stars/blue_sun.png"), 49, 1);

  asteroid_images[0] = splitImage(loadImage("images/other/asteroids/rock.png"), 16, 1);
  asteroid_images[1] = splitImage(loadImage("images/other/asteroids/rock_small.png"), 16, 1);

  explosion_images[0] = splitImage(loadImage("images/explosions/type_A.png"), 20, 1);  
  explosion_images[1] = splitImage(loadImage("images/explosions/type_B.png"), 64, 1);
  explosion_images[2] = splitImage(loadImage("images/explosions/type_C.png"), 48, 1);
  explosion_images[3] = splitImage(loadImage("images/explosions/1.png"), 24, 1);
  explosion_images[4] = splitImage(loadImage("images/explosions/2.png"), 24, 1);
  explosion_images[5] = splitImage(loadImage("images/explosions/3.png"), 23, 1);
  explosion_images[6] = splitImage(loadImage("images/explosions/4.png"), 24, 1);
  explosion_images[8] = splitImage(loadImage("images/explosions/5.png"), 24, 1);
  explosion_images[7] = splitImage(loadImage("images/explosions/6.png"), 32, 1);
  explosion_images[9] = splitImage(loadImage("images/explosions/7.png"), 32, 1);
  explosion_images[10] = splitImage(loadImage("images/explosions/8.png"), 32, 1);
  explosion_images[11] = splitImage(loadImage("images/explosions/9.png"), 32, 1);
  explosion_images[12] = splitImage(loadImage("images/explosions/10.png"), 32, 1);
  explosion_images[13] = splitImage(loadImage("images/explosions/11.png"), 24, 1);
  explosion_images[14] = splitImage(loadImage("images/explosions/smoke.png"), 32, 1);

  shields[0] = loadImage("images/shields/blue_lite.png");
  shields[1] = loadImage("images/shields/blue.png");
  shields[2] = loadImage("images/shields/blue_dark.png");
  shields[3] = loadImage("images/shields/orange_lite.png");
  shields[4] = loadImage("images/shields/orange_dark.png");
  shields[5] = loadImage("images/shields/purple.png");
  shields[6] = loadImage("images/shields/white.png");


  missile_images[0] = loadImage("images/missiles/0.png");
  missile_images[0].resize(16, 16);
  missile_images[1] = loadImage("images/missiles/1.png");
  missile_images[1].resize(16, 16);
  missile_images[2] = loadImage("images/missiles/2.png");
  missile_images[3] = loadImage("images/missiles/3.png");
  missile_images[4] = loadImage("images/missiles/4.png");
  missile_images[5] = loadImage("images/missiles/5.png");
  missile_images[6] = loadImage("images/missiles/6.png");
  missile_images[7] = loadImage("images/missiles/7.png");
  missile_images[8] = loadImage("images/missiles/8.png");
  missile_images[8].resize(16, 16);
  missile_images[9] = loadImage("images/missiles/9.png");
  missile_images[9].resize(16, 16);  
  missile_images[10] = loadImage("images/missiles/10.png");
  missile_images[10].resize(16, 16);  
  missile_images[11] = loadImage("images/missiles/11.png");
  missile_images[11].resize(16, 16);  
  missile_images[12] = loadImage("images/missiles/12.png");
  missile_images[12].resize(16, 16);  
  missile_images[13] = loadImage("images/missiles/13.png");
  missile_images[13].resize(16, 16);  
  missile_images[14] = loadImage("images/missiles/14.png");
  missile_images[14].resize(10, 10);  

  ship_images[0] = loadImage("images/ships/hatak.png");
  ship_images[0].resize(50, 50);
  ship_images[1] = loadImage("images/ships/ori_mothership.png");
  ship_images[1].resize(61, 106);
  ship_images[2] = loadImage("images/ships/asgard_mothership.png");
  ship_images[2].resize(64, 53);
  ship_images[3] = loadImage("images/ships/goauld_mothership.png");
  ship_images[3].resize(150, 150);

  //load sound files
  sound_files[0] = new SoundFile[12];

  sound_files[0][0] = new SoundFile(this, "audio/gate/activate5.mp3");
  sound_files[0][1] = new SoundFile(this, "audio/gate/close.mp3");
  sound_files[0][2] = new SoundFile(this, "audio/gate/close-eyeris.mp3");
  sound_files[0][3] = new SoundFile(this, "audio/gate/press.mp3");
  sound_files[0][4] = new SoundFile(this, "audio/gate/press1.mp3");
  sound_files[0][5] = new SoundFile(this, "audio/gate/press2.mp3");
  sound_files[0][6] = new SoundFile(this, "audio/gate/press3.mp3");
  sound_files[0][7] = new SoundFile(this, "audio/gate/roll.mp3");
  sound_files[0][8] = new SoundFile(this, "audio/gate/simbol-activate1.mp3");
  sound_files[0][9] = new SoundFile(this, "audio/gate/simbol-activate3.mp3");
  sound_files[0][10] = new SoundFile(this, "audio/gate/travell.mp3");
  sound_files[0][11] = new SoundFile(this, "audio/gate/wormhole.mp3");


  sound_files[1] = new SoundFile[13];

  sound_files[1][0] = new SoundFile(this, "audio/other/alarm.mp3");
  sound_files[1][1] = new SoundFile(this, "audio/other/asgard-teleport.mp3");
  sound_files[1][2] = new SoundFile(this, "audio/other/asgard-teleport4.mp3");
  sound_files[1][3] = new SoundFile(this, "audio/other/asgard-teleport2.mp3");
  sound_files[1][4] = new SoundFile(this, "audio/other/asgard-teleport3.mp3");
  sound_files[1][5] = new SoundFile(this, "audio/other/beam.mp3");
  sound_files[1][6] = new SoundFile(this, "audio/other/beam1.mp3");
  sound_files[1][7] = new SoundFile(this, "audio/other/dart-engine.mp3");
  sound_files[1][8] = new SoundFile(this, "audio/other/hatak-engine.mp3");
  sound_files[1][9] = new SoundFile(this, "audio/other/hyperwindow.mp3");
  sound_files[1][10] = new SoundFile(this, "audio/other/naquada-charge.mp3");
  sound_files[1][11] = new SoundFile(this, "audio/other/scanner.mp3");
  sound_files[1][12] = new SoundFile(this, "audio/other/shield-hit.mp3");

  sound_files[2] = new SoundFile[20];

  sound_files[2][0] = new SoundFile(this, "audio/weapons/energy-weapon.mp3");
  sound_files[2][1] = new SoundFile(this, "audio/weapons/energy-weapon1.mp3");
  sound_files[2][2] = new SoundFile(this, "audio/weapons/energy-weapon2.mp3");
  sound_files[2][3] = new SoundFile(this, "audio/weapons/energy-weapon3.mp3");
  sound_files[2][4] = new SoundFile(this, "audio/weapons/energy-weapon4.mp3");
  sound_files[2][5] = new SoundFile(this, "audio/weapons/energy-weapon5.mp3");
  sound_files[2][6] = new SoundFile(this, "audio/weapons/energy-weapon6.mp3");
  sound_files[2][7] = new SoundFile(this, "audio/weapons/gould-handweapon.mp3");
  sound_files[2][8] = new SoundFile(this, "audio/weapons/hatak-fire.mp3");
  sound_files[2][9] = new SoundFile(this, "audio/weapons/missile.mp3");
  sound_files[2][10] = new SoundFile(this, "audio/weapons/missile1.mp3");
  sound_files[2][11] = new SoundFile(this, "audio/weapons/ori-weapon.mp3");
  sound_files[2][12] = new SoundFile(this, "audio/weapons/staff-weapon.mp3");
  sound_files[2][13] = new SoundFile(this, "audio/weapons/staff-weapon1.mp3");
  sound_files[2][14] = new SoundFile(this, "audio/weapons/staff-weapon2.mp3");
  sound_files[2][15] = new SoundFile(this, "audio/weapons/zat-hit.mp3");
  sound_files[2][16] = new SoundFile(this, "audio/weapons/zat-weapon.mp3");
  sound_files[2][17] = new SoundFile(this, "audio/weapons/zat-weapon1.mp3");
  sound_files[2][18] = new SoundFile(this, "audio/weapons/zat-weapon2.mp3");
  sound_files[2][19] = new SoundFile(this, "audio/weapons/zat-weapon3.mp3");


  sound_files[3] = new SoundFile[2];

  sound_files[3][0] = new SoundFile(this, "audio/explosions/explosion0.mp3");
  sound_files[3][1] = new SoundFile(this, "audio/explosions/explosion1.mp3");

  for (int i=0; i<sound_files.length; i++) {
    for (int j=0; j<sound_files[i].length; j++) {
      if (i == 2 && j == 8) continue;
      if (i == 2 && j == 11) continue;
      if (i == 3) continue;

      sound_files[i][j].amp(volume);
    }
  }

  //volume exceptions
  sound_files[2][8].amp(volume/2);
  sound_files[2][11].amp(volume*2);

  sound_files[3][0].amp(volume*2);
  sound_files[3][1].amp(volume*2);
}


float universeWidth = 1000;
float universeHeight = 1000;

float viewCoefficient = 1;

float w = int(universeWidth * viewCoefficient);
float h = int(universeHeight * viewCoefficient);

float getX(float x, float x1) {
  return (x1-x+w/2)*width/w;
}

float getY(float y, float y1) {
  return  (y1-y+h/2)*height/h;
}

float gameTime(float time) {
  return int(frameRate * time/1000);
}

boolean timer(float previus, float interval) {
  return frameCount - previus >= interval;
}

void grid(float k) {
  stroke(255);
  for (int x=0; x<=width; x+=k) {
    //line(getX(pos.x, x), getY(pos.y, 0), getX(pos.x, x), getY(pos.y, H));
    line(x, 0, x, height);
  }

  for (int y=0; y<=height; y+=k) {
    //line(getX(pos.x, 0), getY(pos.y, y), getX(pos.x, W), getY(pos.y, y));
    line(0, y, width, y);
  }
}

//returnes the same string n times concatenated to s
String repeat(String s, int n) {
  String str = "";    //make a new string and the it concatenates it with the string provide n times
  for (int i=0; i<n; i++) str += s;
  return str;
}

boolean angleRangeTest(PVector pos1, PVector pos2, float angle, float range) {
  float relativeAngle = atan2(pos1.y - pos2.y, pos1.x - pos2.x);
  if (relativeAngle >= angle - range/2 && relativeAngle <= angle + range/2) {
  }
  return true;
}

void updateMenu(Ship i) {
  gameStat.set("Life:", i.life + "");
  gameStat.set("Damage:", i.damage + "");
  gameStat.set("Speed:", i.speed + "");
  gameStat.set("Shield damage:", "0");
  gameStat.set("Shield integrity:", i.shield.power+"%");
}


//class solidBody {
//  PVector pos, vel;
//  float angle, damage, life;
//  boolean alive;
//  int id;
//}
