class Shield {  
  int type = 0;
  //power is like life
  float r, power, initialPower, damage;
  float showTime = 30, healingSpeed = 10, healValue = 10;
  float healTimer, showTimer;
  boolean invisible = true;
  int sound_type = 0;

  Shield(float r_, float power_, float damage_, int type_,  boolean invisible_, float healingSpeed_, float healValue_, float showTime_) {
    r = r_;
    power = power_;
    initialPower = power_;
    damage = damage_;
    type = type_;
    invisible = invisible_;
    healingSpeed = healingSpeed_;
    healValue = healValue_;
    healTimer = frameCount;

    showTime = showTime_;
    showTimer = frameCount;
  }

  void reset() {
    power = initialPower;
    healTimer = frameCount;
    showTimer = frameCount;
  }

  void show() {
    if (isHealing() && !timer(showTimer, showTime)) {
      image(shields[type], 0, 0, 1.4*r, 1.4*r);
    }
  }

  boolean isHealing() {
    return int(power) < int(initialPower);
  }

  void heal() {
    if (isHealing() && timer(healTimer, healingSpeed)) {
      power += healValue;
      constrain(power, 0, initialPower);
    }
  }

  boolean isActive() {
    return int(power) > 0;
  }

  void hit(float damage) {
    power -= damage;
    constrain(power, 0, initialPower);
    showTimer = frameCount;

    //if (sound_files[0][0].isPlaying()) sound_files[0][0].stop();
    //sound_files[0][0].play();
  }
}
