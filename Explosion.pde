class Explosion {
  //Array that holds images for drawing explosion effect when the target is hit.
  PImage[] explosion = new PImage[6];
  //Keeps track of what image the explosion animation is currently on.
  int cur;
  //Holds the x and y coordinates of where to draw the explosion images.
  float x, y;
  //Boolean variable that keeps track of whether the explosion animation should be drawn or not (not drawn because the animation has drawn its last image).
  boolean draw;

  //Contructor of the class Explosion that takes in the coordinates of the target that has been hit as parameters.
  Explosion(float x_, float y_) {
    //Loads the images for the explosion in the explosion array.
    for (int i = 0; i < 6; i++) {
      explosion[i] = loadImage("ex" + i + ".png");
    }
    cur = 0;
    //Set the x and y variables (where the explosion animation shouls be drawn) to the arguments passed in.
    x = x_;
    y = y_;
    draw = true;
  }

  //Function that draws the explosion animation. Takes in a boolean value as a parameter which determines if the animation should draw the next image in the array or not.
  void display(boolean nextImg) { 
    if (nextImg == true) {
      //Draw the image in the array explosion at position x and y (where the target was hit).
      image(explosion[cur], x, y);
      //Increase cur by 1.
      cur++; 
      //When cur is value 6 or larger (its value is at the last position in the array), set draw to false.
      if (cur >= 6) {
        draw = false;
      }
      //When nextImg is false, draw the image at position cur again.
    } else {
      image(explosion[cur], x, y);
    }
  }
}
