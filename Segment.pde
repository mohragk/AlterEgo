class Segment
{
  
  float x0, x1, y0, y1;
  PVector p0;
  PVector p1;
  
  Segment(float _x0, float _x1, float _y0, float _y1)
  {
     x0 = _x0;
     x1 = _x1;
     y0 = _y0;
     y1 = _y1;
     
     p0 = new PVector(x0, y0);
     p1 = new PVector(x1, y1);
  }
  
  
  boolean intersects(Ball b)
  {
    if (p0.y == p1.y)
    {
      if ( Math.abs(b.pos.y - p0.y) < b.r )
        return true;
    } else if (p0.x == p1.x )
    {
      if( Math.abs( b.pos.x - p0.x ) < b.r )
        return true;
    }   
    
    return false;
  }
}