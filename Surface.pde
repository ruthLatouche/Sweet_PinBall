/*
Clase para construir superficies organicas

Esta clase posee varios constructores para estructuras distintas

*/
class Surface {

  ArrayList<Vec2> surface;
  
  String id = "";
  int valor = 0;

  //Constructor para construir arcos
  Surface(float _x, float _y, float _r, int _beginAngle, int _endAngle) {
    surface = new ArrayList<Vec2>();

    ChainShape chain = new ChainShape();

    for (float x = _beginAngle; x < _endAngle; x += 5) {
      float pX = _x + cos(radians(x))*_r;
      float pY = _y + sin(radians(x))*_r;
      surface.add(new Vec2(pX,pY));
    }

    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) {
      Vec2 edge = box2d.coordPixelsToWorld(surface.get(i));
      vertices[i] = edge;
    }
    
    chain.createChain(vertices,vertices.length);

    BodyDef bd = new BodyDef();
    bd.position.set(0.0f,0.0f);
    Body body = box2d.createBody(bd);
    body.createFixture(chain,1);
    body.setUserData(this);
  }
  
  //Constructor para hacer arcos con formas de ovalo
  Surface(float _x, float _y, float _w, float _h, int _beginAngle, int _endAngle) {

    surface = new ArrayList<Vec2>();

    ChainShape chain = new ChainShape();

    for (float x = _beginAngle; x < _endAngle; x += 5) {
      float pX = _x + cos(radians(x))*_w;
      float pY = _y + sin(radians(x))*_h;
      surface.add(new Vec2(pX,pY));
    }

    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) {
      Vec2 edge = box2d.coordPixelsToWorld(surface.get(i));
      vertices[i] = edge;
    }
    
    chain.createChain(vertices,vertices.length);

    BodyDef bd = new BodyDef();
    bd.position.set(0.0f,0.0f);
    Body body = box2d.createBody(bd);
    body.createFixture(chain,1);
    body.setUserData(this);  
  }
  
  //Constructor para crear una superficie irregular
  Surface(float _altura) {
    surface = new ArrayList<Vec2>(); 
    float alturaDePaisaje = _altura;
    
    // primer punto de la lista
    surface.add (new Vec2(0, alturaDePaisaje));
    int pointCount = 20;
    for (int i = 0; i < pointCount; i++) {
      surface.add(new Vec2(i*width/pointCount + random(width/pointCount), alturaDePaisaje + random(50) ));
    }
    
    surface.add(new Vec2(width, alturaDePaisaje)); // last point

    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = box2d.coordPixelsToWorld(surface.get(i));
    }
    
    BodyDef bd = new BodyDef();
    Body body = box2d.world.createBody(bd);

    ChainShape chain = new ChainShape();
    chain.createChain(vertices, vertices.length); // making the chain object with "vertices array"

    body.createFixture(chain, 1);
    body.setUserData(this);
  }
  
  //Una superficie totalmente personalizada
  Surface(ArrayList<Vec2> _puntos) {
    surface = _puntos; //new ArrayList<Vec2>(); 
    //println(_puntos.size());
    
    ChainShape chain = new ChainShape();

    Vec2[] vertices = new Vec2[_puntos.size()];
    for (int i = 0; i < vertices.length; i++) {
      println(_puntos.get(i));
      Vec2 edge = box2d.coordPixelsToWorld(_puntos.get(i));
      vertices[i] = edge;
    }
    
    chain.createChain(vertices,vertices.length);

    BodyDef bd = new BodyDef();
    bd.position.set(0.0f,0.0f);
    Body body = box2d.createBody(bd);
    body.createFixture(chain,1);
    body.setUserData(this);
  }
  
  void setCaracteristicas(String _id, int _valor){
   id = _id;
   valor = _valor;
  }
  
  String getId(){
    return id;
  }
  
  int getValor(){
   return valor; 
  }
  
  void display() {
    strokeWeight(5);
    stroke(#D01055);
    noFill();
    beginShape();
    for (Vec2 v: surface) {
      vertex(v.x,v.y);
    }
    endShape();
  }
  

}
