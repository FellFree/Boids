Flock f;
PVector mouse;

void setup()
{
  size (640, 340);
  
  f = new Flock();
  
  for(int i = 0; i < 60; i++)
  {
    f.addBird(new Bird());
  }
}

void draw()
{
  mouse = new PVector(mouseX, mouseY);
  
  background(255);
  
  f.run();
}
