class Button
{
  float x;
  float y;
  
  float w = 160;
  float h = 30;
  

  
  Button(float _x, float _y)
  {
    x = _x;
    y = _y;
  }
  
  boolean buttonHit()
  {
    if (mouseX > x - w / 2 && mouseX < x + w / 2 )
      if(mouseY < y + h / 2 && mouseY > y - h / 2)
          return true;
          
    return false;
  }
  
  void show(String label, boolean inverse)
  {
    
    
    
    
    if (inverse)
      fill(255);
    else
      fill(0);
    
    if (buttonHit())
      fill(122);
      
      textFont(futura20);
      textAlign(CENTER,CENTER);
      text(label, x, y);
  }
}