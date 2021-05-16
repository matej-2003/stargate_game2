class Stargate {
  PVector pos = new PVector();
  float index = 0;
  float animation_speed = 0.18;
  boolean start = false;

  void show() {
    if (keyPressed && key == 'k') start = true;
    if (start) {
      if (index == 0) sound_files[0][11].play();

      if (int(index + animation_speed) < supergate_images.length -1) {
        index += animation_speed;
      }
      constrain(index, 0, supergate_images.length);
      image(supergate_images[int(index)], 0, 0);
    }
  }
}
