class Explosion extends solidBody {
  int index, frameNumber, type;
  float distructionRadius, maxDamage = 40;
  int effectedIds[] = new int[5];
  int EIDAC = 0;  //EIDAC = effectedId Array Counter

  Explosion(PVector pos_, int type_, int sound_type) {
    pos = pos_.copy();
    type = type_;
    frameNumber = explosion_images[type_].length;
    distructionRadius = 30;
    damage = 20;

    sound_files[3][sound_type].play();
  }

  Explosion(PVector pos_, int type_) {
    pos = pos_.copy();
    type = type_;
    frameNumber = explosion_images[type_].length;
    distructionRadius = 30;
    damage = 20;
  }

  boolean effected(PVector pos_) {
    return pos_.dist(pos) <= distructionRadius;
  }

  void effected1(solidBody i) {
    float distance = i.pos.dist(pos);
    boolean effect = true;
    if (type <= 2 && i.pos.dist(pos) <= distructionRadius) {
      damage = map(distance, 0, distructionRadius, 40, 0);
      println(damage, i.id);

      for (int j=0; j<effectedIds.length; j++) {
        if (effectedIds[j] == i.id) {
          effect = false;
          break;
        }
      }

      println("before: ", effect, effectedIds, EIDAC, i.life);
      if (effect) {
        effectedIds[EIDAC] = i.id;  //put the effected id of the solid object onto array and than
        EIDAC = (EIDAC + 1) % effectedIds.length;  //loope counter from (0, effectedIds.length)
        i.life -= damage;
      }

      println("after: ", effect, effectedIds, EIDAC, i.life);
    }
  }

  void show() {
    if (index < frameNumber - 1) {
      image(explosion_images[type][index], pos.x, pos.y);
      index = int(index + explosionVel);
    } else {
      animations.remove(this);
    }
  }
}
