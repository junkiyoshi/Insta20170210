class Particle
{
  PVector starting;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float radius;
  float max_force;
  float max_speed;
  float color_value;
  color body_color;
  
  Particle(float x, float y, float r)
  {
    location = new PVector(x, y);
    starting = location.copy();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    radius = r;
    max_force = 1;
    max_speed = 8;
    body_color = color(random(255), 255, 255);
  }
    
  void applyForce(PVector force)
  {
    acceleration.add(force);
  }
  
  void seek(PVector target)
  {
    PVector desired = PVector.sub(target, location);
    float distance = desired.mag();
    desired.normalize();
    if(distance < radius)
    {
      float m = map(distance, 0, radius, 0, max_speed);
      desired.mult(m);
    }else
    {   
      desired.mult(max_speed);
    }
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(max_force);
    applyForce(steer);
  }
  
  void seek_r(PVector target)
  {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(max_speed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(max_force * 5);
    steer.mult(-1);
    applyForce(steer);
  }
  
  void run()
  {
    update();
    display();
  }
  
  void update()
  {
    velocity.add(acceleration);
    velocity.limit(max_speed);
    location.add(velocity);
    acceleration.mult(0);
    velocity.mult(0.98);
  }
  
  void display()
  {
    fill(body_color);
    stroke(128);
    
    pushMatrix();
    translate(location.x, location.y);
    
    PVector distance = PVector.sub(starting, location);
    rotate(map(distance.mag(), 0, _power, 0, 360));
    
    beginShape();
    for(int i = 0; i < 360; i += 60)
    {
      float x = radius * cos(radians(i + 90));
      float y = radius * sin(radians(i + 90));
      vertex(x, y);
    }
    endShape(CLOSE);
    
    popMatrix();
  }
}