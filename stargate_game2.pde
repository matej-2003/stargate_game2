/* //<>//
Autor kode: Matej Kodemrac
 Slike: prevzete z spleta
 */
//to avoid installing libs on every system
//sound libs are in the ./code directory
float startTime = millis();
float screen_offset = 100;

//game menu vars
float fontSize = 32;
float charWidth = 0, charHeight = 20;
int textHeight = (int) charHeight;
Menu gameMenu;


PImage backgroundImg;
float explosionVel = 1;
ArrayList<Explosion> animations = new ArrayList<Explosion>();
ArrayList<Ship> ships = new ArrayList<Ship>();
ArrayList<Weapon> wepons = new ArrayList<Weapon>();
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
HashMap<Character, Boolean> keyMap = new HashMap<Character, Boolean>();

PFont fonts[] = new PFont[4];

Hatak playerShip;
//Star st;
//Stargate s;

void setup() {
  size(960, 600);
  //fullScreen();
  backgroundImg = loadImage("images/background_stars.jpg");
  backgroundImg.resize(width, height);
  imageMode(CENTER);

  fonts[0] = createFont("font_0.ttf", fontSize);
  fonts[1] = createFont("font_1.ttf", fontSize);
  fonts[2] = createFont("font_2.ttf", fontSize);
  fonts[3] = createFont("font_3.ttf", fontSize);

  textFont(fonts[3]);
  textSize(textHeight);
  charWidth = textWidth(" ");

  loadAssets();

  keyMap.put('w', false);
  keyMap.put('s', false);
  keyMap.put('a', false);
  keyMap.put('d', false);
  keyMap.put('q', false);
  keyMap.put('t', false);
  keyMap.put(' ', false);


  playerShip = new Hatak();
  playerShip.reloadTime = 30;
  playerShip.life = 1000;
  playerShip.initial_life = 1000;

  gameMenu = new Menu(0, 0, #ffffff);
  gameMenu.setPos(width - gameMenu.w - 20, height - gameMenu.h - 20);

  for (int i=0; i<1; i++) {
    ships.add(new OriMothership(1));
    //ships.add(new Hatak(2));

    //ships.add(new AsgardShip(3));
    //ships.add(new GoauldMothership(4));
  }

  for (int i=0; i<1; i++) {
    asteroids.add(new Asteroid());
  }
  println("loading time: " + (millis() - startTime));

  //st = new Star(1);
  //s = new Stargate();
}

void draw() {
  background(backgroundImg);
  //image(backgroundImg, -width/2-pl.pos.x, -height/2-pl.pos.y);

  gameMenu.update(playerShip);
  pushMatrix();
  translate(width/2, height/2);
  scale(1);
  translate(-playerShip.pos.x, -playerShip.pos.y);


  grid(100);

  //s.show();
  //s.spawn();
  //s.deactivate();

  //st.show();

  playerShip.shoot();
  playerShip.userMove();
  playerShip.shipHeal();
  playerShip.spin();
  playerShip.show();
  playerShip.die(true);

  //wepons
  for (int i=wepons.size()-1; i>=0; i--) {
    playerShip.hit(wepons.get(i));
    wepons.get(i).move();
    wepons.get(i).show();
    wepons.get(i).die();
  }

  //asteroids
  for (int i=asteroids.size()-1; i>=0; i--) {
    playerShip.hitAsteroid(asteroids.get(i));
    asteroids.get(i).move();
    asteroids.get(i).spin();

    for (int j=wepons.size()-1; j>=0; j--) {
      asteroids.get(i).hit(wepons.get(j));
    }

    asteroids.get(i).show();
    asteroids.get(i).die(false);
  }

  //ships
  for (int i=ships.size()-1; i>=0; i--) {
    ships.get(i).shipHeal();
    ships.get(i).autoShoot(playerShip.pos);
    ships.get(i).follow(playerShip.pos);
    //ships.get(i).battel();

    for (int k=asteroids.size()-1; k>=0; k--) {
      ships.get(i).hitAsteroid(asteroids.get(k));
    }

    for (int j=wepons.size()-1; j>=0; j--) {
      //ships.get(i).AvoidMissile(rockets.get(j));
      ships.get(i).hit(wepons.get(j));
    }

    ships.get(i).show();
    ships.get(i).die(false);
  }

  //animations
  for (int i=animations.size()-1; i>=0; i--) {
    //for (int j=ships.size()-1; j>=0; j--) animations.get(i).effected1(ships.get(j));
    animations.get(i).show();
  }
  popMatrix();
  gameMenu.display();
}

void keyPressed() {
  for (Character i : keyMap.keySet()) {
    if (key == i) keyMap.put(i, true);
  }
}

void keyReleased() {
  for (Character i : keyMap.keySet()) {
    if (key == i) keyMap.put(i, false);
  }
}
