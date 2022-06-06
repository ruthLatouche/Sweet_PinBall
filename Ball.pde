class Ball {

  // We need to keep track of a Body and a radius
  Body body;
  float r, colores;
  color principal;
  boolean isAlive;
  
  boolean activarPortal1, activarPortal2;

  Ball(float x, float y, float r_) {
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x,y,r);
    body.setUserData(this);
    principal = generarColor();
    isAlive = true;
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
    isAlive = false;
  }

  // Is the particle ready for deletion?
  boolean done() {
    if (isAlive) {
      // Let's find the screen position of the particle
      Vec2 pos = box2d.getBodyPixelCoord(body);
      // Is it off the bottom of the screen?
      if (pos.y > height + 10) {
        killBody();
        return true;
      }
      
    }
    return false;
  }
  
  boolean isKilled() {
    return !isAlive;
  }

  // 
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
 
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(principal);
    stroke(#FFFFFF);
    strokeWeight(1);
    ellipse(0,0,r*2,r*2);
    // Let's add a line so we can see the rotation
    popMatrix();

  }
  

  color generarColor(){
    colores = round(random(1,5));
    color verde = #77A576;
    color rosa = #FF4D92;
    color amarillo =  #FFD53F;
    color azul = #20AEC3;
    color cyan = #00EAAA;
    
    if(colores == 1){
     return verde; 
    }
    else if(colores == 2){
     return rosa; 
    }
    else if(colores == 3){
     return amarillo; 
    }
    else if(colores == 4){
     return azul; 
    }
    else if(colores == 5){
     return cyan; 
    }
    
    return #000000;
  }
  
  void potenciaDisparo(float potencia){
    body.setLinearVelocity(new Vec2(0, potencia));
    body.setAngularVelocity(random(-10, 10));
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.03;
    fd.restitution = 0.9;
    
    // Attach fixture to body
    body.createFixture(fd);

    // Give it a random initial velocity (and angular velocity)
    body.setLinearVelocity(new Vec2(0, -100));
    body.setAngularVelocity(0);
  }
  
  void teletransportar1(){
   activarPortal1 = true; 
  }
  
  void teletransportar2(){
   activarPortal2 = true; 
  }
  
  
  boolean getActivarPortal1(){
   return activarPortal1; 
  }
  
  boolean getActivarPortal2(){
   return activarPortal2; 
  }
  
  void portal1(float _x, float _y){
   body.setTransform(box2d.coordPixelsToWorld(new Vec2(_x, _y)), 0);
   activarPortal1 = false;
  }
  
  void portal2(float _x, float _y){
   body.setTransform(box2d.coordPixelsToWorld(new Vec2(_x, _y)), 0);
   activarPortal2 = false;
  }






}
