//
//  PhysicsCircle.m
//  FallingBricks
//
//  Created by Yang Shun Tay on 6/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "PhysicsCircle.h"

@implementation PhysicsCircle

@synthesize radius;

- (id)initWithOrigin:(CGPoint)origin 
            andWidth:(double)thisWidth
           andHeight:(double)thisHeight 
             andMass:(double)mass 
         andRotation:(double)angle 
         andFriction:(double)thisFr
      andRestitution:(double)coeff
             andView:(UIView*)viewObj {
  // MODIFIES: PhysicsCircle object (state)
  // REQUIRES: parameters to be non-nil
  // EFFECTS: a PhysicsCircle object with the method parameters as the 
  //          attributes are initialized
  self = [super initWithOrigin:origin 
                      andWidth:thisWidth
                     andHeight:thisHeight 
                       andMass:mass 
                   andRotation:angle 
                   andFriction:thisFr
                andRestitution:coeff
                      andView:viewObj];
  
  if (self) {
    radius = width / 2;
    I = (radius * radius) * m / 2.0;
  }
  
  return self;
}

- (BOOL)testOverlap:(PhysicsRect*)other {
  // REQUIRES: other to be a PhysicsRect
  // EFFECTS: Tests whether this circle is overlapping with another rectangle  
  Vector2D *pA = self.center;
 
  otherShape = other;
  Vector2D *hB = [Vector2D vectorWith:otherShape.width/2 y:otherShape.height/2];
  Vector2D *pB = otherShape.center;
  Matrix2D *rotB = [Matrix2D initRotationMatrix:otherShape.rotation];
  Matrix2D *rotTB = [rotB transpose];
  
  Vector2D *d = [pA subtract:pB];
  Vector2D *dB = [rotTB multiplyVector:d];
  
  if ((ABS(dB.x) - radius > hB.x) || (ABS(dB.y) - radius > hB.y)) {
    return NO;
  } 
  
  double dist, closestPtX, closestPtY;
  
  dist = dB.x;
  if (dist > hB.x) {
    dist = hB.x;
  } else if (dist < -hB.x) {
    dist = -hB.x;
  }
  closestPtX = dist;
  
  dist = dB.y;
  if (dist > hB.y) {
    dist = hB.y;
  } else if (dist < -hB.y) {
    dist = -hB.y;
  }
  closestPtY = dist;
  
  Vector2D *closestPt = [Vector2D vectorWith:closestPtX y:closestPtY];
  dist = pow([[closestPt subtract:dB] length], 2);
  
  if (dist > (radius * radius)) {
    return NO;
  } 
  
  Vector2D *closestPtWorld = [pB add:[rotB multiplyVector:closestPt]];
  
  n = [closestPtWorld subtract:pA];
  n = [n multiply:(1.0 / [n length])];
  
  separationDist[0] = radius - sqrt(dist);

  [contactPoints removeAllObjects];
  [contactPoints addObject:closestPtWorld];
  
  return YES;
}

- (void)applyImpulses {
  // MODIFIES: PhysicsCircle object (linear velocity and angular velocity)
  // REQUIRES: overlap between circle and rectangle
  // EFFECTS: linear velocity and angular velocity at each contact point of
  //          the object is updated
  [self applyImpulsesAtContactPoint:[contactPoints objectAtIndex:0] 
                         separation:separationDist[0]];  
}

@end
