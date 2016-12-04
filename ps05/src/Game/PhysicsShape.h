//
//  PhysicsShape.h
//  FallingBricks
//
//  Created by Yang Shun Tay on 18/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix2D.h"
#import "Vector2D.h"

typedef enum {ax, ay, bx, by} VectorDiffComponent;

@interface PhysicsShape : NSObject {
  
  PhysicsShape *otherShape;
  
  // Physical quantities related to dynamics
  double m;        // Mass
  double I;        // Moment of Inertia
  double w;        // Angular velocity
  Vector2D *v;     // Linear Velocity
  
  // Physical quantities related to position of shape
  Vector2D *center;// Center of mass
  double rotation; // Angle rotated from upright position
  double prevRotation; // Angle rotated from its previous rotation
  double width;    // Width of shape
  double height;   // Height of shape
  double dt;       // Timestep
  
  // Physical quantities related to collision
  Vector2D *n;     // Normal vector
  double e;        // Coefficient of restitution
  double fr;       // Coefficient of friction
  NSMutableArray *contactPoints;
  double separationDist[2];
  
  UIView *viewShape;
}

@property (nonatomic, strong, readwrite) UIView *viewShape;
@property (nonatomic, readonly) double m;
@property (nonatomic, readonly) double I;
@property (nonatomic, readwrite) double w;
@property (nonatomic, strong, readwrite) Vector2D *v;
@property (nonatomic, readonly) double e;
@property (nonatomic, strong, readwrite) Vector2D *center;
@property (nonatomic, readwrite) double rotation;
@property (nonatomic, readwrite) double prevRotation;
@property (nonatomic, readonly) double width;
@property (nonatomic, readonly) double height;
@property (nonatomic, readwrite) double dt;
@property (nonatomic, readonly) double fr;

- (id)initWithOrigin:(CGPoint)origin
            andWidth:(double)width 
           andHeight:(double)height 
             andMass:(double)mass 
         andRotation:(double)angle 
         andFriction:(double)fr
      andRestitution:(double)e
             andView:(UIView*)viewObj;
// MODIFIES: PhysicsShape object (state)
// REQUIRES: parameters to be non-nil
// EFFECTS: a PhysicsShape object with the method parameters as the 
//          attributes are initialized

- (void)updateVelocity:(Vector2D*)gravity withForce:(Vector2D*)extForce;
// MODIFIES: PhysicsShape object (linear velocity)
// REQUIRES: linear velocity != nil
// EFFECTS: the linear velocity of the object is updated

- (void)updateAngularVelocity:(double)extTorque;
// MODIFIES: PhysicsShape object (angular velocity)
// REQUIRES: angular velocity != nil
// EFFECTS: the angular velocity of the object is updated

- (BOOL)testOverlap:(PhysicsShape*)other;
// REQUIRES: other != nil
// EFFECTS: tests whether this rectangle is overlapping with another rectangle

- (void)applyImpulses;
// MODIFIES: PhysicsShape object (linear velocity and angular velocity)
// REQUIRES: at least one contact point
// EFFECTS: linear velocity and angular velocity of the object is updated

- (void)applyImpulsesAtContactPoint:(Vector2D*)c separation:(double)s;
// MODIFIES: PhysicsShape object (linear velocity and angular velocity)
// REQUIRES: separation <= 0, contact point to be in shape
// EFFECTS: The linear velocity and angular velocity of the object is updated

- (void)moveBodies;
// MODIFIES: PhysicsShape object (position)
// REQUIRES: impulses to have already taken effect
// EFFECTS: the position of the object is changed according to impulse acting on it
//          in a difference of one timestep



@end
