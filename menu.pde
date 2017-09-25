class Menu 
{

  Button hard;
  Button easy; 
  
  
  Menu()
  {
    hard = new Button(width / 2, height / 2 - 20 );
    easy = new Button(width / 2, height / 2 + 20);
  }
  
  
  void show()
  {
    noStroke();
    fill(0);
    rectMode(CORNER);
    rect(0,0, width, height /2);
    
    fill(255);
    rect(0, height / 2, width, height);
 
    hard.show("hard", true);
    easy.show("easy", false);
  }
}