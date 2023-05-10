class Ball {
  //PVector variables that store each cannonballs position, velocity, and acceleration.
  PVector location, velocity, acceleration;
  //PImage variable that stores the cannonball image.
  PImage ballImg;
  //Boolean variable (a) that keeps track of whether each cannonball is "alive" or not. (drawExp) keeps track of whether the target has been hit or not.
  Boolean a, drawExp;

  //Contructor the takes in the initial velocity of the cannonball as a parameter.
  Ball(PVector initialVelocity) {
    //Set the initial location of the cannonball to the base of the cannon.
    location = new PVector(70, 520);
    //Set velocity to the argument passed in as parameter.
    velocity = initialVelocity;
    //Set acceleration to a constant simulated gravity.
    acceleration = new PVector(0, 0.25);
    //Load the cannonball image.
    ballImg = loadImage("Cannonball.png");
    a = true;
    drawExp = false;
  }

  //Function that moves the cannonball.
  void move() {
    location.add(velocity);
    velocity.add(acceleration);
    display();
  }

  //Function that displays the cannonball in a seperate coordinate system with origin being at the
  //vector location x and y components.
  void display() {
    pushMatrix();
    translate(location.x, location.y);
    image(ballImg, 0, 0);
    popMatrix();
  }

  //Function that checks if the cannonball has hit the ground.
  boolean groundCollision() {
    //If the cannonball has hit the ground, set boolean value a to false and return true.
    if (location.y > 546) {
      a = false;
      return true;
      //If the cannonball has not hit the ground, return false.
    } else {
      return false;
    }
  }

  //Function that checks if the cannonball has hit the target.
  void targetCollision() {
    //Checks if the cannonball has hit the target (by comparing the distances between their centers to the sum of their radii).
    if (dist(currentGame.targetX, currentGame.targetY, location.x, location.y) < (ballImg.width / 2 + currentGame.target.width / 2)) {
      //Set a to false.
      a = false;
      //Calls the placeTarget function from the game class to set the target to a different location.
      currentGame.placeTarget(true);
      //Increase the targetsHit variable in the game class by one.
      currentGame.targetsHit++;
      //Set drawExp to true.
      drawExp = true;
      //When the target has not been hit, set drawExp to false.
    } else {
      drawExp = false;
    }
  }

  //Function that checks if the cannonball has gone past the right side of the window.
  void offScreen() {
    //If the cannonball has gone past the right side of the window, set a to false..
    if (location.x > 1068) {
      a = false;
    }
  }
}
