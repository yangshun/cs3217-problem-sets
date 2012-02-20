//
//  PhysicsRect.h
//  FallingBricks
//
//  Created by Yang Shun Tay on 6/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhysicsShape.h"

@interface PhysicsRect: PhysicsShape 

- (id)initWithOrigin:(CGPoint)origin
            andWidth:(double)width 
           andHeight:(double)height 
             andMass:(double)mass 
         andRotation:(double)angle 
         andFriction:(double)fr
      andRestitution:(double)e
             andView:(UIView*)viewObj;
// MODIFIES: PhysicsRect object (state)
// REQUIRES: parameters to be non-nil
// EFFECTS: a PhysicsRect object with the method parameters as the 
//          attributes are initialized

- (BOOL)testOverlap:(PhysicsRect*)other;
// REQUIRES: other != nil
// EFFECTS: tests whether this rectangle is overlapping with another rectangle


@end
