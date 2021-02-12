class Ball{
  //ボールの直径
  int diameter;
  //ボールの色（2色）
  color ballColor;
  color subBallColor;
  //ボールの座標
  float x;
  float y;
  float z;
  //ボールの初期座標
  float x0;
  float y0;
  float z0;
  

  float dtFall = 0.01;//ボールの落下時の時刻
  float vFall  = 0;   //ボールの落下速度
  float g = 9.8 * 50;//重力加速度

  //掴まれているかどうか
  boolean isHeld = false;
  
  Ball(color tempBallColor, color tempSubBallColor, float tempX, float tempY, float tempZ, int tempDiameter){
    ballColor = tempBallColor;
    subBallColor = tempSubBallColor;
    x = tempX;
    y = tempY;
    z = tempZ;
    x0 = tempX;
    y0 = tempY;
    z0 = tempZ;
    diameter = tempDiameter;
  }
  
  void move(float dx, float dy, float dz){
    x += dx;
    y += dy;
    z -= dz;
    vFall = 0;
  }
  
  void fall(){
    //落下速度の更新
    vFall += g * dtFall;
    //落下変位の更新
    z += vFall * dtFall;
    //z>500でプログラム開始時の地点に行く
    if(z > 500){
      x = x0;
      y = y0;
      z = z0;
      if(int(random(2)) == 1){
        color tempColor = ballColor;
        ballColor = subBallColor;
        subBallColor = tempColor;
      }
    }
    
  }
  
  void display(){
    pushMatrix();
    translate(y, z, x);
    fill(ballColor);
    sphere(diameter);
    popMatrix();
  }
  
  void setIsHeld(boolean tureOrFalse){
    isHeld = tureOrFalse;
  }
  void setX(float tempX){
    x = tempX;
    vFall = 0;
  }
  void setY(float tempY){
    y = tempY;
    vFall = 0;
  }
  void setZ(float tempZ){
    z = tempZ;
    vFall = 0;
  }

  boolean getIsHeld(){
    return isHeld;
  }
  float getX(){
    return x;
  }
  float getY(){
    return y;
  }
  float getZ(){
    return z;
  }
  int getDiameter(){
    return diameter;
  }
  color getBallColor(){
    return ballColor;
  }
}
