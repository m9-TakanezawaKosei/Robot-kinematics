//アームの各パーツの長さ
float armL1 = 50;
float armL2 = 150;
float armL3 = 20;
float armL4 = 150;
float armL5 = 20;
float armL6 = 30;

//アームの位置
float x0;
float y0;
float z0;

//手先の初期位置
float x = 0;
float y = -armL4;
float z = armL1 + armL2 - armL6;
//関節角
float armRad1 = 0;
float armRad2 = 0;
float armRad3 = 0;
float armRad4 = 0;

float savedX;
float savedY;
float savedZ;

//オートかどうか
boolean isAuto = true;
//オートモード時で使用する時刻
float armT = 0;

//オートモード時の始点, 終点
//保存用にグローバル変数で保管
float armX0 = x;
float armY0 = y;
float armZ0 = z;
float armXf3;
float armYf3;
float armZf3;

//ボール, コンベヤオブジェクトに関する宣言
Ball ball;
int diameter = 15;
Conveyer[] conveyers = new Conveyer[3];

//左手系での視点の位置
float cameraX  = 1000/2;
float cameraY  = 0;
float cameraZ  = (800/2)/tan(PI/8);
float cameraX0 = 1000/2;
float cameraY0 = 0;
float cameraZ0 = (800/2)/tan(PI/8);

float mouseX0  = -1;
float mouseY0  = -1;
float mouseX1  = -1;
float mouseY1  = -1;
float cameraPitch = PI/2;
float cameraYaw = 0;

void setup(){
  frameRate(100);
  size(1000, 1000, P3D);
  ball = new Ball(#0000FF, #FFFF00, 0, -800, 0, diameter);
  conveyers[0] = new Conveyer(#FFFFFF, 0, -500,  diameter+5, 600, 10, 100, 0);
  conveyers[1] = new Conveyer(#FFFF00, 500*sin(-PI/3), 500*cos(-PI/3),  diameter+5, 600, 10, 100, -PI/3);
  conveyers[2] = new Conveyer(#0000FF, 500*sin(PI/3), 500*cos(PI/3),  diameter+5, 600, 10, 100, PI/3);
}

void mouseDragged(){
  mouseX1 = mouseX;
  mouseY1 = mouseY;
  if(mouseX0 == -1){
    mouseX0 = mouseX;
    mouseY0 = mouseY;
  }
  if(mouseX1 - mouseX0 > 0){
    cameraYaw -= PI/72;
  }else if(mouseX1 - mouseX0 < 0){
    cameraYaw += PI/72;
  }
  if(mouseY1 - mouseY0 > 0){
    cameraPitch -= PI/252;
    if(cameraPitch < 0){
      cameraPitch += PI/252;
    }
  }else if(mouseY1 - mouseY0 < 0){
    cameraPitch += PI/252;
    if(cameraPitch > PI){
      cameraPitch -= PI/252;
    }
  }
  
  cameraX = cameraX0 + cameraZ0 * sin(cameraPitch) * sin(cameraYaw);
  cameraY = cameraY0 - cameraZ0 * cos(cameraPitch);
  cameraZ = cameraZ0 * sin(cameraPitch) * cos(cameraYaw);
  mouseX0 = mouseX1;
  mouseY0 = mouseY1;
}

void keyTyped(){
  if(isAuto == true && (key == 'm' || key == 'M')){
    isAuto = false;
  }
  if(isAuto == false){
    if(key == 'a' || key == 'A'){
      isAuto = true;
      armT = 0;
    }else if(key == ' '){
      if(ball.getIsHeld() == true){
        ball.setIsHeld(false);
      }else if(pow(ball.getX() - x, 2) + pow(ball.getY() - y, 2) + pow(ball.getZ() - (30-z), 2) < 200){
        ball.setIsHeld(true);
      }
    }
  }
}

void draw(){
 
  //アームは常に画面の中心に配置
  x0 = 0;
  y0 = width/2;
  z0 = height/2;
  
  savedX = x;
  savedY = y;
  savedZ = z;
  
  if(isAuto == true){
    //オートモード時の処理
    //移動中に始点が変わってしまうためarmT=0の時以外は更新しない
    if(armT == 0){
      armX0 = x;
      armY0 = y;
      armZ0 = z;
    }
    float armXf0 = 0;
    float armYf0 = -armL4;
    float armZf0 = armL1 + armL2 - armL6;
    float armXf1 = ball.getX();
    float armYf1 = ball.getY();
    float armZf1 = ball.getZ() + 70;
    float armXf2 = ball.getX();
    float armYf2 = ball.getY();
    float armZf2 = ball.getZ() + 30;
    //移動中に始点が変わってしまうためarmT<4の時以外は更新しない
    if(armT < 4){
      armXf3 = ball.getX();
      armYf3 = ball.getY();
      armZf3 = ball.getZ() + 90;
    }
    float armXf4 = 0;
    float armYf4 = -armL4;
    float armZf4 = armL1 + armL2 - armL6;
    float armXf5 = armL4 * sin(PI/3);
    float armYf5 = armL4 * cos(PI/3);
    float armZf5 = armL1 + armL2 - armL6;
    float armXf6 = 250 * sin(PI/3);
    float armYf6 = 250 * cos(PI/3);
    float armZf6 = 70;
    float armXf7 = armL4 * sin(PI/3);
    float armYf7 = armL4 * cos(PI/3);
    float armZf7 = armL1+ armL2 - armL6;
    //ボール色によって行先を変更する
    if(ball.getBallColor() == #FFFF00){
      armXf5 = armL4 * sin(-PI/3);
      armYf5 = armL4 * cos(-PI/3);
      armXf6 = 250 * sin(-PI/3);
      armYf6 = 250 * cos(-PI/3);
      armXf7 = armL4 * sin(-PI/3);
      armYf7 = armL4 * cos(-PI/3);
    }
    if(armT < 1){
      x = armX0 + 10*(armXf0 - armX0)*pow(armT, 3) - 15*(armXf0 - armX0)*pow(armT, 4) + 6*(armXf0 - armX0)*pow(armT, 5);
      y = armY0 + 10*(armYf0 - armY0)*pow(armT, 3) - 15*(armYf0 - armY0)*pow(armT, 4) + 6*(armYf0 - armY0)*pow(armT, 5);
      z = armZ0 + 10*(armZf0 - armZ0)*pow(armT, 3) - 15*(armZf0 - armZ0)*pow(armT, 4) + 6*(armZf0 - armZ0)*pow(armT, 5);
    }else if(armT < 2){
      x = armXf0 + 10*(armXf1 - armXf0)*pow(armT - 1, 3) - 15*(armXf1 - armXf0)*pow(armT - 1, 4) + 6*(armXf1 - armXf0)*pow(armT - 1, 5);
      y = armYf0 + 10*(armYf1 - armYf0)*pow(armT - 1, 3) - 15*(armYf1 - armYf0)*pow(armT - 1, 4) + 6*(armYf1 - armYf0)*pow(armT - 1, 5);
      z = armZf0 + 10*(armZf1 - armZf0)*pow(armT - 1, 3) - 15*(armZf1 - armZf0)*pow(armT - 1, 4) + 6*(armZf1 - armZf0)*pow(armT - 1, 5);
      if(ball.getIsHeld() == true){
        armT = 5;
      }
      if(ball.getY() < -300 || ball.getY() > 100){
        armT = 1;
      }
    }else if(armT < 3){
      x = armXf1 + 10*(armXf2 - armXf1)*pow(armT - 2, 3) - 15*(armXf2 - armXf1)*pow(armT - 2, 4) + 6*(armXf2 - armXf1)*pow(armT - 2, 5);
      y = armYf1 + 10*(armYf2 - armYf1)*pow(armT - 2, 3) - 15*(armYf2 - armYf1)*pow(armT - 2, 4) + 6*(armYf2 - armYf1)*pow(armT - 2, 5);
      z = armZf1 + 10*(armZf2 - armZf1)*pow(armT - 2, 3) - 15*(armZf2 - armZf1)*pow(armT - 2, 4) + 6*(armZf2 - armZf1)*pow(armT - 2, 5);
    }else if(armT < 4){
      ball.setIsHeld(true);
      x = armXf2 + 10*(armXf3 - armXf2)*pow(armT - 3, 3) - 15*(armXf3 - armXf2)*pow(armT - 3, 4) + 6*(armXf3 - armXf2)*pow(armT - 3, 5);
      y = armYf2 + 10*(armYf3 - armYf2)*pow(armT - 3, 3) - 15*(armYf3 - armYf2)*pow(armT - 3, 4) + 6*(armYf3 - armYf2)*pow(armT - 3, 5);
      z = armZf2 + 10*(armZf3 - armZf2)*pow(armT - 3, 3) - 15*(armZf3 - armZf2)*pow(armT - 3, 4) + 6*(armZf3 - armZf2)*pow(armT - 3, 5);
    }else if(armT < 5){
      x = armXf3 + 10*(armXf4 - armXf3)*pow(armT - 4, 3) - 15*(armXf4 - armXf3)*pow(armT - 4, 4) + 6*(armXf4 - armXf3)*pow(armT - 4, 5);
      y = armYf3 + 10*(armYf4 - armYf3)*pow(armT - 4, 3) - 15*(armYf4 - armYf3)*pow(armT - 4, 4) + 6*(armYf4 - armYf3)*pow(armT - 4, 5);
      z = armZf3 + 10*(armZf4 - armZf3)*pow(armT - 4, 3) - 15*(armZf4 - armZf3)*pow(armT - 4, 4) + 6*(armZf4 - armZf3)*pow(armT - 4, 5);
    }else if(armT < 6){
      x = armXf4 + 10*(armXf5 - armXf4)*pow(armT - 5, 3) - 15*(armXf5 - armXf4)*pow(armT - 5, 4) + 6*(armXf5 - armXf4)*pow(armT - 5, 5);
      y = armYf4 + 10*(armYf5 - armYf4)*pow(armT - 5, 3) - 15*(armYf5 - armYf4)*pow(armT - 5, 4) + 6*(armYf5 - armYf4)*pow(armT - 5, 5);
      z = armZf4 + 10*(armZf5 - armZf4)*pow(armT - 5, 3) - 15*(armZf5 - armZf4)*pow(armT - 5, 4) + 6*(armZf5 - armZf4)*pow(armT - 5, 5);
    }else if(armT < 7){
      x = armXf5 + 10*(armXf6 - armXf5)*pow(armT - 6, 3) - 15*(armXf6 - armXf5)*pow(armT - 6, 4) + 6*(armXf6 - armXf5)*pow(armT - 6, 5);
      y = armYf5 + 10*(armYf6 - armYf5)*pow(armT - 6, 3) - 15*(armYf6 - armYf5)*pow(armT - 6, 4) + 6*(armYf6 - armYf5)*pow(armT - 6, 5);
      z = armZf5 + 10*(armZf6 - armZf5)*pow(armT - 6, 3) - 15*(armZf6 - armZf5)*pow(armT - 6, 4) + 6*(armZf6 - armZf5)*pow(armT - 6, 5);
    }else if(armT < 8){
      ball.setIsHeld(false);
      x = armXf6 + 10*(armXf7 - armXf6)*pow(armT - 7, 3) - 15*(armXf7 - armXf6)*pow(armT - 7, 4) + 6*(armXf7 - armXf6)*pow(armT - 7, 5);
      y = armYf6 + 10*(armYf7 - armYf6)*pow(armT - 7, 3) - 15*(armYf7 - armYf6)*pow(armT - 7, 4) + 6*(armYf7 - armYf6)*pow(armT - 7, 5);
      z = armZf6 + 10*(armZf7 - armZf6)*pow(armT - 7, 3) - 15*(armZf7 - armZf6)*pow(armT - 7, 4) + 6*(armZf7 - armZf6)*pow(armT - 7, 5);
    }else{
      //始点の更新
      armX0 = x;
      armY0 = y;
      armZ0 = z;
      //時刻の初期化
      armT = 0;
    }
    //時刻を進める
    armT += 0.01;
  }else{
    //マニュアルモード時の処理
    if (keyPressed){
      if(key == 'z' || key == 'Z'){
        z += 2;
      }else if(key == 'x' || key == 'X'){
        z -= 2;
      }else if(keyCode == UP){
        x += 2*sin(armRad1);
        y += 2*cos(armRad1);
      }else if((keyCode == DOWN)){
        x -= 2*sin(armRad1);
        y -= 2*cos(armRad1);
      }else if(keyCode == LEFT){
        float tmpX = x;
        x = x*cos(PI/100) -    y*sin(PI/100);
        y = y*cos(PI/100) + tmpX*sin(PI/100);
      }else if((keyCode == RIGHT)){
        float tmpX = x;
          x = x*cos(-PI/100) -    y*sin(-PI/100);
          y = y*cos(-PI/100) + tmpX*sin(-PI/100);
        }
    }
  }
  //ボールを持っているときの処理
  if(ball.getIsHeld() == true){
    ball.setX(x);
    ball.setY(y);
    ball.setZ(30-z); //アームのz座標はアームの掴み部の付け根なので補正をかける
  }
  
  //逆運動学による関節角の計算
  float C3 = (1 / (2 * armL2 * armL4)) * (pow(x, 2) + pow(y, 2) + pow(z - armL1 + armL6, 2)  - pow(armL2, 2) - pow(armL4, 2));
  float S3 = sqrt(1 - pow(C3, 2));
  float M = armL2 + C3 * armL4;
  float N = S3 * armL4;
  float A = sqrt(pow(x, 2) + pow(y, 2) - (armL3 - armL5));
  float B = z - armL1 + armL6;
  
  armRad1 = atan2(x, y) + asin((armL3 - armL5) / sqrt(pow(x, 2) + pow(y, 2)));
  armRad2 = atan2(M * A - N * B, N * A + M * B);
  armRad3 = atan2(S3, C3);
  armRad4 =  - (armRad2 + armRad3);

  if((sqrt(pow(x, 2) + pow(y, 2)) < 48 && z < 110) || (sqrt(pow(x, 2) + pow(y, 2)) < 1) || degrees(armRad2) > 60 || 
      Float.isNaN(armRad1) || Float.isNaN(armRad2) || Float.isNaN(armRad3) || Float.isNaN(armRad4) || 
      conveyers[0].checkIsConnected(x, y, z + 25, 25) || conveyers[1].checkIsConnected(x, y, z + 25, 25) || conveyers[2].checkIsConnected(x, y, z + 25, 25)){
    
    x = savedX;
    y = savedY;
    z = savedZ;
    C3 = (1 / (2 * armL2 * armL4)) * (pow(x, 2) + pow(y, 2) + pow(z - armL1+ armL6, 2) - pow(armL2, 2) - pow(armL4, 2));
    S3 = sqrt(1 - pow(C3, 2));
    M = armL2 + C3 * armL4;
    N = S3 * armL4;
  
    armRad1 = atan2(x, y);
    armRad2 = atan2(M * sqrt(pow(x, 2) + pow(y, 2)) - N * (z - armL1+ armL6), N * sqrt(pow(x, 2) + pow(y, 2)) + M * (z - armL1+ armL6));
    armRad3 = atan2(S3, C3);
    armRad4 =  - (armRad2 + armRad3);
  }

  armRad1 %= 2*PI;
  armRad2 %= 2*PI;
  armRad3 %= 2*PI;
  armRad4 %= 2*PI;
  
  
  background(0);
  noStroke();
  lights();
  camera(cameraX, cameraY, cameraZ, width/2, height/2, 0, 0, 1, 0);

  //ロボットアームの描画
  pushMatrix();
  translate(y0, z0, x0);
  
  rotateY(-armRad1);
  fill(255);
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 360; a += 10)  {
      float drawX = 30 * cos(radians(a));
      float drawY = 30 * sin(radians(a));
      vertex(drawY, 0, drawX);
      vertex(-drawY, 0, drawX);
    }  
  endShape();
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 360; a += 10)  {
      float drawX = 30 * cos(radians(a));
      float drawY = 30 * sin(radians(a));
      vertex(drawY, 0, drawX);
      vertex(drawY, -armL1, drawX);
    }  
  endShape();
  translate(0, -armL1, 0);
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 360; a += 10)  {
      float drawX = 30 * cos(radians(a));
      float drawY = 30 * sin(radians(a));
      vertex(drawY, 0, drawX);
      vertex(-drawY, 0, drawX);
    }  
  endShape();
  
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 180; a += 10)  {
      float drawY = 20 * cos(radians(a));
      float drawZ = 20 * sin(radians(a));
      vertex(drawY, -drawZ, 15);
      vertex(drawY, 0, 15);
    }  
  endShape();
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 180; a += 10)  {
      float drawY = 20 * cos(radians(a));
      float drawZ = 20 * sin(radians(a));
      vertex(drawY, -drawZ, -15);
      vertex(drawY, 0, -15);
    }  
  endShape();
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 180; a += 10)  {
      float drawY = 20 * cos(radians(a));
      float drawZ = 20 * sin(radians(a));
      vertex(drawY, -drawZ, 15);
      vertex(drawY, -drawZ, -15);
    }  
  endShape();
  
  rotateZ(armRad2);
  
  translate(0, -armL2/2, 0);
  fill(#FFFF00);
  box(20, armL2, 20);
  translate(0, -armL2/2, 0);

  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 180; a += 10)  {
      float drawY = 10 * cos(radians(a));
      float drawZ = 10 * sin(radians(a));
      vertex(drawY, -drawZ, 10);
      vertex(drawY, 0, 10);
    }  
  endShape();
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 180; a += 10)  {
      float drawY = 10 * cos(radians(a));
      float drawZ = 10 * sin(radians(a));
      vertex(drawY, -drawZ, -10);
      vertex(drawY, 0, -10);
    }  
  endShape();
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 180; a += 10)  {
      float drawY = 10 * cos(radians(a));
      float drawZ = 10 * sin(radians(a));
      vertex(drawY, -drawZ, 10);
      vertex(drawY, -drawZ, -10);
    }  
  endShape();
  
  rotateZ(armRad3);
  
  translate(0, 0, -armL3);
  
  fill(#00FF00);
  
  beginShape(QUAD_STRIP);
    for  (int a = 180; a <= 360; a += 10)  {
      float drawY = 10 * cos(radians(a));
      float drawZ = 10 * sin(radians(a));
      vertex(drawY, -drawZ, 10);
      vertex(drawY, 0, 10);
    }  
  endShape();
  beginShape(QUAD_STRIP);
    for  (int a = 180; a <= 360; a += 10)  {
      float drawY = 10 * cos(radians(a));
      float drawZ = 10 * sin(radians(a));
      vertex(drawY, -drawZ, -10);
      vertex(drawY, 0, -10);
    }  
  endShape();
  beginShape(QUAD_STRIP);
    for  (int a = 180; a <= 360; a += 10)  {
      float drawY = 10 * cos(radians(a));
      float drawZ = 10 * sin(radians(a));
      vertex(drawY, -drawZ, 10);
      vertex(drawY, -drawZ, -10);
    }  
  endShape();
  
  translate(0, -armL4/2, 0);
  fill(#00FF00);
  box(20, armL4, 20);
  translate(0, -armL4/2, 0);
  
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 180; a += 10)  {
      float drawY = 10 * cos(radians(a));
      float drawZ = 10 * sin(radians(a));
      vertex(drawY, -drawZ, 10);
      vertex(drawY, 0, 10);
    }  
  endShape();
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 180; a += 10)  {
      float drawY = 10 * cos(radians(a));
      float drawZ = 10 * sin(radians(a));
      vertex(drawY, -drawZ, -10);
      vertex(drawY, 0, -10);
    }  
  endShape();
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 180; a += 10)  {
      float drawY = 10 * cos(radians(a));
      float drawZ = 10 * sin(radians(a));
      vertex(drawY, -drawZ, 10);
      vertex(drawY, -drawZ, -10);
    }  
  endShape();
  
  translate(0, 0, armL5);
  
  rotateZ(armRad4);
  
  fill(#00FFFF);
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 180; a += 10)  {
      float drawY = 10 * cos(radians(a));
      float drawZ = 10 * sin(radians(a));
      vertex(drawY, -drawZ, 10);
      vertex(drawY, 0, 10);
    }  
  endShape();
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 180; a += 10)  {
      float drawY = 10 * cos(radians(a));
      float drawZ = 10 * sin(radians(a));
      vertex(drawY, -drawZ, -10);
      vertex(drawY, 0, -10);
    }  
  endShape();
  beginShape(QUAD_STRIP);
    for  (int a = 0; a <= 180; a += 10)  {
      float drawY = 10 * cos(radians(a));
      float drawZ = 10 * sin(radians(a));
      vertex(drawY, -drawZ, 10);
      vertex(drawY, -drawZ, -10);
    }  
  endShape();
  
  translate(0, armL6/2, 0);
  fill(#00FFFF);
  box(20, armL6, 20);
  translate(0, armL6/2, 0);
  
  if(isAuto == false){
    stroke(#FF0000, 80);
    line(0, 0, 0, 0, 1000, 0);
  }
  noStroke();
  
  fill(#FF0000);
  if(ball.isHeld == true){
    fill(#FF6400);
  }
  translate(0, 5, 0);
  box(50, 10, 20);
  translate(-20, 20, 0);
  box(10, 40, 20);
  translate(20 + 20, 0, 0);
  box(10, 40, 20);
  
  popMatrix();
  
  //ボールの描画
  pushMatrix();
  translate(width/2, height/2, 0);
  ball.display();
  popMatrix();

  //コンベヤの描画
  for(int i = 0; i < 3; ++i){
    pushMatrix();
    translate(width/2, height/2, 0);
    conveyers[i].display();
    //ボールがコンベヤ上に存在していたら座標をコンベヤに沿って進める
    if(conveyers[i].checkIsConnected(ball.getX(), ball.getY(), ball.getZ(), ball.getDiameter()) && ball.getIsHeld() == false){
      if(conveyers[0].checkIsEdge(ball.getX(), ball.getY(), ball.getZ(), ball.getDiameter()) == false){
        ball.move(6*sin(conveyers[i].getRad()), 6*cos(conveyers[i].getRad()), 0);
        ball.setZ(0);
      }
    //ボールがアームに掴まれておらず, どのコンベヤ上にも存在していなかったら落下させる
    }else{
      if(conveyers[(i+1) % 3].checkIsConnected(ball.getX(), ball.getY(), ball.getZ(), ball.getDiameter()) == false && conveyers[(i+2) % 3].checkIsConnected(ball.getX(), ball.getY(), ball.getZ(), ball.getDiameter()) == false){
        ball.fall();//落下する場合0.01sで3回実行される
      }
    }
    popMatrix();
  }
  
  //テキストメッセージの描画
  pushMatrix();
  textSize(24);
  fill(#FFFFFF);
  text("Drag mouse: Move the camera", 100, 40);
  if(isAuto == true){
    text("Press M: Manual mode", 100, 70);
  }else{
    text("Press A: Auto mode", 100, 70);
    text("Press Z or X: Raise or Lower the arm", 100, 100);
    text("Press ↑ or ↓: Move Forward or Backward the arm", 100, 130);
    text("Press ← or →: Rotate the arm", 100, 160);
    text("Press SPACE: Hold or Release a ball", 100, 190);
  }
  popMatrix();
}
