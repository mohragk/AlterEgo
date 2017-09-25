import processing.sound.*;






SoundFile blockHit, paddleHit, wallHit, ballLost, ballHitsBall;
SoundFile alter_track, ego_track;




int playhead = 0;

ArrayList<Block> blocks;

Ball ballA, ballB;
int numBallsA = 0;
int numBallsB = 0;

int gridCols = 20;
int gridRows = 5;

Menu main;

boolean intro = true;

float frames = 0;
float curFrame = 0;
float rest = 0;

PFont futura60;
PFont futura20;

String gameOver = "game over";
String gameWon = "you made it.";

float alpha = 0;
float alphablend = 0;

boolean shiftKey = false;
boolean controlKey = false;


boolean menu = true;

boolean reset = true;
boolean introplayed = false;

boolean hardmode = false;
boolean easymode = false;

//Ball ball, ball2;
Paddle paddle; 

void setup()
{
  size(1000, 700, P2D);
  frameRate(120);

  futura60 = loadFont("Futura-Medium-60.vlw"); 
  futura20 = loadFont("Futura-Medium-20.vlw");
  
  main = new Menu();
  reset();
}

void reset()
{
  rectMode(CORNER);
  
  // load blocks
  blocks = new ArrayList<Block>();
  for (int i = 0; i < gridRows; i++)
  {
    for (int j = 0; j < gridCols; j++)
      blocks.add( new Block((float)j * 40 + 100, (float) i * 20 + 100));
  }
  
  if (easymode)
  {
    numBallsA = 5;
    numBallsB = 5;
  } else if (hardmode)
  {
    numBallsA = 3;
    numBallsB = 3;
  }
  
  ballA = new Ball(false);
  ballB = new Ball(true);
  
  // load paddle
  paddle = new Paddle();
  
  //load sounds
  
  blockHit = new SoundFile(this, "ark blockHit.wav");
  wallHit =  new SoundFile(this, "ark wallHit.wav");
  paddleHit =  new SoundFile(this, "ark paddleHit.wav");
  ballLost =  new SoundFile(this, "ark ballLost.wav");
  ballHitsBall =  new SoundFile(this, "ark ballHitsBall.wav");
  
  ego_track   = new SoundFile(this, "ego_track.wav");
  alter_track = new SoundFile(this, "alter_track.wav");
//tail2_audio = minim.loadFile("tail2.wav");
 
  frames = gridRows * gridCols;
  
}



void mousePressed()
{
  if (mouseButton == LEFT && menu)
  {
    if (main.hard.buttonHit())
    {
      hardmode = true;
      easymode = false;
      menu = false;
      reset();
    }
    
    if (main.easy.buttonHit())
    {
      easymode = true;
      hardmode = false;
      menu = false;
      reset();
    }
  }
  
  else if (mouseButton == LEFT && intro == false)
  {
    if(numBallsA != 0)
      ballA.shoot();
    
    if(numBallsB != 0 )
      ballB.shoot();
  }
}

void keyReleased()
{
  paddle.isMovingLeft = false;
  paddle.isMovingRight = false;
  shiftKey = false;
  controlKey = false;
  
}

void mouseWheel(MouseEvent ev)
{
  float e = ev.getCount();
  if (shiftKey)
    paddle.changeWidth(e * 10);
    
  //if(controlKey)
    //ball.speed += e * 100;
}


boolean checkStick(Ball b)
{
  return b.stick;
}

void checkBlockHits(Ball b)
{
  for (int i = blocks.size() - 1; i >= 0; i--)
  {
    
    if ( b.hitBlockSimple( blocks.get(i) ) ) 
    {
      //println(blocks.get(i).m);
      blocks.get(i).top.intersects(b);
      float pan = map(b.pos.x, 0, width, -0.75, 0.75);
      blockHit.play();
      blocks.remove(i);
    }
  }
}



void draw()
{
  background(11);
  
  
  if (menu)
  {
    main.show();    
  }
  //text(frameRate, 10, 10);
  //if ((gridRows * gridCols) - (int)rng == blocks.size())
  //{
  //  //text("Here we go!", width /2, height /2);
  //  numBallsB = 3;
  //}
  
  if (frames > curFrame && menu == false)
  {
    
    noCursor();
    
    for (int i = 0; i < curFrame - rest; i++)
    {
      Block block = blocks.get(i);
      block.show();
    }
    
    
      
    // draw remaining Aballs
    for (int a = 0; a < numBallsA; a++)
    {
      float xPos = (width - 60);
      float yPos = height - 40 - a * 20; 
      fill(255);
      stroke(0);
      ellipse(xPos, yPos , 15, 15);
    }
    // draw remaining Bballs
    for (int b = 0; b < numBallsB; b++)
    {
      float xPos = (width - 30);
      float yPos = height - 40 - b * 20; 
      fill(0);
      stroke(255);
      ellipse(xPos, yPos , 15, 15);
    }
    
    paddle.update();
    paddle.checkEdges();
    paddle.show();
    paddle.passThrough = true;
    curFrame++;
    
    ballA.update(paddle, 0);
    ballA.edges();
    ballA.checkPaddle(paddle);
    checkBlockHits(ballA);
    ballA.show(false);
    
    ballB.update(paddle, 30);
    ballB.edges();
    ballB.checkPaddle(paddle);
    checkBlockHits(ballB);
    ballB.show(true);
    
    noFill();
    stroke(120);
    strokeWeight(2);
    rect(99, 2, 802, 900);
    
    
  }
  
  else if (numBallsA > 0 && numBallsB > 0 && blocks.size() > 0 && paddle.w > 0 && menu == false)
  {
    
    intro = false;
    noCursor();
    paddle.update();
    paddle.checkEdges();
    paddle.show();
    
    noFill();
    stroke(120);
    strokeWeight(2);
    rect(99, 2, 802, 900);
    
    
    
    
    if( numBallsA == 0 || numBallsB == 0 )
      paddle.passThrough = true;
    else
      paddle.passThrough = false;
    
    if (numBallsA > 0 && numBallsB > 0)
    {
      if(ballA.stick || ballB.stick)
        paddle.passThrough = true;
    }
    else if (numBallsA > 0 && ballA.stick)
    {
      paddle.passThrough = true;
    }
    else if (numBallsB > 0 && ballB.stick)
      paddle.passThrough = true;
    else
      paddle.passThrough = false;
      
   // println(paddle.passThrough);
    
    if (numBallsA != 0)
    {
      ballA.update(paddle, 0);
      ballA.edges();
      ballA.checkPaddle(paddle);
      checkBlockHits(ballA);
      if (ballB != null)
        ballA.hitsBall(ballB);
      ballA.show(false);
      
      
      
      if (ballA.OOB )
      {
        ballLost.play();
        numBallsA--;
        if (numBallsA > 0)
        {
          ballA.reset();
        }
         else
         {
           ballA = null;
         }
        
      }
    }
    
    if(numBallsB != 0)
    {
      ballB.update(paddle, 30);
      ballB.edges();
      ballB.checkPaddle(paddle);
      checkBlockHits(ballB);
      
      if (ballA != null)
        ballB.hitsBall(ballA);
      
      ballB.show(true);
      
      
      
      if (ballB.OOB )
      {
        ballLost.play();
        numBallsB--;
        if (numBallsB > 0)
        {
          ballB.reset();
        }
        else
        {
          ballB = null;
        }
      }
    }
     
    
      
    
    // draw remaining Aballs
    for (int a = 0; a < numBallsA; a++)
    {
      float xPos = (width - 60);
      float yPos = height - 40 - a * 20; 
      fill(255);
      stroke(0);
      ellipse(xPos, yPos , 15, 15);
    }
    // draw remaining Bballs
    for (int b = 0; b < numBallsB; b++)
    {
      float xPos = (width - 30);
      float yPos = height - 40 - b * 20; 
      fill(0);
      stroke(255);
      ellipse(xPos, yPos , 15, 15);
    }
    
    for ( int f = 0; f < blocks.size(); f++ )
    {
      Block block = blocks.get(f);
      block.show();
    }
    
  }
  
 if (!menu)
 { 
   if (numBallsA == 0 || numBallsB == 0)
   { 
     
     //if (introplayed == false)
     //{
     //  intro_audio.play();
     //  introplayed = true;
     //}
     
     //if(introplayed && intro_audio.isPlaying() == false && loop_audio.isLooping() == false)
     //  loop_audio.loop();
     
     
     
     if (introplayed == false)
     {
       alter_track.play();
       introplayed = true;
     }
    
     
     
     alpha += 0.6;
     fill(255, 255, 255, alpha);
     textFont(futura60);
     textAlign(CENTER, CENTER);
     text(gameOver, width / 2, height / 2);
     textSize(30);
     //text("press 'r' to retry", width / 2, (height / 2) + 130);
     cursor();
   }
   
   if (blocks.size() == 0)
   {
    
     if (introplayed == false)
     {
       ego_track.play();
       introplayed = true;
     }
     
       
     background(255);
     paddle = null;
     
     alpha += 3;   
     fill(12, 12, 12, alpha);
     
     textFont(futura60);
     textAlign(CENTER, CENTER);
     text(gameWon, width / 2, height / 2);
     textSize(30);
     //text("press 'r' to replay", width / 2, (height / 2) + 130);
     cursor();
   }
    
 }
  
 
 
  
  
  
  
}