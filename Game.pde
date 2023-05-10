class Game {
  //Array list that holds the Ball object (cannonballs fired).
  ArrayList<Ball> shots = new ArrayList<Ball>();
  //Array list that holds the Smoke object (smoke particles when the ball hits the ground).
  ArrayList<Smoke> smoke = new ArrayList<Smoke>();
  //PImage variables that hold the background image, the images for the cannon, the target image, and the background image for when the game is over.
  PImage background, cannonBase, cannonBarrel, target, gameOverBackground;
  //Array that holds the images for displaying the number of balls left to fire.
  PImage[] numBalls = new PImage[21];
  //Array that holds images for displaying the number of targets hit.
  PImage[] numTargets = new PImage[21];
  //Holds the font that the feedback when the game is finished is written in.
  PFont reportFont;
  //Variables that hold the cannon angle of inclination, cannon power, and the x and y coordinates of the target and explosion animation.
  float cannonAngle, cannonPower, targetX, targetY, explosionX, explosionY;
  //Variables that hold the width of the power rectangle display, the number of cannonballs left, the number of cannonballs that have been fired, 
  //and the x and y location of the target.
  int powerWidth, ballsRemaining, ballsCollided, targetsHit;
  //Boolean variable (drawTarget) that, when true, has the target choose new x and y coordinates(re-draws the target somewhere). 
  //(drawExplosion) controls whether an explosion object should be created or not in draw depending on whether the target has been hit.
  boolean drawTarget, drawExplosion;
  //Variables that hold the messages of what is displayed as feedback when the game is over.
  String message, accuracy, rank, playAgain;

  //Constructor of the class Game.
  Game() {
    imageMode(CENTER);
    //Calls the load images function.
    loadImages();
    //Sets the reportFont variable to the following font.
    reportFont = createFont("Constantia Bold Italic", 40);
    cannonAngle = 0;
    cannonPower = 10;
    powerWidth = int(cannonPower);
    ballsRemaining = 20;
    ballsCollided = 0;
    targetsHit = 0;
    drawTarget = true;
    drawExplosion = false;
  }

  //Main function that controls most of the game.
  void playGame() {
    //If the number of cannonballs that have collided is not 20 (if the game hasn't ended).
    if (ballsCollided != 20) {
      //Display normal background image, the number of cannonballs left to fire, and the number of targets hit.
      image(background, width / 2, height / 2);
      image(numBalls[ballsRemaining], 525, 70);
      image(numTargets[targetsHit], 885, 70);
      //If the number of cannonballs that have collided is 20 (game is ended).
    } else if (ballsCollided == 20) {
      //Display the background image for when the background is over.
      image(gameOverBackground, width / 2, height / 2);
      //Call gameOver function.
      gameOver();
    }
    //Loop through the array list shots (the cannonball that have been fired and haven't hit anything yet).
    for (int i = 0; i < shots.size(); i++) {
      //Call the move function in the Ball class to move the cannonball at position i respectively.
      shots.get(i).move();
      //Call the functions in the Ball class which check if the cannonball at position i has hit anything or gone past the right side of the screen.
      shots.get(i).groundCollision();
      shots.get(i).targetCollision();
      shots.get(i).offScreen();
      //When the variable drawExp in the Ball class is true (when the cannonball at position i has hit the target).
      if (shots.get(i).drawExp) {   
        //Set the variables for the coordinates for the explosion animation to the coordinates of the target hit.
        explosionX = shots.get(i).location.x;
        explosionY = shots.get(i).location.y;
        //Set drawExplosion to true.
        drawExplosion = true;
        //When the variable drawExp in the ball class is false (the cannonball at position i has not hit the target).
      } 
      //If the function that checks if the cannonball has hit the ground returns true.
      if (shots.get(i).groundCollision()) {
        //Add 150 Smoke objects to the smoke array list .
        for (int r = 0; r < 150; r++) {
          int offsetX = int(random(-15, 15));
          //Add the object at the location of where the cannonball hit the ground on screen.
          smoke.add(new Smoke(shots.get(i).location.x + offsetX, shots.get(i).location.y + 5));
        }
      }
      //If the boolean variable a in the Ball class is false (the cannonball at position i has hit the target, the ground, or has gone off screen).
      if (shots.get(i).a == false) {
        //Remove the cannonball at position i from the array list shots.
        shots.remove(i);
        //Increase the variable ballsCollided by 1.
        ballsCollided++;
        i--;
      }
    }
    //Call the displayCannon function (draws the cannon).
    displayCannon();
    //Loop that moves each object of Smoke in the smoke array list respectively.
    for (int s = 0; s < smoke.size(); s++) {
      smoke.get(s).move();
      //If the boolean variable alive in the Smoke class at position s in the array list is false (the particles "life" is over), remove the object.
      if (smoke.get(s).alive == false) {
        smoke.remove(s);
      }
    }
    //If the number of cannonballs that have collided is not 20 (game is still going), call the placeTarget function (draw the target).
    if (ballsCollided != 20) {
      placeTarget(drawTarget);
    }
    stroke(0);
    fill(10, 123, 137);
    //Draw the rectangle (power bar) which shows the power of the cannon (cannonPower).
    rect(70, 50, powerWidth * 9.5, 30);
  }

  //Function that loads all the PImage variables and the images in the two arrays.
  void loadImages() {
    background = loadImage("background.png");
    cannonBase = loadImage("base.png");
    cannonBarrel = loadImage("barrel.png");
    target = loadImage("target.png");
    for (int b = 0; b < 21; b++) {
      numBalls[b] = loadImage("shots" + b + ".png");
    }
    for (int t = 0; t < 21; t++) {
      numTargets[t] = loadImage("target" + t + ".png");
    }
    gameOverBackground = loadImage("backgroundReport.png");
  }

  //Function that draws the cannon by displaying the cannonBarrel and cannonBase images.
  void displayCannon() {
    //Overlaying another coordinate system to draw the cannon.
    pushMatrix();
    //Translate the origin of the overlayed coordinate system to the place where the cannon should be drawn.
    translate(73, 525);
    //Reverse the angle so that the cannon can be adjusted upwards.
    rotate(radians(cannonAngle * -1));
    image(cannonBarrel, 0, 0);
    //Take the overlayed coordinate system away.
    popMatrix();
    image(cannonBase, 73, 525);
  }

  //Function that changes the cannon angle of inclination.
  void changeCannonAngle(boolean change) {
    //If the up arrow is pressed and cannon isn't pointing vertically, increase the angle of inclination.
    if (change && cannonAngle < 90) {
      cannonAngle += 2;
      //If the down arrow is pressed and the cannon isn't pointing horizontally, decrease the angle of inclination.
    } else if (change == false && cannonAngle > 0) {
      cannonAngle -= 2;
    }
  }

  //Function that changes the power given to the cannon.
  void changeCannonPower(boolean change) {
    //If the up arrow is pressed and the cannonPower variable is less than 20, increase the cannonPower variable and set the powerWidth variable accordingly.
    if (change && cannonPower < 20) {
      cannonPower += 0.5;
      powerWidth = int(cannonPower);
      //If the down arrow is pressed and the cannonPower variable is greater than 0, decrease the cannonPower variable and set the powerWidth variable accordingly.
    } else if (change == false && cannonPower > 0) {
      cannonPower -= 0.5;
      powerWidth = int(cannonPower);
    }
  }

  //Function that adds a Ball object to the shots array list.
  void createShot() {
    //If the ballsRemaining variable is greater than 0 (there are still cannonballs left to be fired).
    if (ballsRemaining > 0) {
      //Add a Ball to the shots array list and decrease the ballsRemaining variable by 1.
      shots.add(new Ball(new PVector(cannonPower * cos(radians(cannonAngle)), cannonPower * sin(radians(cannonAngle * -1)))));
      ballsRemaining--;
    }
  }

  //Function that draws the target.
  void placeTarget(boolean draw) {
    //If the argument passed in is true (which means the target has been hit), randomly pick new coordinates for the target to be drawn at.
    if (draw) {
      targetX = random(125, 1048);
      targetY = random(145, 505);
    }
    //Draw the target on a seperate overlayed coordinate system at the origin located at the targetX and targetY values.
    pushMatrix();
    translate(targetX, targetY);
    image(target, 0, 0);
    //Take the overlayed coordinate system away.
    popMatrix();
    //Set drawTarget to false so that the target doesn't move to a new location the next time playGame() is called without the target being hit.
    drawTarget = false;
  }

  //Function that gives the feedback and is run after the game has ended.
  void gameOver() {
    textAlign(CENTER);
    //Set the text font to the reportFont variable.
    textFont(reportFont);
    //Depending on the value of the targetsHit variable (how many targets the user hit), the string message is set to an appropriate phrase.
    if (targetsHit == 20) {
      message = "Perfect!";
    } else if (targetsHit >= 15 && targetsHit < 20) {
      message = "Well Done!";
    } else if (targetsHit >= 10 && targetsHit < 15) {
      message = "Good Job!";
    } else {
      message = "Better Luck Next Time!";
    }
    //Set the string accuracy to say how many targets out of 20 the user hit and the corresponding percentage.
    accuracy = "You hit " + targetsHit + "/20 targets   (" + targetsHit * 100 / 20 + "%)";
    //Depending on the value of the targetsHit variable (how many targets the user hit), the string rank is set to an appropriate rank.
    if (targetsHit >= 19) {
      rank = "Rank: A";
    } else if (targetsHit >= 16 && targetsHit < 19) {
      rank = "Rank: B";
    } else if (targetsHit >= 13 && targetsHit < 16) {
      rank = "Rank: C";
    } else if (targetsHit >= 9 && targetsHit < 13) {
      rank = "Rank: D";
    } else if (targetsHit >= 5 && targetsHit < 9) {
      rank = "Rank: E";
    } else if (targetsHit >= 0 && targetsHit < 5) {
      rank = "Rank: F";
    }
    //Set the playAgain string to the following message.
    playAgain = "Press enter to play again";
    //Display all strings and have them centrally aligned.
    fill(209, 246, 255);
    textSize(75);
    text(message, width / 2, 200);
    textSize(40);
    text(accuracy, width / 2, 325);
    textSize(35);
    text(rank, width / 2, 375);
    textSize(25);
    text(playAgain, width / 2, 440);
  }
}
