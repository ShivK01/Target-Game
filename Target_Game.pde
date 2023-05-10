/*
 Hit The Target Game
 Shiv Krishnaswamy
 April 17, 2020
 
 This program is a game in which the user has to hit the target with the cannonball fired from a cannon. The user is given
 20 cannonballs and can adjust the power and launch angle with the arrow keys. Then, the user can press the space bar to fire the cannonball.
 If the cannonball hits the target, the target randomly relocates to another place on the window with an explosing effect preceding it. 
 If the cannonball hits the ground within the window, there is a smoke effect that rises from the ground where the cannonball hit. 
 Finally, when the user has fired all 20 cannonballs, the game gives a bit of feedback on how the user did like accuracy, a ranking, and a message.
 If the user desires to play again, he/she can press the enter key. Additionally, the user can see how many targets he/she has hit,
 how many cannonballs are remaining, and the power given to the cannon through visuals at the top of the screen.
*/

Game currentGame;
//Array list that holds the Explosion objects.
ArrayList<Explosion> explosion = new ArrayList<Explosion>();

void setup() {
  size(1068, 600);
  //Initializes currentGame to a new Game object
  currentGame = new Game();
}

void draw() {  
  //Adds a new Explosion object to the explosion array list when a cannonball hits the target.
  if (currentGame.drawExplosion) {
    explosion.add(new Explosion(currentGame.explosionX, currentGame.explosionY));
    //Update the variable and set it to false so multiple Explosion objects aren't created in one interation of draw.
    currentGame.drawExplosion = false;
  }
  //Calls the playGame function from the Game class.
  currentGame.playGame();
  //Every second frame, change the image of the explosion at position e in the array list to the next one.
  if (frameCount % 2 == 0) {
    for (int e = 0; e < explosion.size(); e++) {
      explosion.get(e).display(true);
      //If the explosion object at position e in the array list has drawn its last image (explosion animation is finished), remove it.
      if (explosion.get(e).draw == false) {
        explosion.remove(e);
      }
    }
    //When frame count mod 2 isn't 0, draw the current image again for each object in the array list.
  } else {
    for (int e = 0; e < explosion.size(); e++) {
      explosion.get(e).display(false);
    }
  }
  //When the game is not over, run the keyInput function. When the game is over, don't.
  if (currentGame.ballsCollided != 20) {
    keyInput();
  }
}

//Function that handles arrow key inputs(regulates cannon launch angle and cannon power). 
void keyInput() {
  if (keyPressed) {
    if (keyCode == UP) {
      currentGame.changeCannonPower(true);
    } else if (keyCode == DOWN) {
      currentGame.changeCannonPower(false);
    } else if (keyCode == RIGHT) {
      currentGame.changeCannonAngle(false);
    } else if (keyCode == LEFT) {
      currentGame.changeCannonAngle(true);
    }
  }
}

void keyPressed() {
  //When the space bar is pressed, call the createShot function in the game class.
  if (key == ' ') {
    currentGame.createShot();
  }
  //When the game is over and the enter key is pressed, create a new Game object(restart game).
  if (currentGame.ballsCollided == 20 && keyCode == ENTER) {
    currentGame = new Game();
  }
}
