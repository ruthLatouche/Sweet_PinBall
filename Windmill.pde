// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// Box2DProcessing example

// Class to describe a fixed spinning object

class Windmill {

  // Our object is two boxes and one joint
  // Consider making the fixed box much smaller and not drawing it
  RevoluteJoint joint;
  Box box1;
  Box box2;

  Windmill(float x, float y, float diametro) {

    // Initialize locations of two boxes
    box1 = new Box(x, y, diametro, 10, false); 
    box2 = new Box(x, y, 10, 40, true); 

    // Define joint as between two bodies
    RevoluteJointDef rjd = new RevoluteJointDef();

    Vec2 offset = box2d.vectorPixelsToWorld(new Vec2(0, 60));

    rjd.initialize(box1.body, box2.body, box1.body.getWorldCenter());

    // Turning on a motor (optional)
    rjd.motorSpeed = PI*2;       // how fast?
    rjd.maxMotorTorque = 600.0; // how powerful?
    rjd.enableMotor = true;      // is it on?

    // There are many other properties you can set for a Revolute joint
    // For example, you can limit its angle between a minimum and a maximum
    // See box2d manual for more

      // Create the joint
    joint = (RevoluteJoint) box2d.world.createJoint(rjd);
  }

  // Turn the motor on or off
  void toggleMotor() {
    joint.enableMotor(!joint.isMotorEnabled());
  }

  boolean motorOn() {
    return joint.isMotorEnabled();
  }


  void display() {
    box1.display();

    // Draw anchor just for debug
    Vec2 anchor = box2d.coordWorldToPixels(box1.body.getWorldCenter());
    fill(#64B3B1);
    noStroke();
    ellipse(anchor.x, anchor.y, 4, 4);
  }
}
