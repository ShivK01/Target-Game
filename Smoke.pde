class Smoke {
  //PVector variables that store each Smoke objects velocity, location, and acceleration. 
  PVector velocity, location, acceleration;
  //Variables that store the size of each particle, aswell as the delay, lifetime, and the number of times the funciton move has repeated. 
  int size, frames, lifetime, countDown;
  //Variable that keeps track of whether the particle is alive (should be drawn) or not.
  boolean alive;
  //Variable that holds a colour for the particle.
  color fill;

  //Constructor of the class Smoke. Takes in the coordinates or where the cannonball hit the ground (plus the offset) as parameters.
  Smoke(float x, float y) {
    //Set velocity to a random value within limits.
    velocity = new PVector(random(-0.25, 0.25), random(-1, -0.25));
    //Set the location to the arguments passed in.
    location = new PVector(x, y);
    //Set acceleration.
    acceleration = new PVector(0, -0.02);
    //Set size of the particle to random value.
    size = int(random(5, 25));
    frames = 0;
    //Set lifetime (how many frames the particle should be drawn for) randomly.
    lifetime = int(random(30, 60));
    alive = true;
    //Set the fill colour of the particle to a random gray scale shade.
    fill = color(random(85, 150));
    //Set the delay for the particle randomly.
    countDown = int(random(5, 75));
  }

  //Function that moves the particle.
  void move() {
    //If the delay is over;
    if (countDown == 0) {
      //Add acceleration to velocity and velocity to location.
      velocity.add(acceleration);
      location.add(velocity);
      frames++;
      //If the frames variable has become greater than the lifetime variable (particle shouldn't be draw anymore), set boolean value alive to false.
      if (frames > lifetime) {
        alive = false;
      }
      display();
      //If the delay isn't over (countdown isn't 0), subtract the countdown variable by 1.
    } else {
      countDown--;
    }
  }

  //Function that displays the particle.
  void display() {
    //Draws the particle on another overlayed coordinate system with an origin located at the x and y values of the location..
    pushMatrix();
    translate(location.x, location.y);
    //As time goes on and the particles frames variable gets closer to its respective lifetime, shrink the size of the particle.
    scale(map(frames, 0, lifetime, 1, 0));
    noStroke();
    fill(fill);
    ellipse(0, 0, size, size);
    popMatrix();
  }
}
