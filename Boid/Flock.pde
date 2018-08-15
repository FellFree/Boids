// For hiding unnecesary thins from main file. Manage entire list of Birds
// Marcin Czerwiński

class Flock
{
  ArrayList<Bird> birds;

  Flock()
  {
    birds = new ArrayList<Bird>();
  }

  void addBird(Bird b)
  {
    birds.add(b);
  }

  void run()
  {
    for (Bird b : birds)
    {
      b.run(birds);
    }
  }
}
