class Ship extends solidBody {
  float speed = 2, heal = 1, healingSpeed = 60, healing = frameCount;
  boolean rotation;
  float shipRadius;
  float minimumDistance, reloadTime, fireTime, angle, damage;
  int group, explosionType = 2, shipType = 0, missileType = 0;
  Shield shield;


  Ship(int shipType_, int explosionType_, int shipRadius_, float reloadTime_, float damage_, float life_, Shield shield_) {
    id = int(random(10000));
    group = id;
    shipType = shipType_;
    explosionType = explosionType_;
    pos = new PVector(random(960), random(600));
    vel = new PVector();
    vel.set(0, 0);
    reloadTime = reloadTime_;
    shipRadius = shipRadius_;
    damage = damage_;
    life = life_;
    initial_life = life_;
    shield = shield_;
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    if (rotation) angle = atan2(vel.y, vel.x) - HALF_PI;
    shield.show();
    image(ship_images[shipType], 0, 0);
    popMatrix();
  }

  float getCollisionDistance() {
    return (shield.isActive())? shield.r: shipRadius;
  }

  void shipHeal() {
    if (timer(healing, healingSpeed)) {
      if (life < initial_life) {
        life += heal;
      } else {
        shield.heal();
      } 
      if (life > initial_life) life = initial_life; //set life back to max if it excedes max
      healing = frameCount;
    }
  }

  //void hit(Rocket i) {
  //  minimumDistance = (shield_power > 0)? shieldRadius:shipRadius;

  //  if ((i.id != id && group != i.group) && pos.dist(i.pos) <= minimumDistance) {
  //    //when rocket dies it makes an explosion
  //    if (shield_power > 0) {
  //      i.life -= shield_damage;
  //      shield_power -= i.damage;
  //      showShield = frameCount;
  //    } else {
  //      i.life -= damage;
  //      life -= i.damage;
  //    }
  //  }
  //}


  //void hit(Laser i) {
  //  minimumDistance = (shield_power > 0)? shieldRadius:shipRadius;

  //  if ((i.id != id && group != i.group) && pos.dist(i.pos) <= minimumDistance) {
  //    //when laser impacts the shield it makes an explosion
  //    animations.add(new Explosion(i.pos, 0));
  //    if (shield_power > 0) {
  //      shield_power -= i.damage;
  //      showShield = frameCount;
  //    } else {
  //      life -= i.damage;
  //    }
  //  }
  //}

  //if respawn is false than it will remoce the ship from the ships list
  void die(boolean respawn) {
    if (life <= 0) {
      animations.add(new Explosion(pos, explosionType, 0));
      if (respawn) {
        pos = new PVector(random(width), random(height)); 
        life = initial_life;
        shield.reset();
      } else {
        ships.remove(this);
      }
    }
  }

  void hitRocketLaser(solidBody i) {
    //when rocket dies it makes an explosion
    if (i instanceof Laser) {
      i.hitResponse();
    }

    if (shield.isActive()) {
      shield.hit(i.damage);
      i.life -= shield.damage;
      if (shield.isActive()) {
        i.life = 0;  //life of a missile is zero if it hits and explodes
        life -= i.damage;
      }
    } else {
      if (i instanceof Laser) {
        animations.add(new Explosion(i.pos, 8));
      }
      //i.life -= damage;
      i.life = 0;  //life of a missile is zero if it hits and explodes
      life -= i.damage;
    }
  }

  void hitBlast(solidBody i) {
    float relativeAngle = atan2(pos.y - i.origin.y, pos.x - i.origin.x);
    if (relativeAngle >= i.getAngle() - i.getRange()/2 && relativeAngle <= i.getAngle() + i.getRange()/2) {
      if (shield.isActive()) {
        shield.hit(i.damage);
        i.life -= shield.damage;
      } else {
        i.life -= damage;
        life -= i.damage;
      }
    }
    //if ((relativeAngle >= i.angle - i.range/2 && relativeAngle <= i.angle + i.range/2) && (pos.dist(i.pos) <= minimumDistance)) {
    //  animations.add(new Explosion(i.pos, 0));
    //  if (shield_power > 0) {
    //    i.life -= shield_damage;
    //    shield_power -= i.damage;
    //    showShield = frameCount;
    //  } else {
    //    i.life -= damage;
    //    life -= i.damage;
    //  }
    //}
  }

  void hitAsteroid(Asteroid i) {
    minimumDistance = (shield.isActive())? shield.r:shipRadius;
    if (pos.dist(i.pos) <= minimumDistance + i.r/2) {
      if (shield.isActive()) {
        shield.hit(i.damage);
        i.life -= shield.damage;
        i.life = 0;
      } else {
        i.life = 0;
        //life -= i.damage;
        life = 0;
      }
      animations.add(new Explosion(i.pos, 0));


      if (i.life > 0) {
        i.vel.rotate(HALF_PI);
      }
    }
  }

  void hit(solidBody i) {
    minimumDistance = (shield.isActive())? shield.r:shipRadius;
    if ((i.id != id && group != i.group && pos.dist(i.pos) <= minimumDistance)) {
      if (i instanceof Laser || i instanceof Weapon) {
        hitRocketLaser(i);
      } else if (i instanceof Blast) {
        hitBlast(i);
      }
    }
  }

  void userMove() {
    //if (keyMap.get('w')) pos.y -= speed;
    //if (keyMap.get('s')) pos.y += speed;
    //if (keyMap.get('a')) pos.x -= speed;
    //if (keyMap.get('d')) pos.x += speed;
    vel.set(0, 0);
    if (!(keyMap.get('w') && keyMap.get('s'))) {
      if (keyMap.get('w')) vel.y = -1;
      else if (keyMap.get('s')) vel.y = 1;
    }
    if (!(keyMap.get('a') && keyMap.get('d'))) {
      if (keyMap.get('a')) vel.x = -1;
      else if (keyMap.get('d')) vel.x = 1;
    }
    vel.setMag(speed);
    move();
  }

  void move() {
    pos.add(vel);
  }

  void spin() {
    angle = (angle < TWO_PI)? angle+0.002: 0;
  }

  Weapon fire(PVector pos_, PVector target_) {
    return new Weapon();
  }

  Weapon fire(PVector pos_, float x, float y) {
    return new Weapon();
  }

  void shoot() {
    if (timer(fireTime, reloadTime)) {
      if (mousePressed && mouseButton == LEFT) wepons.add(fire(pos, mouseX+pos.x-width/2, mouseY+pos.y-height/2));
      //if (mousePressed && mouseButton == RIGHT) wepons.add(new Laser(pos, mouseX+pos.x-width/2, mouseY+pos.y-height/2, id, group));
      //if (keyMap.get(' ')) wepons.add(new Blast(pos, mouseX+pos.x-width/2, mouseY+pos.y-height/2, id, group, damage));
      if (keyMap.get('t')) wepons.add(new STM(pos, mouseX+pos.x-width/2, mouseY+pos.y-height/2, id, group));
      fireTime = frameCount;
    }
  }

  void autoShoot(PVector target) {
    if (timer(fireTime, reloadTime)) {
      //wepons.add(new TM(pos, target, rocketType, id, group, damage, damage));
      wepons.add(fire(pos, target));
      //wepons.add(new Blast(pos, target, id, group, damage));
      fireTime = frameCount;
    }
  }

  //void burst() {
  //  if (keyPressed) {
  //    for (float a=0; a<TWO_PI; a += 0.1) {
  //      //stroke(255);
  //      //strokeWeight(10);
  //      //point(50*cos(a)+pos.x, 50*sin(a)+pos.y);
  //      //strokeWeight(1);

  //      if (key == 'g') wepons.add(new Rocket(pos, 50*cos(a)+pos.x, 50*sin(a)+pos.y, missileType, id, group, damage, damage, missile_speed));
  //      if (key == 'h') wepons.add(new STM(pos, 50*cos(a)+pos.x, 50*sin(a)+pos.y, 7, id, group, damage, damage, missile_speed));
  //    }
  //    fireTime = frameCount;
  //  }
  //}

  void follow(PVector pos_) {
    float followDistance = 150;
    angle = atan2(vel.y, vel.x) - HALF_PI;
    vel = pos_.copy();
    vel.sub(pos);
    vel.normalize();
    vel.mult(speed);

    if (pos.dist(pos_) > followDistance) {
      for (int i=0; i<ships.size(); i++) {
        if (ships.get(i).group == group) {
          float dis = pos.dist(ships.get(i).pos);
          constrain(dis, 0, followDistance);
          float forceMag = 1 - map(dis, 0, followDistance, 0, 1);
          PVector force = ships.get(i).pos.copy();
          force.sub(pos);
          force.normalize();
          force.mult(-forceMag);
          pos.add(force);
        }
      }
      move();
    }
  }

  void battel() {
    int closest = 0;

    for (int i=0; i<ships.size(); i++) {
      if (ships.get(i).group != group) {
        closest = i;
        break;
      }
    }

    for (int i=0; i<ships.size(); i++) {
      if (ships.get(i).group != group) {
        if (pos.dist(ships.get(i).pos) <= pos.dist(ships.get(closest).pos)) closest = i;
      }
    }
    if (ships.get(closest).group != group) {
      follow(ships.get(closest).pos);
      autoShoot(ships.get(closest).pos);
    }
  }

  //void AvoidMissile(Rocket i) {
  //  if (id != i.id && group != i.group) {
  //    PVector safe_direction = i.pos.copy();
  //    safe_direction.rotate(HALF_PI + i.angle);
  //    safe_direction.normalize();
  //    safe_direction.mult(speed);
  //    vel.add(safe_direction);
  //    vel.normalize();
  //    vel.mult(speed);
  //  }
  //}
}
