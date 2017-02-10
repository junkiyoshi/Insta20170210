import de.voidplus.leapmotion.*;
LeapMotion leap;

ArrayList<Particle> particles;
float _power = 150;

void setup()
{
  size(512, 512);
  frameRate(30);
  colorMode(HSB);
  blendMode(ADD);

  leap = new LeapMotion(this);
  
  particles = new ArrayList<Particle>();

  float size = 10;
  boolean flg = false;

  for(int y = height / -5; y < height * 1.2; y += size + (size * sqrt(2) / 2))
  {
    for(int x = width / -5; x < width * 1.2; x += size * sqrt(3))
    {
      if(flg)
      {
        particles.add(new Particle(x, y, size));
      }
      else
      {
        particles.add(new Particle(x + (size * sqrt(3) / 2), y, size));
      }
    }
    flg = !flg;
  }
  
}

void draw()
{
  background(0);
    
  PVector point = new PVector(0, 0);
  for(Hand h : leap.getHands())
  {
    Finger f = h.getIndexFinger();
    point = new PVector(f.getPosition().x, f.getPosition().y);
      
    _power = f.getPosition().z * 2;
    
    noStroke();
    fill(255);
    ellipse(point.x, point.y, _power / 5, _power / 5);
    break;
  }
  
  for(Particle p : particles)
  {
    if(point.x != 0 && point.y != 0)
    {
      PVector distance = PVector.sub(point, p.location);
      if(distance.mag() <= _power)
      {
        p.seek_r(point);
      }else
      {
        p.seek(p.starting);
      }
    }else
    {
      p.seek(p.starting);
    }
      
    p.run();
  }
  
  /*
  println(frameCount);
  saveFrame("screen-#####.png");
  if(frameCount > 900)
  {
     exit();
  }
  */
}