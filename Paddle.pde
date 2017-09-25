class Paddle
{
  
  
  float w = 120;
  float h = 20;
  
  PVector pos = new PVector( (width / 2) - (w / 2), height - 80);
  
  boolean isMovingLeft = false;
  boolean isMovingRight = false;
  
  boolean passThrough = false;
  
  float mouseCurrent = 0;
  float mousePrevious = 0;
  
  void move(float step)
  {
    pos.x += step;
  }
  
  void changeWidth(float chng)
  {
    w += chng;
  }
  
  void checkEdges()
  {
    if (pos.x < 100)
      pos.x = 100;
      
    if (pos.x + w > width - 100)
      pos.x = width - w - 100;
  }
  
  void update()
  {
    mouseCurrent = mouseX;
    float dMouse = mousePrevious - mouseCurrent;
    pos.x = mouseX;
    
    if (isMovingLeft)
      move(-20);
      
    if (isMovingRight)
      move(20);
    
    mousePrevious = mouseCurrent;
  }
  
  void shrink()
  {
    w += -3;
  }
  
  void show()
  {
    if(passThrough)
      fill(100);
    else
      fill(255);

    rect(pos.x, pos.y, w, h);
  }
}