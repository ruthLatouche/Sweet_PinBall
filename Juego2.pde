//Ruth Latouche e Isora Hernández 
//2019027049 y 2019205139

//Importacion de bibliotecas y musica
import ddf.minim.*;
Minim minim;
AudioPlayer musicaPortada, musicaJuego, musicaFin; 
AudioSample choque, lanzamiento, portales, flippers;

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// A reference to our box2d world
Box2DProcessing box2d;

//Fondo
int escenario;

//Componentes graficos de escenarios
PImage dibujosfondo, fondoJuego, fondoFin;
PFont fuente1, fuente2, fuente3;

ArrayList<Boundary> paredes;
ArrayList<Boundary> circulos;
Surface arcoEli, arcoSolo, arcoLinea, arcoSup, arcoInf, arcoEsqSup, triangulo, estrella, esquinaSup, esquinaDer, esquinaIzq, lineaSuperior, lineaInferior;

ArrayList<Ball> bolitas;

ArrayList<Windmill> molinos;

int puntaje;

//Potencia de disparo
long keyDown, keyUp;
boolean disparando;
float potencia;

//Fin de escenario 3
long actualizacion;
int tiempo;

//Para los flippers
boolean lflip;
boolean rflip;
boolean tflip;
boolean fflip;

Flipper fl;
Flipper fr;


void setup(){
  size (425, 800);
  
  // Turn on collision listening!
 // box2d.listenForCollisions();
  
  escenario = 1;
  dibujosfondo = loadImage("DulcesPortada.png"); 
  fondoJuego = loadImage("FondoJuego.png");
  fondoFin = loadImage("FondoGameOver.png");
  puntaje = 0;
  
  //Fin de escenario 3
  tiempo = 5000;
  
  minim = new Minim(this);
  musicaPortada = minim.loadFile("cancionportada.mp3");
  musicaJuego = minim.loadFile("musicadeljuego.mp3");
  musicaFin = minim.loadFile("musicaGameOver.mp3");
  choque = minim.loadSample("Golpear.mp3");
  lanzamiento = minim.loadSample("Lanzar.mp3");
  portales = minim.loadSample("Portales.mp3");
  flippers = minim.loadSample("Flippers.mp3");

  musicaPortada.play(); 
  musicaPortada.loop(); 
  
  fuente1 = createFont("No Virus.ttf", 65);
  fuente2 = createFont("Quicksand_Bold.otf", 30);
  fuente3 = createFont("Quicksand_Bold.otf", 15);
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  //Flippers
  fr = new Flipper(300, 760, 25, -QUARTER_PI/2 -radians(2), QUARTER_PI, false, 7, 5, 75);
  fl = new Flipper(90, 760, 25, -QUARTER_PI/2 - radians(20), QUARTER_PI - radians(20), true, 7, 5, 75); //have no idea why they don't match up but this works
  rflip = false;
  fflip = false;
  lflip = false;
  tflip = false;
  
  // Turn on collision listening!
  box2d.listenForCollisions();
  
  paredes = new ArrayList<Boundary>();
  circulos = new ArrayList<Boundary>();
  
  bolitas = new ArrayList<Ball>();
  
  molinos = new ArrayList<Windmill>();
  molinos.add(new Windmill( 212.5,234.675, 65 ));
  molinos.add(new Windmill(357 , 63, 96));
  molinos.add(new Windmill(111.9 , 534.6, 100 ));
  molinos.add(new Windmill(310 , 670, 75)); //<>//
  
  paredes.add(new Boundary(350.5,height-2.5,147,5));
  paredes.add(new Boundary(width/2, 2.5,width,5));
  paredes.add(new Boundary(width-2.5,height/2,5,height));
  paredes.add(new Boundary(2.5,height/2,5,height));
  paredes.add(new Boundary(57, height-2.5, 118, 5));
  paredes.add(new Boundary(width * 9.2/10, height* 2/3, 5 , height * 2/3));
  paredes.add(new Boundary(285.9, 615.53, 38, 4));
  
  Boundary cirUp1 = new Boundary(127.47, 75.19, 25);
  cirUp1.setCaracteristicas("3Grande" , 200);
  circulos.add(cirUp1);
  
  Boundary cirUp2 = new Boundary(77.33, 120.94, 15.5);
  cirUp2.setCaracteristicas("3Mediana" , 200);
  circulos.add(cirUp2);
  
  Boundary cirUp3 = new Boundary(54.96, 170.85, 12.5);
  cirUp3.setCaracteristicas("3Pequeña" , 200);
  circulos.add(cirUp3);
 
  Boundary cirCentro1 = new Boundary(148.33, 390.17, 10);
  cirCentro1.setCaracteristicas("3Medio" , 100);
  circulos.add(cirCentro1);
  
  Boundary cirCentro2 = new Boundary(204.19, 390.17, 10);
  cirCentro2.setCaracteristicas("3Medio" , 100);
  circulos.add(cirCentro2);
  
  Boundary cirCentro3 = new Boundary(257.77, 390.17, 10);
  cirCentro3.setCaracteristicas("3Medio" , 100);
  circulos.add(cirCentro3);
  
  Boundary cirDown = new Boundary(79.81, 635.05, 42.5);
  cirDown.setCaracteristicas("grande" , 100);
  circulos.add(cirDown);
  
  Boundary portal1 = new Boundary(134.5, 153.5, 7.5);
  portal1.setCaracteristicas("portal1" , 0);
  circulos.add(portal1); 
  
  Boundary portal2 = new Boundary(188.5, 36.5, 7.5);
  portal2.setCaracteristicas("portal2" , 0);
  circulos.add(portal2);
  

  
  arcoEli = new Surface(245.69, 253.73, 176.69, 159.73, 180, 270);
  arcoSolo = new Surface(313.93, 506.3, 52.23, 0, 90);
  arcoLinea = new Surface(274, 680, 65, 180, 270);
  arcoSup = new Surface(213, 234, 81, 205, 337);
  arcoInf = new Surface(213, 234, 81, 25, 157);
  arcoEsqSup = new Surface(366.7, 56.5, 56.5, 270, 360);
  
  ArrayList<Vec2> puntosTri = new ArrayList<Vec2>();
  puntosTri.add(new Vec2(111.9, 388.31));
  puntosTri.add(new Vec2(40.13, 319.38));
  puntosTri.add(new Vec2(40.13, 460.09));
  puntosTri.add(new Vec2(111.9, 388.31));
  triangulo = new Surface(puntosTri);
  
  ArrayList<Vec2> puntosStar = new ArrayList<Vec2>();
  puntosStar.add(new Vec2(213.76, 442.3));
  puntosStar.add(new Vec2(229.64, 474.49));
  puntosStar.add(new Vec2(265.16, 479.66));
  puntosStar.add(new Vec2(239.45, 504.71));
  puntosStar.add(new Vec2(245.53, 540.09));
  puntosStar.add(new Vec2(213.76, 523.38));
  puntosStar.add(new Vec2(181.98, 540.09));
  puntosStar.add(new Vec2(188.05, 504.71));
  puntosStar.add(new Vec2(162.34, 479.66));
  puntosStar.add(new Vec2(197.87, 474.49));
  puntosStar.add(new Vec2(213.76, 442.3));
  estrella = new Surface(puntosStar);
  
  ArrayList<Vec2> puntosSup = new ArrayList<Vec2>();
  puntosSup.add(new Vec2(1.28, 95.17));
  puntosSup.add(new Vec2(96.45, 0));
  esquinaSup = new Surface(puntosSup);
  
  ArrayList<Vec2> puntosDer = new ArrayList<Vec2>();
  puntosDer.add(new Vec2(392.78, 684.31));
  puntosDer.add(new Vec2(278.82, 799.27));
  esquinaDer = new Surface(puntosDer);
  
  ArrayList<Vec2> puntosIzq = new ArrayList<Vec2>();
  puntosIzq.add(new Vec2(0, 684.31));
  puntosIzq.add(new Vec2(115.96, 799.27));
  esquinaIzq = new Surface(puntosIzq);
  
  ArrayList<Vec2> lineaSup = new ArrayList<Vec2>();
  lineaSup.add(new Vec2(139.12, 200.16));
  lineaSup.add(new Vec2(286.11, 200.16));
  lineaSuperior = new Surface(lineaSup);
  
  ArrayList<Vec2> lineaInf = new ArrayList<Vec2>();
  lineaInf.add(new Vec2(139.12, 267.9));
  lineaInf.add(new Vec2(286.11, 267.9));
  lineaInferior = new Surface(lineaInf);

}

void draw(){
  if(escenario ==1){
   portada();
  }
  else if(escenario == 2){ 
    pinball();
  }
  
  else if( escenario == 3){
   gameOver(); 
  }
  
  println(escenario);
}

void portada(){
 background(#FAE1E6);
 imageMode(CENTER);
 image (dibujosfondo, width/2, height*4/5);

 textFont(fuente1);
 fill(#F6FAC7);
 textAlign(CENTER);
 text("Sweet Pinball", width/2, height*2.9/10);
 textFont(fuente1);
 fill(#7FDBE6);
 textAlign(CENTER);
 text("Sweet Pinball", width/2, height*6/21);
 
 textFont(fuente2);
 fill(#64B3B1);
 text("Press S to start", width/2, height/2);
 
}


void playPortada(){
  musicaJuego.pause();
  musicaFin.pause();
  musicaPortada.play(); 
  musicaPortada.loop();
}

void playJuego(){
 musicaJuego.play();
 musicaPortada.pause();
 musicaFin.pause(); 
 musicaJuego.loop();
}

void playGameOver(){
  musicaJuego.pause();
  musicaPortada.pause();
  musicaFin.play(); 
  musicaFin.loop();
}

void gameOver(){
    pushMatrix();
    background(255);
    imageMode(CENTER);
    image(fondoFin, width/2, height/2);
  
    textFont(fuente2);
    fill(#FFFFFF);
    textAlign(CENTER);
    text("Puntaje obtenido", 212, 390);
    text(puntaje, 212, 423);
    popMatrix();
  if (millis() - actualizacion > tiempo){
  escenario = 1;
  playPortada();
  } 
}

void pinball(){
 background(255);
 pushMatrix();
 imageMode(CENTER);
 image(fondoJuego, width/2, height/2);
 popMatrix();
 
 pushMatrix();
 fill(#D01055);
 noStroke();
 triangle(0,0, 1.28, 95.17, 96.45, 0);
 triangle(0,height, 0, 684.31, 115.96, height);
 triangle(393.78 ,height, 393.78, 684.31, 278.82, height);
 beginShape();
 vertex(width, 0);
 vertex(387, 0);
 vertex(408,15.5);
 vertex(width, 40);
 endShape();
 popMatrix();
 
  fr.display();
  fl.display(); 
  
  rflip = true;
  lflip = true;
  tflip = true;
  fflip = true;
 
 box2d.step();
 for (Boundary pared : paredes) {
   pared.display();
  }
 for (Boundary circulo : circulos){
  circulo.display(); 
 }
 arcoEli.display();
 arcoSolo.display();
 arcoLinea.display();
 arcoEsqSup.display();
 esquinaSup.display();
 esquinaDer.display();
 esquinaIzq.display();
 
 for(int x=0; x<bolitas.size(); x++){
   Ball bola = bolitas.get(x);
   bola.display();
   if(bola.getActivarPortal1())
     bola.portal1(18.5 ,385.5);
   if(bola.getActivarPortal2())
     bola.portal2(259.5, 646.5);
 }
 
 for(int x=0; x<molinos.size(); x++){
   Windmill molino = molinos.get(x);
   molino.display();
 }
 
  pushMatrix();
  fill(255);
  textFont(fuente3);
  text("Puntaje:"+ puntaje , 40 , height-15, 60, 45);
  text("Press R to reset" , 352 , height-20, 60, 45);
  popMatrix();
  
 
 perderJuego();
}

void addBolitas(){
 if(bolitas.size() < 5){
  Ball bola = new Ball(width-20, height-20, 10);
  bola.potenciaDisparo(potencia);
  bolitas.add(bola);
  lanzamiento.trigger();
 }   
}

void perderJuego(){
 if(bolitas.size() == 5){
   boolean areAllDone = true;
   for (Ball bola : bolitas) {
     bola.done();
     areAllDone = areAllDone && bola.isKilled();
   }
   if(areAllDone){
    escenario = 3;
    playGameOver();
    actualizacion = millis();
   }
 }
}

// Collision event functions!
void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
   
  if (o1==null || o2==null)
     return;

  if (o1.getClass() == Ball.class && o2.getClass() == Boundary.class) {
    Boundary temporalObstaculo = (Boundary) o2;
    if(temporalObstaculo.getId().equals("3Grande")){
      Ball temporalBola = (Ball) o1;
      puntaje += temporalObstaculo.getValor();
      choque.trigger();
      temporalObstaculo.animar();
    }

  }
  if (o1.getClass() == Boundary.class && o2.getClass() == Ball.class) {
    Boundary temporalObstaculo = (Boundary) o1;
    if(temporalObstaculo.getId().equals("3Grande")){
      Ball temporalBola = (Ball) o2;
      puntaje += temporalObstaculo.getValor();
      choque.trigger();
      temporalObstaculo.animar();
  }
 }
 
   if (o1.getClass() == Ball.class && o2.getClass() == Boundary.class) {
    Boundary temporalObstaculo = (Boundary) o2;
    if(temporalObstaculo.getId().equals("3Mediana")){
      Ball temporalBola = (Ball) o1;
      puntaje += temporalObstaculo.getValor();
      choque.trigger();
      temporalObstaculo.animar();
    }

  }
  if (o1.getClass() == Boundary.class && o2.getClass() == Ball.class) {
    Boundary temporalObstaculo = (Boundary) o1;
    if(temporalObstaculo.getId().equals("3Mediana")){
      Ball temporalBola = (Ball) o2;
      puntaje += temporalObstaculo.getValor();
      choque.trigger();
      temporalObstaculo.animar();
  }
 }
 
   if (o1.getClass() == Ball.class && o2.getClass() == Boundary.class) {
    Boundary temporalObstaculo = (Boundary) o2;
    if(temporalObstaculo.getId().equals("3Pequeña")){
      Ball temporalBola = (Ball) o1;
      puntaje += temporalObstaculo.getValor();
      choque.trigger();
      temporalObstaculo.animar();
    }

  }
  if (o1.getClass() == Boundary.class && o2.getClass() == Ball.class) {
    Boundary temporalObstaculo = (Boundary) o1;
    if(temporalObstaculo.getId().equals("3Pequeña")){
      Ball temporalBola = (Ball) o2;
      puntaje += temporalObstaculo.getValor();
      choque.trigger();
      temporalObstaculo.animar();
  }
 }
 
   if (o1.getClass() == Ball.class && o2.getClass() == Boundary.class) {
    Boundary temporalObstaculo = (Boundary) o2;
    if(temporalObstaculo.getId().equals("grande")){
      Ball temporalBola = (Ball) o1;
      puntaje += temporalObstaculo.getValor();
      choque.trigger();
      temporalObstaculo.animar();
    }

  }
  if (o1.getClass() == Boundary.class && o2.getClass() == Ball.class) {
    Boundary temporalObstaculo = (Boundary) o1;
    if(temporalObstaculo.getId().equals("grande")){
      Ball temporalBola = (Ball) o2;
      puntaje += temporalObstaculo.getValor();
      choque.trigger();
      temporalObstaculo.animar();
  }
 }
 
    if (o1.getClass() == Ball.class && o2.getClass() == Boundary.class) {
    Boundary temporalObstaculo = (Boundary) o2;
    if(temporalObstaculo.getId().equals("3Medio")){
      Ball temporalBola = (Ball) o1;
      puntaje += temporalObstaculo.getValor();
      choque.trigger();
      temporalObstaculo.animar();
    }

  }
  if (o1.getClass() == Boundary.class && o2.getClass() == Ball.class) {
    Boundary temporalObstaculo = (Boundary) o1;
    if(temporalObstaculo.getId().equals("3Medio")){
      Ball temporalBola = (Ball) o2;
      puntaje += temporalObstaculo.getValor();
      choque.trigger();
      temporalObstaculo.animar();
  }
 }
  if (o1.getClass() == Ball.class && o2.getClass() == Boundary.class) {
    Boundary temporalObstaculo = (Boundary) o2;
    if(temporalObstaculo.getId().equals("portal1")){
      Ball temporalBola = (Ball) o1;
      puntaje += temporalObstaculo.getValor();
      temporalBola.teletransportar1();
      temporalObstaculo.animar();
      portales.trigger();

    }

  }
  if (o1.getClass() == Boundary.class && o2.getClass() == Ball.class) {
    Boundary temporalObstaculo = (Boundary) o1;
    if(temporalObstaculo.getId().equals("portal1")){
      Ball temporalBola = (Ball) o2;
      puntaje += temporalObstaculo.getValor();
      temporalBola.teletransportar1();
      temporalObstaculo.animar();
      portales.trigger();
  }
 }
 
   if (o1.getClass() == Ball.class && o2.getClass() == Boundary.class) {
    Boundary temporalObstaculo = (Boundary) o2;
    if(temporalObstaculo.getId().equals("portal2")){
      Ball temporalBola = (Ball) o1;
      puntaje += temporalObstaculo.getValor();
      temporalBola.teletransportar2();
      temporalObstaculo.animar();
      portales.trigger();

    }

  }
  if (o1.getClass() == Boundary.class && o2.getClass() == Ball.class) {
    Boundary temporalObstaculo = (Boundary) o1;
    if(temporalObstaculo.getId().equals("portal2")){
      Ball temporalBola = (Ball) o2;
      puntaje += temporalObstaculo.getValor();
      temporalBola.teletransportar2();
      temporalObstaculo.animar();
      portales.trigger();
  }
 }
 
    if (o1.getClass() == Ball.class && o2.getClass() == Flipper.class) {
    Flipper temporalFlipper = (Flipper) o2;
    Ball temporalBola = (Ball) o1;
    flippers.trigger();
  }
  if (o1.getClass() == Flipper.class && o2.getClass() == Ball.class) {
    Flipper temporalFlipper = (Flipper) o1;
    Ball temporalBola = (Ball) o2;
    flippers.trigger();
 }
}

// Objects stop touching each other
void endContact(Contact cp) {
}

void reset(){
 for(Ball bola: bolitas){
   bola.killBody();
 }
 bolitas.clear();
 disparando = false;
 puntaje = 0;
 lflip = true;
 rflip = true;
 
 
}


void keyPressed(){
  if(key == ' '){
   if(disparando == false){
    keyDown = millis();
    disparando = true;
   }
  }
  
  if(escenario == 1){
   if(key == 's' || key == 'S'){
    reset();
    escenario = 2;
    playJuego();
    return;
   }
  }
  
  if(escenario == 2){
      if(keyCode == RIGHT && rflip){
    fr.reverseSpeed();
    rflip = false;
  }
  if(keyCode == LEFT && lflip){
    fl.reverseSpeed();
    lflip = false;
  }
   if(key == ' '){
    if(disparando == false){
    keyDown = millis();
    disparando = true;
   }
    return;
   }
  }
}

void keyReleased(){
  if( escenario == 2){
   if(key == ' '){
    keyUp = millis();
    long  diferenciaTiempo = keyUp - keyDown;
    potencia = map(constrain(diferenciaTiempo, 0, 7000), 0, 7000, 50, 150);
    
    addBolitas();
    disparando = false;
   }
   if(key == 'r' || key == 'R'){
     reset();
   }
     if(keyCode == RIGHT && rflip)
  {
    fr.reverseSpeed();
    rflip = true;

  }
  if(keyCode == LEFT && lflip)
  {
    fl.reverseSpeed();
    lflip = true;
  }
   
  }
  
  
}
