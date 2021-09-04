class Stargate {
  PVector pos = new PVector();
  float index = 0;
  float animation_speed = 0.18;
  boolean activated = false;
  float w, h;
  float spawnTimer, spawnInterval = gameTime(1000);
  float delayTimer, delayInterval = gameTime(1000);
  int ship_number = 1;

  Stargate() {
    pos.set(width/2, height/2);
    w = supergate_images[0].width;
    h = supergate_images[0].height;
    spawnTimer = frameCount;
  }

  void show() {
    if (!activated && keyPressed && key == 'k') {
      activated = true;
      sound_files[0][11].play();
    }
    if (activated) {
      if (int(index + animation_speed) <= supergate_images.length -1) {
        index += animation_speed;
        constrain(index, 0, supergate_images.length);
      } else spawnTimer = frameCount;
    }
    image(supergate_images[int(index)], pos.x, pos.y);
  }

  void spawn() {
    //spawn point from the center og the image
    float spawn_x = pos.x + 1/4 * w;
    float spawn_y = pos.y;

    if (activated && timer(spawnTimer, spawnInterval) && ship_number > 0) {
      if (!sound_files[0][11].isPlaying()) sound_files[0][11].play();

      OriMothership tmp = new OriMothership(1);
      tmp.pos.set(spawn_x, spawn_y);
      ships.add(tmp);
      ship_number--;
      spawnTimer = frameCount;
      if (ship_number == 0) delayTimer = frameCount;
    }
  }

  void deactivate() {
    if (timer(delayTimer, delayInterval) && ship_number == 0) {
      if (index > 5) {
        index = 5;
        sound_files[0][1].play();
        animation_speed = 0.08;
      }
      if (int(index - animation_speed) >= 0) index -= animation_speed;
    }
  }
}
