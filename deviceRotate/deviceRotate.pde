PImage phone;
PImage laptop;
PImage pad;

int phoneStart = 0;
int laptopStart = 0;
int padStart = 0;
//The start position of each line

int phoneSpeed = 0;
int laptopSpeed = 0;
int padSpeed = 0;
//The speed of each line 

int maxSpeed = 30;
//The speed of phone in time at "speedup"

int speedup = 280;
int slowdown = 430;
int breakTime = 450;
/*
The rotation accelerates at the beginning
reaches its highest at "speed up"
and then slows down until "slowdown". 
the program stops running at "breakTime"
*/




float a;
float b;

void setup(){
  size(2400,3024);
  
  phone = loadImage("phone.png");
  laptop = loadImage("laptop.png");
  pad = loadImage("pad.png");
  //load all image from data
  
}

void draw(){
  background(255);
  image(pad, padStart, 0);
  image(pad, padStart-width,0);
  image(phone, phoneStart, pad.height);
  image(phone, phoneStart-width, pad.height);
  image(laptop, laptopStart, pad.height+laptop.height);
  image(laptop, laptopStart-width, pad.height+laptop.height);
  //display all image and makes them end to end
  
  phoneStart+=phoneSpeed;
  if(phoneStart>=width){
    phoneStart = 0;
  }
  laptopStart-=laptopSpeed;
  if(laptopStart<=0){
    laptopStart = width;
  }
  padStart-=padSpeed;
  if(padStart<=0){
    padStart = width;
  }
  //If the image move out of screen, let it come back in place
  
  saveFrame("../open/rotate####.png");
  if(frameCount <= speedup){
    phoneSpeed = maxSpeed*frameCount/speedup;
  }else if(frameCount <=slowdown){
    phoneSpeed = maxSpeed*(slowdown-frameCount)/(slowdown-speedup);
  }else if(frameCount == breakTime){
    saveFrame("../breakDevice/data/breakDevice.png");
    exit();
  }//save the final frame for breakDevice
   laptopSpeed = (int)1.2*phoneSpeed;
   padSpeed = (int)1.5*phoneSpeed;
   //adjust the speed according to time
   
}
