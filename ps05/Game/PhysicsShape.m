//
//  PhysicsShape.m
//  FallingBricks
//
//  Created by Yang Shun Tay on 18/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "PhysicsShape.h"

@implementation PhysicsShape

@synthesize viewShape;
@synthesize m;
@synthesize I;
@synthesize w;
@synthesize v;
@synthesize e;
@synthesize center;
@synthesize rotation;
@synthesize prevRotation;
@synthesize width;
@synthesize height;
@synthesize dt;
@synthesize fr;

- (id)initWithOrigin:(CGPoint)origin 
            andWidth:(double)thisWidth
           andHeight:(double)thisHeight 
             andMass:(double)mass 
         andRotation:(double)angle 
         andFriction:(double)thisFr
      andRestitution:(double)coeff
             andView:(UIView*)viewObj{
  // MODIFIES: PhysicsShape object (state)
  // REQUIRES: parameters to be non-nil
  // EFFECTS: a PhysicsShape object with the method parameters as the 
  //          attributes are initialized
  self = [super init];
  
  if (self) {
    m = mass;
    w = 0;
    v = [Vector2D vectorWith:0 y:0];
    e = coeff;
    width = thisWidth;
    height = thisHeight;
    center = [Vector2D vectorWith:origin.x + width/2 y:origin.y + height/2];
    rotation = angle;
    fr = thisFr;
    viewShape = viewObj;
    contactPoints = [[NSMutableArray alloc] init];
  }
  
  return self;
}

- (void)updateVelocity:(Vector2D*)gravity withForce:(Vector2D*)extForce {
  // MODIFIES: PhysicsShape object (linear velocity)
  // REQUIRES: linear velocity != nil, external force != nil
  // EFFECTS: The linear velocity of the object is updated
  v = [v add:[[gravity add:[extForce multiply:(1 / m)]]multiply:dt]];
}

- (void)updateAngularVelocity:(double)extTorque {
  // MODIFIES: PhysicsShape object (angular velocity)
  // REQUIRES: angular velocity != nil, external torque != nil
  // EFFECTS: The angular velocity of the object is updated
  w += dt * extTorque / I;
}

- (void)applyImpulses {
  // MODIFIES: PhysicsShape object (linear velocity and angular velocity)
  // REQUIRES: at least one contact point
  // EFFECTS: linear velocity and angular velocity at each contact point of
  //          the object is updated
  for (int i = 0; i < [contactPoints count]; i++) {
    [self applyImpulsesAtContactPoint:[contactPoints objectAtIndex:i] 
                           separation:separationDist[i]];
  }
}

- (void)applyImpulsesAtContactPoint:(Vector2D*)c separation:(double)s {
  // MODIFIES: PhysicsShape object (linear velocity and angular velocity)
  // REQUIRES: separation <= 0, contact point to be in rectangle
  // EFFECTS: The linear velocity and angular velocity of the object is updated
  Vector2D *pA = [Vector2D vectorWith:center.x y:center.y];
  Vector2D *rA = [c subtract:pA];
  Vector2D *pB = [Vector2D vectorWith:otherShape.center.x y:otherShape.center.y];
  Vector2D *rB = [c subtract:pB];
  
  Vector2D *uA = [self.v add:[rA crossZ:-self.w]];
  Vector2D *uB = [otherShape.v add:[rB crossZ:-otherShape.w]];
  
  Vector2D *t = [n crossZ:1.0];
  
  Vector2D *u = [uB subtract:uA];
  
  double un = [u dot:n];
  double ut = [u dot:t];
  
  double mn = 1.0 / ((1 / self.m) + (1 / otherShape.m) + 
                     (([rA dot:rA] - ([rA dot:n] * [rA dot:n])) / self.I) + 
                     (([rB dot:rB] - ([rB dot:n] * [rB dot:n])) / otherShape.I));
  double mt = 1.0 / ((1 / self.m) + (1 / otherShape.m) + 
                     (([rA dot:rA] - ([rA dot:t] * [rA dot:t])) / self.I) + 
                     (([rB dot:rB] - ([rB dot:t] * [rB dot:t])) / otherShape.I));
  
  double epsilon = 0.05;
  double k = 0.01;
  double bias = ABS(epsilon / dt * (k + s));
  
  double combinedCoeff = sqrt(e * otherShape.e);
  Vector2D *pn = [n multiply:MIN(0, (mn * ((1 + combinedCoeff) * un - bias)))]; 
  double dPt = mt * ut;
  
  double ptmax = self.fr * otherShape.fr * pn.length;
  
  dPt = MAX(-ptmax, MIN(dPt, ptmax));
  
  Vector2D *pt = [t multiply:dPt];
  Vector2D *sumOfP = [pn add:pt];
  
  self.v = [self.v add:[sumOfP multiply:(1.0 / self.m)]]; 
  otherShape.v = [otherShape.v subtract:[sumOfP multiply:(1.0 / otherShape.m)]]; 
  
  self.w = self.w + ([rA cross:sumOfP] / self.I);
  otherShape.w = otherShape.w - ([rB cross:sumOfP] / otherShape.I);
}

- (void)moveBodies {
  Vector2D *diffV = [v multiply:dt];
  if ([diffV length] > 0.1) { 
    center = [center add:diffV];
  }
  prevRotation = w * dt;
  rotation += prevRotation;
}



@end
