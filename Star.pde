class Star extends Body {
  int type = 0;
  float animationTimer, animationInterval;
  float animationTime = gameTime(3000);
  int index = 0;

  Star(int type_) {
    pos = new PVector(random(width), random(height));
    type = type_;
    animationTimer = frameCount;

    animationInterval = animationTime / star_images[type].length;
  }

  void show() {
    if (timer(animationTimer, animationInterval)) {
      index = (index + 1) % star_images[type].length;
      pushMatrix();
      translate(pos.x, pos.y);
      image(star_images[type][index], 0, 0);
      popMatrix();
    }
  }
}
