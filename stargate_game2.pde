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
float charWidth = 0, charHeight = 10;
int textHeight = (int) charHeight;
StringDict gameStat = new StringDict();
Menu gameMenu;


PImage backgroundImg;
float explosionVel = 1;
ArrayList<Explosion> animations = new ArrayList<Explosion>();
ArrayList<Ship> ships = new ArrayList<Ship>();
ArrayList<solidBody> wepons = new ArrayList<solidBody>();
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
HashMap<Character, Boolean> keyMap = new HashMap<Character, Boolean>();

int allShips = 5;
int presentShips = 5;

Hatak pl;
Star st;

void setup() {
  size(960, 600);
  //fullScreen();
  backgroundImg = loadImage("images/background_stars.jpg");
  backgroundImg.resize(width, height);
  imageMode(CENTER);

  textFont(createFont(PFont.list()[72], fontSize));
  textSize(textHeight);
  charWidth = textWidth(" ");
  gameStat.set("Life:", "          0");  //extra spacing is added at the end so that is fits on the screen
  gameStat.set("Damage:", "0");
  gameStat.set("Speed:", "0");
  gameStat.set("Shield damage:", "0");
  gameStat.set("Shield integrity:", "0%");
  gameMenu = new Menu(0, 0, gameStat, #ffffff);
  gameMenu.setPos(width - gameMenu.w - 10, height - gameMenu.h - 10);

  loadAssets();

  keyMap.put('w', false);
  keyMap.put('s', false);
  keyMap.put('a', false);
  keyMap.put('d', false);
  keyMap.put('q', false);
  keyMap.put('t', false);
  keyMap.put(' ', false);

  pl = new Hatak();
  pl.reloadTime = 30;

  for (int i=0; i<1; i++) {
    ships.add(new OriMothership(1));
    //ships.add(new Hatak(2));

    //ships.add(new AsgardShip(3));
    ships.add(new GoauldMothership(4));
  }

  for (int i=0; i<2; i++) {
    asteroids.add(new Asteroid());
  }
  println("loading time: " + (millis() - startTime));

  st = new Star(0);
}

Stargate s = new Stargate();

void draw() {
  background(0);
  background(backgroundImg);
  //image(backgroundImg, -width/2-pl.pos.x, -height/2-pl.pos.y);

  updateMenu(pl);
  pushMatrix();
  translate(width/2, height/2);
  scale(1);
  translate(-pl.pos.x, -pl.pos.y);


  grid(100);

  s.show();

  st.show();

  pl.shoot();
  pl.userMove();
  pl.shipHeal();
  pl.spin();
  pl.show();
  pl.die(true);

  //wepons
  for (int i=wepons.size()-1; i>=0; i--) {
    pl.hit(wepons.get(i));
    wepons.get(i).move();
    wepons.get(i).show();
    wepons.get(i).die();
  }

  //asteroids
  for (int i=asteroids.size()-1; i>=0; i--) {
    pl.hitAsteroid(asteroids.get(i));
    asteroids.get(i).move();
    asteroids.get(i).spin();

    for (int j=wepons.size()-1; j>=0; j--) {
      asteroids.get(i).hit(wepons.get(j));
    }

    asteroids.get(i).show();
    asteroids.get(i).die(true);
  }

  //ships
  for (int i=ships.size()-1; i>=0; i--) {
    ships.get(i).shipHeal();
    //ships.get(i).autoShoot(pl.pos);
    //ships.get(i).follow(pl.pos);
    ships.get(i).battel();

    for (int k=asteroids.size()-1; k>=0; k--) {
      ships.get(i).hitAsteroid(asteroids.get(k));
    }

    for (int j=wepons.size()-1; j>=0; j--) {
      //ships.get(i).AvoidMissile(rockets.get(j));
      ships.get(i).hit(wepons.get(j));
    }

    ships.get(i).show();
    ships.get(i).die(true);
  }

  //animations
  for (int i=animations.size()-1; i>=0; i--) {
    //for (int j=ships.size()-1; j>=0; j--) animations.get(i).effected1(ships.get(j));
    animations.get(i).show();
  }
  popMatrix();
  gameMenu.display();

  //println(frameRate);
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
