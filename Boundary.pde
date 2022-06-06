class Boundary {

  float x;
  float y;
  float w;
  float h;
  float radio;
  
  Body b;
  
  SpriteSheet animacion;
  String id = "";
  int valor = 0;
  
  
  

  Boundary(float x_,float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    radio = 0;

    // Define the polygon
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
    b.setUserData(this);
    animacion = new SpriteSheet("Helado/", 24, "png");
  }
  
  // Constructor de CIRCULOS
    Boundary(float x_,float y_, float r_) {
    x = x_;
    y = y_;
    w = 0;
    h = 0;
    radio = r_;
    
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(radio);
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    b.createFixture(cs,1);
    b.setUserData(this);
    animacion = new SpriteSheet("Helado/", 24, "png");
  }
  
  void setCaracteristicas(String _id, int _valor){
   id = _id;
   valor = _valor;
   
   if(id.equals("grande"))
     animacion = new SpriteSheet("Helado/", 24, "png");
   if(id.equals("3Grande"))
     animacion = new SpriteSheet("3BolaGrande/",24, "png");
   if(id.equals("3Mediana"))
     animacion = new SpriteSheet("3BolaMediana/",24, "png");
   if(id.equals("3Pequeña"))
     animacion = new SpriteSheet("3BolaPequeño/",24, "png");
   if(id.equals("3Medio"))
     animacion = new SpriteSheet("3BolasEnMedio/",24, "png");
   if(id.equals("portal1"))
     animacion = new SpriteSheet("Portal1/", 8, "png");
   if(id.equals("portal2"))
     animacion = new SpriteSheet("Portal2/", 8, "png"); 
  }
  
  String getId(){
    return id;
  }
  
  int getValor(){
   return valor; 
  }
  
  void animar(){
   animacion.play(); 
  }

  
 

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    fill(#D01055);
    stroke(#D01055);
    if (radio == 0) {
      rectMode(CENTER);
      rect(x,y,w,h);
    }
    else if(radio != 0){
      pushMatrix();
      imageMode(CENTER);
      animacion.display(x,y); //<>//
      popMatrix();
    }
   
  }

}
