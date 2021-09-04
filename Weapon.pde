class Weapon extends solidBody { //<>//
  int type, sound_type, explosion_type;

  void init(PVector pos_, int type_, int sound_type_, int id_, int group_, float damage_, float life_, float speed_) {
    pos = pos_.copy();
    origin = pos_.copy();
    type = type_;
    sound_type = sound_type_;
    id = id_;
    group = group_;
    damage = damage_;
    life = life_;
    speed = speed_;

    //if (sound_files[weapons_sound][sound_type].isPlaying()) sound_files[weapons_sound][sound_type].stop();
    sound_files[weapons_sound][sound_type].play();

    vel.sub(pos_);
    vel.setMag(speed);
    angle = HALF_PI + atan2(vel.y, vel.x);
  }

  Weapon(PVector pos_, PVector target_, int type_, int sound_type_, int id_, int group_, float damage_, float life_, float speed_) {
    vel = target_.copy();
    init(pos_, type_, sound_type_, id_, group_, damage_, life_, speed_);
  }

  Weapon(PVector pos_, float x, float y, int type_, int sound_type_, int id_, int group_, float damage_, float life_, float speed_) {
    vel.set(x, y);
    init(pos_, type_, sound_type_, id_, group_, damage_, life_, speed_);
  }

  Weapon() {
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    image(missile_images[type], 0, 0);
    popMatrix();
  }

  void move() {    
    vel.limit(speed);
    pos.add(vel);
    if (pos.x > width+screen_offset || pos.x < -screen_offset || pos.y < -screen_offset || pos.y > height+screen_offset) life = 0;
  }

  void die() {
    if (life <= 0) {
      wepons.remove(this);
      animations.add(new Explosion(pos, 0));
    }
  }

  void follow(PVector pos_) {
    //void follow(PVector pos_, float min_) {

    //to prevent orbeting if missile withing critical distance no accel
    //closer the missile is faster it is

    //float dist_tmp = pos_.dist(pos);
    //the bigger the distance the bigger the speed_limit or speed
    //float limit_speed = (dist_tmp > min_)? speed: map(min_-dist_tmp, 0, min_, speed, 2*speed);
    force = pos_.copy();
    force.sub(pos);
    force.limit(0.2);
    accel.add(force);
    accel.limit(0.5);
    vel.add(accel);
    vel.limit(speed);
    pos.add(vel);
    angle = HALF_PI + atan2(vel.y, vel.x);
  }
}


//HatakWeapon

class HatakWeapon extends Weapon {
  static final float HatakWeaponSpeed = 10;
  static final float HatakWeaponLife = 10;
  static final float HatakWeaponDamage = 10;
  static final int HatakWeaponType = 0;
  static final int HatakWeaponSoundType = 8;


  HatakWeapon(PVector pos_, PVector target_, int id_, int group_) {
    super(pos_, target_, HatakWeaponType, HatakWeaponSoundType, id_, group_, HatakWeaponDamage, HatakWeaponLife, HatakWeaponSpeed);
  }

  HatakWeapon(PVector pos_, float x, float y, int id_, int group_) {
    super(pos_, x, y, HatakWeaponType, HatakWeaponSoundType, id_, group_, HatakWeaponDamage, HatakWeaponLife, HatakWeaponSpeed);
  }
}


//OriWeapon

class OriWeapon extends Weapon {
  static final float OriWeaponSpeed = 10;
  static final float OriWeaponLife = 10;
  static final float OriWeaponDamage = 80;
  static final int OriWeaponType = 6;
  static final int OriWeaponSoundType = 11;
  float tint = 0;
  PVector light_trail[] = new PVector[20];

  void initializeTrail() {
    for (int i=0; i<light_trail.length; i++) light_trail[i] = new PVector();
    light_trail[0] = pos.copy();
  }

  OriWeapon(PVector pos_, PVector target_, int id_, int group_) {
    super(pos_, target_, OriWeaponType, OriWeaponSoundType, id_, group_, OriWeaponDamage, OriWeaponLife, OriWeaponSpeed);
    initializeTrail();
  }

  OriWeapon(PVector pos_, float x, float y, int id_, int group_) {
    super(pos_, x, y, OriWeaponType, OriWeaponSoundType, id_, group_, OriWeaponDamage, OriWeaponLife, OriWeaponSpeed);
    initializeTrail();
  }

  void show() {
    for (int t=0; t<light_trail.length; t++) {
      pushMatrix();
      translate(light_trail[t].x, light_trail[t].y);
      rotate(angle);
      //float a = map(t*(255/light_trail.length), 0, 255, 0, 54);
      //tint = 255 - map(log(a+1), 0, 54, 0, 255);
      //this leaves a tral of the same image behind
      tint = 255-2*(t*(250/light_trail.length));
      tint(#ffffff, tint);
      image(missile_images[type], 0, 0);
      noTint();
      popMatrix();
    }
  }

  void move() {
    vel.limit(speed);
    light_trail[0].add(vel);
    pos = light_trail[0].copy();

    for (int previus=light_trail.length-1; previus>=1; previus--) {
      light_trail[previus] = light_trail[previus-1].copy();
    }

    if (pos.x > width+screen_offset || pos.x < -screen_offset || pos.y < -screen_offset || pos.y > height+screen_offset) life = 0;
  }
}

//
class AsgardWeapon extends Weapon {
  static final float AsgardWeaponSpeed = 10;
  static final float AsgardWeaponLife = 20;
  static final float AsgardWeaponDamage = 40;
  static final int AsgardWeaponType = 4;
  static final int AsgardWeaponSoundType = 4;


  AsgardWeapon(PVector pos_, PVector target_, int id_, int group_) {
    super(pos_, target_, AsgardWeaponType, AsgardWeaponSoundType, id_, group_, AsgardWeaponDamage, AsgardWeaponLife, AsgardWeaponSpeed);
  }

  AsgardWeapon(PVector pos_, float x, float y, int id_, int group_) {
    super(pos_, x, y, AsgardWeaponType, AsgardWeaponSoundType, id_, group_, AsgardWeaponDamage, AsgardWeaponLife, AsgardWeaponSpeed);
  }
}


//self tracking missile
class STM extends Weapon {
  float min_distance = 300;
  float range = PI/3;
  static final float STMSpeed = 10;
  static final float STMLife = 10;
  static final float STMDamage = 10;
  static final int STMType = 10;
  static final int STMSoundType = 2;

  STM(PVector pos_, PVector target_, int id_, int group_) {
    super(pos_, target_, STMType, STMSoundType, id_, group_, STMDamage, STMLife, STMSpeed);
  }

  STM(PVector pos_, float x, float y, int id_, int group_) {
    super(pos_, x, y, STMType, STMSoundType, id_, group_, STMDamage, STMLife, STMSpeed);
  }

  //STM() {
  //  super(STMType, STMSoundType, STMDamage, STMLife, STMSpeed);
  //}

  void move() {
    track_target();
    vel.limit(speed);
    pos.add(vel);
    if (pos.x > width+screen_offset || pos.x < -screen_offset || pos.y < -screen_offset || pos.y > height+screen_offset) life = 0;
  }

  void track_target() {
    int closest = 0;

    for (int i=0; i<ships.size(); i++) {
      if (ships.get(i).group != group) {
        closest = i;
        break;
      }
    }

    for (int i=0; i<ships.size(); i++) {
      if (ships.get(i).group != group) {
        if (pos.dist(ships.get(i).pos) < pos.dist(ships.get(closest).pos)) closest = i;
      }
    }
    if (ships.get(closest).group != group) {
      if (pos.dist(ships.get(closest).pos) <= min_distance) {
        //Ship c = ships.get(closest);
        //float relativeAngle = atan2(c.pos.y - origin.y, c.pos.x - origin.x);
        //if (relativeAngle >= angle - range/2 && relativeAngle <= angle + range/2) {
        follow(ships.get(closest).pos);
        //}
      }
    }
  }
}

///laser

class Laser extends solidBody {
  float damage = 50, l = 200, mag = 20;
  int c = color(#ffffff);

  void init(PVector pos_, int id_, int group_) {
    id = id_;
    group = group_;
    pos = pos_.copy();
    origin = pos_.copy();

    vel.sub(pos_);
    vel.normalize();
    vel.mult(mag);
    //angle = HALF_PI + atan2(vel.y, vel.x);
  }


  Laser(PVector pos_, PVector target, int id_, int group_) {
    vel = target.copy();
    init(pos_, id_, group_);
  }

  Laser(PVector pos_, float x, float y, int id_, int group_) {
    vel.set(x, y);
    init(pos_, id_, group_);
  }

  void hitResponse() {
    pos.sub(vel);
    l -= mag;
  }

  void show() {
    pushStyle();
    stroke(c);
    line(origin.x, origin.y, pos.x, pos.y);
    popStyle();
  }

  void move() {
    pos.add(vel);
    if (origin.dist(pos) >= l) origin.add(vel);
  }

  void die() {
    if (origin.x > width || origin.y > height || pos.x < 0 || pos.y < 0 || l <= 0) wepons.remove(this);
  }
}




//blast

class Blast extends solidBody {
  float range = PI/3, speed = 1, maxDistance = 400;
  float life = 10;

  Blast(PVector pos_, PVector target, int id_, int group_, float damage_) {
    id = id_;
    group = group_;
    damage = damage_;
    pos = pos_.copy();
    origin = pos_.copy();
    vel = target.copy();
    vel.sub(pos_);
    vel.normalize();
    vel.mult(speed);
    angle = atan2(target.y-origin.y, target.x-origin.x);
  }

  Blast(PVector pos_, float x, float y, int id_, int group_, float damage_) {
    id = id_;
    group = group_;
    damage = damage_;
    pos = pos_.copy();
    origin = pos_.copy();
    vel = new PVector();
    vel.set(x, y);
    vel.sub(pos_);
    vel.normalize();
    vel.mult(speed);
    angle = atan2(y-origin.y, x-origin.x);
  }

  void move() {
    pos.add(vel);
    if (pos.x > width+screen_offset || pos.x < -screen_offset || pos.y < -screen_offset || pos.y > height+screen_offset) life = 0;
  }

  void die() {
    if (life <= 0 || origin.dist(pos) > maxDistance) {
      wepons.remove(this);
    }
  }

  float getAngle() {
    return angle;
  }

  float getRange() {
    return range;
  }

  void show() {
    pushMatrix();
    noFill();
    stroke(255);
    float startAngle = angle - range/2;
    float endAngle = angle + range/2;
    arc(origin.x, origin.y, 2*origin.dist(pos), 2*origin.dist(pos), startAngle, endAngle, OPEN);
    popMatrix();
  }
}


//blast

class Beam extends Weapon {
  Beam(PVector pos_, PVector target_, int type_, int id_, int group_, float damage_, float life_, float speed_) {
    super(pos_, target_, type_, 2, id_, group_, damage_, life_, speed_);
  }

  Beam(PVector pos_, float x, float y, int type_, int id_, int group_, float damage_, float life_, float speed_) {
    super(pos_, x, y, type_, 2, id_, group_, damage_, life_, speed_);
  }
}
