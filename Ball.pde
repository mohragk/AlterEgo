class Ball
{
  float speed = 0;
  PVector pos  = new PVector(0, 0);
  PVector dir  = new PVector(1, 1);
  //PVector vel = new PVector(1,1).mult(speed);
  
  PVector prevPos = new PVector(0,0);
  
  boolean OOB = false;
  boolean stick = true;
  
  boolean alter = false;
  
  float r = 10;
  
  float padPosX = 0;
  float padPosY = 0;
  
  float dt = 0;
 
  Ball(boolean alt)
  {
    alter = alt;
    if(hardmode)
      speed = 450;
    else
      speed = 350;
  }
  
  //boolean hitBlock(Block b)
  //{
  //  // bottom check
  //  if (pos.y - r - 5 < b.y + b.h + 5 && pos.y + r > b.y + b.h && dir.y < 0)
  //    if (pos.x > b.x && pos.x < b.x + b.w)
  //    {
  //      //pos.y = b.y + b.h + r;
  //      dir.y *= -1;
  //      return true;
  //    }
      
      
  //  // left check
  //  if (pos.y < b.y + b.h && pos.y > b.y )
  //    if (pos.x > b.x - 5 && pos.x < b.x && dir.x > 0)
  //    {
  //      //pos.x = b.x - r;
  //      dir.x *= -1;
  //      return true;
  //    }
      
  //   // right check
  //   if (pos.y < b.y + b.h && pos.y > b.y)
  //     if(pos.x < b.x + b.w + 5 && pos.x  > b.x + b.w  && dir.x < 0)
  //     {
  //       //pos.x = b.x + b.w + r;
  //       dir.x *= -1;
  //       return true;
  //     }
         
  //   // top check
  //   if (pos.y + r + 5 > b.y - 5 && pos.y - r < b.y && dir.y > 0)
  //     if (pos.x > b.x && pos.x < b.x + b.w)
  //     {
  //       //pos.y = b.y - r;
  //       dir.y *= -1;
  //       return true;
  //     }
     
  //  return false;
  //}
  
 boolean hitBlockSimple(Block b)
 {
   int bound = 0;
   if ( pos.x - r  < b.x + b.w + bound && pos.x + r > b.x - bound)
     if (pos.y - r < b.y + b.h + bound && pos.y + r  > b.y - bound)
     {
       if ( b.top.intersects(this) && dir.y > 0 )
       {
         dir.y *= -1;
         pos = prevPos;
         //pos.y = b.y - r;
         return true;
       }
       if ( b.right.intersects(this) && dir.x < 0 )
       {
         dir.x *= -1;
         pos = prevPos;
         //pos.x = b.x + b.w + r;
         return true;
       } 
       if ( b.bottom.intersects(this) && dir.y < 0 )
       {
         dir.y *= -1;
         pos = prevPos;
         //pos.y = b.y + b.h + r;
         return true;
       } 
       if (b.left.intersects(this) && dir.x > 0 )
       {
         dir.x *= -1;
         pos = prevPos;
         //pos.x = b.x - r;
         return true;
       }
     }
     
    return false;
 }
  

  
  void edges()
  {
    int border = 100;
    if ( pos.y < r  && dir.y < 0 )
    {
      float pan = map(pos.x, 0, width, -0.75, 0.75);
      wallHit.play();
      dir.y *= -1;
      pos = prevPos;
    }
      
    if ( pos.y + r > height + 10 && dir.y > 0 )
      OOB = true;
      
    if ( pos.x < r + border && dir.x < 0 )
    {
      float pan = map(pos.x, 0, width, -0.75, 0.75);
      wallHit.play();
      dir.x *= -1;
       pos = prevPos;
    }
      
    if ( pos.x + r > width - border && dir.x > 0 )
    {
      float pan = map(pos.x, 0, width, -0.75, 0.75);
      wallHit.play();
      dir.x *= -1;
       pos = prevPos;
    }
      
  }
  
  void checkPaddle(Paddle pad)
  {
    if(pad.passThrough == false)
    {
      if (pos.y < pad.pos.y && 
          pos.y > pad.pos.y - r &&
          pos.x > pad.pos.x - r &&
          pos.x < pad.pos.x + pad.w + r ) 
          {
            if (dir.y > 0 )
            {
              
              paddleHit.play();
              float diff = pos.x - (pad.pos.x + pad.w / 2);
              float angle = map(diff, -pad.w / 2, pad.w / 2, radians(225), radians(315));
              dir.x = cos(angle);
              dir.y = sin(angle);
              pos = prevPos;
              if (alter)
              {
                if(hardmode)
                  pad.changeWidth(-10);
                 else
                   pad.changeWidth(-5);
              }
              else
              {
                if (hardmode)
                  pad.changeWidth(10);
                else
                  pad.changeWidth(6);
              }
                
            }
          }
    }
         
  }
  
 void hitsBall(Ball b)
 {
   float d = dist(pos.x, pos.y, b.pos.x, b.pos.y);
   if (!stick && !b.stick)
   {
     if ( d < r + b.r){
       float pan = map(pos.x, 0, width, -0.75, 0.75);
       
       ballHitsBall.play();
       pos = prevPos;
       dir.x *= -1;
       dir.y *= -1;
     }
   }
 }
  void shoot()
  {
    if(stick)
    {
      dir.y = -1;
      dir.x = random(-0.7, 0.7);
      stick = false;
    }
  }

  
  void reset()
  {
    dir.x = 0;
    dir.y = 0;
    stick = true;
    OOB = false;
  }
  
  void update(Paddle p, float offset)
  {
    dt = 1 / frameRate;
    dir.normalize();
    if (stick)
    {
      pos.x = p.pos.x + p.w / 2;
      pos.y = p.pos.y - 30 - offset;
    }
    pos.x +=  dir.x * (speed * dt);
    pos.y +=  dir.y * (speed * dt);
    
    prevPos = pos;
 
  }
  
  void show(boolean inverse)
  {
    
    if (stick)
      {
        fill(55);
        stroke(200);
      }
    
    else if (inverse)
    {
        fill(0);
        stroke(255);
    } 
    else
    {
      fill(255);
      stroke(0);
    }
    ellipseMode(CENTER);
    ellipse(pos.x, pos.y, r * 2, r * 2);
    //text(name, pos.x + 10, pos.y - 10);
  }
  
}