class Asteroid extends Body { //<>//
  float maxVel = 3;
  float angle = 0;
  int type, index = 0;
  float spinCount = frameCount, spinVel = 3;
  float initial_life = 60;
  float r = 20, life = initial_life, damage = 10;

  Asteroid() {
    pos = new PVector(random(width), random(height));
    vel = new PVector(random(-maxVel, maxVel), random(-maxVel, maxVel));
    type = int(random(0, asteroid_images.length));
  }

  Asteroid(int type_) {
    pos = new PVector(random(width), random(height));
    vel = new PVector(random(-maxVel, maxVel), random(-maxVel, maxVel));
    type = type_;
  }

  void move() {
    pos.add(vel);
    if (pos.x > width+screen_offset) pos.x = 1-screen_offset;
    if (pos.x < -screen_offset) pos.x = width+screen_offset-1;
    if (pos.y > height+screen_offset) pos.y = 1-screen_offset;
    if (pos.y < -screen_offset) pos.y = height+screen_offset-1;
  }

  void hit(solidBody i) {
    if (pos.dist(i.pos) <= r) {
      life -= i.damage;
      i.life = 0;
      if (i instanceof Laser) {
        animations.add(new Explosion(i.pos, 8));
      }
    }
  }

  void die(boolean respawn) {    
    if (life <= 0) {
      animations.add(new Explosion(pos, 0));
      if (type == 0) {
        Asteroid tmp1 = new Asteroid(1);
        tmp1.pos = pos.copy();
        tmp1.vel = vel.copy();
        tmp1.vel.set(tmp1.vel.x + random(-maxVel, maxVel), tmp1.vel.y + random(-maxVel, maxVel));
        tmp1.vel.mult(-1);
        tmp1.pos.add(tmp1.vel);

        Asteroid tmp2 = new Asteroid(1);
        tmp2.pos = pos.copy();
        tmp2.vel = vel.copy();
        tmp2.vel.set(tmp2.vel.x + random(-maxVel, maxVel), tmp2.vel.y + random(-maxVel, maxVel));
        tmp2.vel.mult(-1);
        tmp2.pos.add(tmp2.vel);


        asteroids.add(tmp1);
        asteroids.add(tmp2);
      } else if (respawn) {
        asteroids.add(new Asteroid());
      }
      asteroids.remove(this);
    }
  }

  void spin() {
    if (timer(spinCount, spinVel)) {
      index = (index + 1) % asteroid_images[type].length;
      spinCount = frameCount;
    }
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    image(asteroid_images[type][index], 0, 0);
    popMatrix();
  }
}
