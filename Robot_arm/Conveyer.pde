class Conveyer{
  color conveyerColor;
  //コンベヤの座標
  float x;
  float y;
  float z;
  //コンベヤの幅, 厚さ, 長さ, 回転角度
  float l;
  float t;
  float w;
  float rad;
  
  Conveyer(color tempConveyerColor,float tempX, float tempY, float tempZ, float tempL, float tempT, float tempW, float tempRad){
    conveyerColor = tempConveyerColor;
    x = tempX;
    y = tempY;
    z = tempZ;
    l = tempL;
    t = tempT;
    w = tempW;
    rad = tempRad;
  }
  
  //コンベヤと接触しているかどうか
  boolean checkIsConnected(float checkX, float checkY, float checkZ, int size){
    float r = sqrt(pow(checkX - x, 2) + pow(checkY - y, 2));
    float theta = atan2(checkY - y, checkX - x);
    if((-(w / 2) <= r * cos(rad + theta) + (size) && r * cos(rad + theta) - (size) <= (w / 2)) && 
       (-(l / 2) <= r * sin(rad + theta) + (size) && r * sin(rad + theta) - (size) <= (l / 2)) && 
       (abs(checkZ - z) <= size + t / 2)){
      return true;
    }else{
      return false;
    }
  }
  
  //コンベヤの端に位置しているかどうか
  boolean checkIsEdge(float checkX, float checkY, float checkZ, int size){
    float r = sqrt(pow(checkX - x, 2) + pow(checkY - y, 2));
    float theta = atan2(checkY - y, checkX - x);
    if(checkIsConnected(checkX, checkY, checkZ, size) && (l / 2) - 2*size <= r * sin(rad + theta) - (size)){
      return true;
    }else{
      return false;
    }
  }
  
  void display(){
    pushMatrix();
    translate(y, z, x);
    rotateY(-rad);
    fill(conveyerColor);
    box(l, t, w);
    popMatrix();
  }

  float getRad(){
    return rad;
  }
}
