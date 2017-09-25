class Block
{
  float x;
  float y;
  
  float w = 40;
  float h = 20;
  
  float health;
  
  
  Segment top, right, bottom, left;
  
  
  Block(float _x, float _y)
  {
    x = _x;
    y = _y;
    
   top     = new Segment(x, x + w, y, y);
   right   = new Segment(x + w, x + w, y, y + h);
   bottom  = new Segment(x, x + w, y + h, y + h);
   left    = new Segment(x, x, y, y + h);
    
  }
  
  void show()
  {
    fill(255);
    stroke(11);
    rect(x,y,w,h);
  }

}