class PollutionParticle{
  //particles that display at the end 
  int positionX;
  int positionY;
  
  int velocityX;
  int velocityY;
  
  int size;
  color c;
  
  PollutionParticle(int positionX, int positionY, int size, color c){
    this.positionX = positionX;
    this.positionY = positionY;
    this.size = size;
    this.c = c;
    velocityY = (int)random(10)+5;
    velocityX = (int)random(9)-4;
  }//Initialize the particles and give them random speed
  
  void refresh(){
    this.positionY -= velocityY;
    this.positionX += velocityX;
    velocityY += (int)random(3)-1;
    velocityX += (int)random(3)-1;
    if(this.positionX >= width){
      this.positionX = 0;
    }else if(this.positionX < 0){
      this.positionY = width;
    }
  }//refresh the position of particle and change its speed slightly to makes the movement irregular


}
