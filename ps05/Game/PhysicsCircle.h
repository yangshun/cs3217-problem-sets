//
//  PhysicsCircle.h
//  FallingBricks
//
//  Created by Yang Shun Tay on 6/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhysicsShape.h"
#import "PhysicsRect.h"

@interface PhysicsCircle: PhysicsShape {
  
  double radius;
  PhysicsCircle *otherCircle;
}

- (id)initWithOrigin:(CGPoint)origin 
            andWidth:(double)thisWidth
           andHeight:(double)thisHeight 
             andMass:(double)mass 
         andRotation:(double)angle 
         andFriction:(double)thisFr
      andRestitution:(double)coeff
             andView:(UIView*)viewObj;
- (BOOL)testOverlap:(PhysicsRect*)other;
- (void)applyImpulses; 
  // MODIFIES: PhysicsCircle object (linear velocity and angular velocity)
  // REQUIRES: overlap between circle and rectangle
  // EFFECTS: linear velocity and angular velocity at each contact point of
  //          the object is updated

@property (nonatomic, readonly) double radius;

@end
