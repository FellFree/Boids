// Bird - object with behavior
// Marcin Czerwiński

class Bird
{
  PVector position;  // position of Walker
  PVector velocity; // velocity of Walker
  PVector acceleration; // acceleration of Walker

  PVector desire; // target vector
  PVector steer; // apply this force to make more natural action

  PVector separation; // PVector for mean separation
  PVector cohesion; // PVector for mean cohesion
  PVector align; // PVector for mean align

  float size; // size of Walker
  float maxSpeed; // maximum speed of Walker
  float maxForce; // maximym force that can act upon Walker

  float minDistanceFromOther; // minimum distance that two Birds can get close
  float maxDistanceFromOther; // maximum distance thath two Birds can from each other
  float vision; // how far bird can see
  float visionAngle; // angle of with bird can see

  color colour;

  // Constructor
  Bird()
  {
    maxForce = 0.01;
    maxSpeed = 3;
    
    vision = 50;
    visionAngle = PI/4;

    size = 8;
    colour = 172;

    minDistanceFromOther = size*2;
    maxDistanceFromOther = size*20;

    position = new PVector(random(width), random(height));
    velocity = new PVector(random(-maxSpeed, maxSpeed), random(-maxSpeed, maxSpeed));

    acceleration = new PVector(0, 0);
    separation = new PVector(0, 0);
    cohesion = new PVector(0, 0);
    align = new PVector(0, 0);
  }

  // for adding and having control over all behaviors
  void addBehaviors(ArrayList<Bird> others)
  {
    separation = separation(others);
    cohesion = cohesion(others);
    align = align(others);

    align.mult(1.1);
    separation.mult(1.5);
    cohesion.mult(0.7);

    applyForce(align);
    applyForce(separation);
    applyForce(cohesion);
  }

  // for heading in one direction;
  PVector align(ArrayList<Bird> other)
  {
    PVector sum = new PVector();
    float count = 0;

    for (Bird o : other)
    {
      float angle = PVector.angleBetween(position, o.position);
      
      if (PVector.dist(position, o.position) < vision && angle < visionAngle)
      {
        sum.add(o.velocity);
        count++;
      }
    }

    if (count > 0)
    {
      sum.div(count);
      sum.setMag(maxSpeed);

      steer = PVector.sub(sum, velocity);

      return steer;
    }else return new PVector(0, 0);
  }

  // for not getting to far from each other
  PVector cohesion(ArrayList<Bird> other)
  {
    PVector sum = new PVector();
    int count = 0;
    float dist;

    for (Bird o : other)
    {
      dist = PVector.dist(position, o.position);
      float angle = PVector.angleBetween(position, o.position);

      if (dist > maxDistanceFromOther && dist < vision && angle < visionAngle)
      {
        sum.add(PVector.sub(o.position, position));
        sum.normalize();
        sum.div(dist);
        count++;
      }
    }

    if (count > 0)
    {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);
      steer = PVector.sub(sum, velocity);
      return steer;
    } else return new PVector(0, 0);
  }

  // for not overlaping
  PVector separation(ArrayList<Bird> other)
  {
    PVector sum = new PVector();
    int count = 0;
    float dist;

    for (Bird o : other)
    {
      dist = PVector.dist(this.position, o.position);
      
      if ((dist > 0) && (dist < minDistanceFromOther) && dist < vision)
      {
        sum.add(PVector.sub(position, o.position).normalize().div(dist));
        count++;
      }
    }

    if (count > 0)
    {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);
      steer = PVector.sub(sum, velocity);
      return steer;
    } else return new PVector(0, 0);
  }

  // act on the Walker
  void applyForce(PVector force)
  {
    force.mult(maxForce);
    acceleration.add(force);
  }

  // update the position of Walker 
  void update()
  {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);

    acceleration.mult(0);
  }

  //Scrolling Walkers beyond the screen
  void edges()
  {
    if (position.x + size/2 < 0) position.x = width + size/2;
    if (position.x - size/2 > width) position.x = 0 - size/2;
    if (position.y + size/2 < 0) position.y = height + size/2;
    if (position.y - size/2 > height) position.y = 0 - size/2;
  }

  // draw circle
  void drawCircle(PVector pos, float s, color col)
  {
    stroke(1);
    strokeWeight(1);
    fill(col);
    ellipse(pos.x, pos.y, s, s);
  }

  // display Walker
  void display()
  {
    update();
    edges(); 
    drawCircle(position, size, colour);
  }
  
  // main loop
  void run(ArrayList<Bird> other)
  {
    display();
    addBehaviors(other);
  }
}
