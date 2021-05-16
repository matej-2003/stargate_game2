class Body {
  PVector pos = new PVector(), vel = new PVector(), accel = new PVector(), force = new PVector();
  int id, group;
}

interface WeaponFun {
  void hitResponse();
}

class solidBody extends Body {
  float damage;
  float angle, life, initial_life, range, speed, speed_limit;
  PVector origin = new PVector();


  void show() {
  }
  void move() {
  }
  void die() {
  }
  void hitResponse() {
  }


  float getAngle() {
    return angle;
  }

  float getRange() {
    return range;
  }
}


class energyBody extends Body {
  float damage;
  float angle, life, initial_life;
}


//shipType_, explosionType_, shipRadius_, shieldRadius_, shieldType_, rocketType_, reloadTime_, damage_, shield_power_, life
//Ship(shipType_, explosionType_, shipRadius_, reloadTime_, damage_, life_, shield_) {
//Shield(r_, power_, damage_, type_,  invisible_, healingSpeed_, healValue_, showTime_) {

class Hatak extends Ship {
  //Shield HatakShield = new Shield(60, 100, 10, true, 10, 3, 30);
  Hatak() {
    super(0, 1, 25, 45, 10, 100, new Shield(60, 100, 10, 4, true, 10, 3, 30));
    speed = 2;
    rotation = false;
  }

  Hatak(int group_) {
    super(0, 1, 25, 45, 10, 100, new Shield(60, 100, 10, 4, true, 10, 3, 30));
    group = group_;
    speed = 2;
    rotation = false;
  }

  Weapon fire(PVector pos_, PVector target_) {
    return new HatakWeapon(pos_, target_, id, group);
  }

  Weapon fire(PVector pos_, float x, float y) {
    return new HatakWeapon(pos_, x, y, id, group);
  }
}

class OriMothership extends Ship {
  OriMothership() {
    super(1, 2, 40, gameTime(2000), 10, 100, new Shield(120, 100, 10, 0, true, 10, 3, 30));
    speed = 1;
  }

  OriMothership(int group_) {
    super(1, 2, 40, gameTime(2000), 10, 100, new Shield(120, 100, 10, 0, true, 10, 3, 30));
    group = group_;
    speed = 1;
  }

  Weapon fire(PVector pos_, PVector target_) {
    return new OriWeapon(pos_, target_, id, group);
  }

  Weapon fire(PVector pos_, float x, float y) {
    return new OriWeapon(pos_, x, y, id, group);
  }
}

class AsgardShip extends Ship {
  AsgardShip() {
    super(2, 1, 25, 15, 100, 200, new Shield(60, 100, 10, 0, true, 10, 3, 30));
  }

  AsgardShip(int group_) {
    super(2, 1, 25, 15, 100, 200, new Shield(60, 100, 10, 0, true, 10, 3, 30));
    group = group_;
  }

  Weapon fire(PVector pos_, PVector target_) {
    return new AsgardWeapon(pos_, target_, id, group);
  }

  Weapon fire(PVector pos_, float x, float y) {
    return new AsgardWeapon(pos_, x, y, id, group);
  }
}

class GoauldMothership extends Ship {
  GoauldMothership() {
    super(3, 2, 50, 40, 10, 500, new Shield(150, 150, 10, 4, true, 10, 3, 30));
    speed = 0.2;
  }

  GoauldMothership(int group_) {
    super(3, 2, 50, 40, 10, 500, new Shield(150, 150, 10, 4, true, 10, 3, 30));
    speed = 0.2;
    group = group_;
  }

  Weapon fire(PVector pos_, PVector target_) {
    return new HatakWeapon(pos_, target_, id, group);
  }

  Weapon fire(PVector pos_, float x, float y) {
    return new HatakWeapon(pos_, x, y, id, group);
  }
}
