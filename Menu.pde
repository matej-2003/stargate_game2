class Menu {
  float h, x, y;
  StringDict menuList = new StringDict();
  int maxKeyLength = 0, maxValueLength = 0, keyPadding, valuePading;
  int spacing = 10, c;
  float w;
  String printed, keyString, valueString;


  Menu(float x_, float y_, color c_) {
    x = x_;
    y = y_;
    c = c_;
    init();
  }

  void setPos(float x_, float y_) {
    x = x_;
    y = y_;
  }

  void init() {
    menuList.set("Life:", "");
    menuList.set("Damage:", "");
    menuList.set("Speed:", "");
    menuList.set("Shield damage:", "");
    menuList.set("Shield integrity:", "%");

    if (menuList.size() > 0) {
      maxKeyLength = menuList.keyArray()[0].length();
      maxValueLength = menuList.get(menuList.keyArray()[0]).length();
    }

    //calculates the longest key, value
    for (String v : menuList.keyArray()) {
      if (v != null && menuList.get(v) != null) {
        if (maxKeyLength < v.length()) maxKeyLength = v.length();
        if (maxValueLength < menuList.get(v).length()) maxValueLength = menuList.get(v).length();
      }
    }
    w = (10 + maxKeyLength + spacing + maxValueLength) * charWidth;  //maximum width of the printed text (2=space added st both ends) (number of characters)*charWidth
    h = menuList.size() * charHeight + charHeight/2;
  }

  void update(Ship i) {
    menuList.set("Life:", i.life + "");
    menuList.set("Damage:", i.damage + "");
    menuList.set("Speed:", i.speed + "");
    menuList.set("Shield damage:", "0");
    menuList.set("Shield integrity:", i.shield.power+"%");
  }

  void display() {
    float counter = charHeight;

    //noFill();
    fill(color(#000C8B, 200));
    rect(x, y, w, h);  //draw a rectangle around the text with x,y pos and w,h dimensions    

    stroke(c);
    fill(c);

    //array is used to display on the screen
    for (String Key : menuList.keyArray()) {
      //keyPadding = maxKeyLength - Key.length();  //calculates the padding of " " chars it needs to add a the end of key
      //valuePading = maxValueLength - menuList.get(Key).length();  //same with value

      //keyString = Key + repeat(" ", keyPadding);    //key concat with its padding
      //valueString = repeat(" ", valuePading) + menuList.get(Key);  //same with value

      //printed = " " + keyString + repeat(" ", spacing) + valueString + " ";  //printed text and some padding

      //printed = Key; 
      //text(printed, x, y+counter);

      text(" " + Key, x, y+counter);
      text(menuList.get(Key), x + (2 + maxKeyLength + spacing) * charWidth, y+counter);

      counter += charHeight;  //increments the counter by the charHeight
      //text grows down with each iteration
    }
  }
}
