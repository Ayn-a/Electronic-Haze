import fisica.*;

FWorld world;
FWorld pWorld;

PImage device;

int backgroundColor = 255;

ArrayList <Particle> particles;
ArrayList <PollutionParticle> pollutionParticles;
int reduceSize;

int count = 0;
int breakEnd = 0;
int polluteTime = 400;
int darkTime = 500;


void setup() {
  size(2400,3024);
  background(255);
  
  device = loadImage("breakDevice.png");
  
  Fisica.init(this);
  world = new FWorld();
  world.setEdges(color(255,255,255));
  world.remove(world.top);
  world.setGravity(0, 400);
  world.setEdgesRestitution(0);
  //initialize the fisica world
  
  reduceSize = width/48;
  breakEnd = reduceSize*2;
  particles = new ArrayList();
  pollutionParticles = new ArrayList();
}

void draw() {
  if(count == 0){
    image(device, 0, 0);
    debrisInitialize();
  }//create all device debris (geometric objects)
  else if(count < breakEnd){
    debrisBecomeLage();
  }//makes geometric objects bigger
  else if(count < polluteTime){
    debrisFalls();
  }//let geometric objects fall
  else if(count <= darkTime){
      //world.setGravity(0, 0);
      background(backgroundColor);
      world.draw();
      pollution();
  }//the geometric objects break down into small particles
  else{
      background(backgroundColor);
      world.draw();
      dark();
      pollution();
  }
  count++;
  
  saveFrame("../end/image####.png");

}


void debrisInitialize(){
  loadPixels();
  
  for(int i = 0; i < pixels.length;i++){
    if(i%2017==0 && pixels[i]!= color(255, 255, 255)){
       int type = (int)random(3);
       //FBody debris;
       if(type == 0){
          FCircle debris = new FCircle(random(width/48)+width/48);
          debris.setPosition(i%width, i/width);
          debris.setNoStroke();
          debris.setFill(red(pixels[i]), green(pixels[i]), blue(pixels[i]));
          debris.setVelocity(random(200)-100,random(200)-100);
          world.add(debris);
          
          Particle particle = new Particle((int)debris.getX(), (int)debris.getY(), (int)debris.getSize(),pixels[i], type);
          particles.add(particle);
       }else if(type == 1){
          FBox debris = new FBox(random(width/48)+width/48, random(width/48)+width/48);
          debris.setPosition(i%width, i/width);
          debris.setNoStroke();
          debris.setFill(red(pixels[i]), green(pixels[i]), blue(pixels[i]));
          debris.setVelocity(random(width)-width/2,random(width)-width/2);
          world.add(debris);
          
          Particle particle = new Particle((int)debris.getX(), (int)debris.getY(), (int)debris.getHeight(),pixels[i], type);
          particles.add(particle);
       }else{
          FPoly debris = new FPoly();
          debris.vertex(width/48, width/48);
          debris.vertex(-width/48, width/48);
          debris.vertex(0, -width/48);
          debris.setPosition(i%width, i/width);
          debris.setNoStroke();
          debris.setFill(red(pixels[i]), green(pixels[i]), blue(pixels[i]));
          debris.setVelocity(random(200)-100,random(200)-100);
          world.add(debris);
          
          Particle particle = new Particle((int)debris.getX(), (int)debris.getY(), width/48,pixels[i], type);
          particles.add(particle);
       }//create 3 types of particles randomly

    }
  }
}

void debrisBecomeLage(){
  for(int i = 0; i<particles.size();i++){
    Particle particle = particles.get(i);
    if(particle.type==0){
       noStroke();
       int a = particle.size*(width/48-reduceSize)/(width/48);
       fill(red(particle.c), green(particle.c), blue(particle.c)); 
       ellipse(particle.positionX, particle.positionY, a, a);
    }else if(particle.type == 1){
        noStroke();
       int a = particle.size*(width/48-reduceSize)/(width/48);
       fill(red(particle.c), green(particle.c), blue(particle.c)); 
       rect(particle.positionX-a/2, particle.positionY-a/2, a, a);
    }else{
      noStroke();
      fill(red(particle.c), green(particle.c), blue(particle.c));
      int a = width/48-reduceSize;
      triangle(particle.positionX+a, particle.positionY+a, particle.positionX-a, particle.positionY+a, particle.positionX, particle.positionY-a);
    }
  }
  
  if(count%2==0){
    reduceSize--;
  }
}

void debrisFalls(){
  background(255);
  world.step();
  world.draw();
}//make the geometric objects move according to the 2D physical principles

void pollution(){
  ArrayList<? extends FBody> bodies = world.getBodies();
  if(bodies.size()>0){
    FBody body = bodies.get(bodies.size()-1);
    world.remove(body);
    for(int j = 0; j < 10; j++){
      PollutionParticle smallBody = new PollutionParticle(int(body.getX()+random(width/100)), int(body.getY()+random(width/100)),int(random(width/100)+width/100),body.getFillColor());
      pollutionParticles.add(smallBody);
    }  
  }//when there are remaining geometric objects, remove one from screen and create 10 small particles
 
    for(PollutionParticle p: pollutionParticles){
    p.refresh();
    noStroke();
    fill(p.c); 
    ellipse(p.positionX, p.positionY, p.size, p.size);
  }
}

void dark(){
  if(count%3==0){
    backgroundColor--;
  }
  if(backgroundColor==0){
    exit();
  }
}//adjust the color of background and stop this program when the background is black
