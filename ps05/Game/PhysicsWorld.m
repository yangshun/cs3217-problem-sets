//
//  PhysicsWorld.m
//  FallingBricks
//
//  Created by Yang Shun Tay on 9/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "PhysicsWorld.h"

@implementation PhysicsWorld
@synthesize gravity;
@synthesize timeStep;

- (id)initWithObjects:(NSArray*)newObjects
             andWalls:(NSArray*)walls
           andGravity:(Vector2D*)g 
          andTimeStep:(double)dt 
          andObserver:(UIViewController*)worldObserver{
  // MODIFIES: PhysicsWorld object (state)
  // REQUIRES: parameters to be non-nil
  // EFFECTS: an array of PhysicsRect objects (blocks and walls) are stored
  self = [super init];
  
  if (self != nil) {
    blockArray = newObjects;
    gravity = g;
    timeStep = dt;
    [[NSNotificationCenter defaultCenter] addObserver:worldObserver
                                             selector:@selector(updateViewObjectPositions:) 
                                                 name:@"MoveBodies"
                                               object:nil];
    wallArray = walls;
    for (PhysicsShape *block in blockArray) {
      // give a timestep to all blocks in the area
      block.dt = timeStep;
    }
  }
  return self;
}

- (void)updateBlocksState {
  // MODIFIES: position of the blocks based on inter-block collisions
  // REQUIRES: timer to be started, timestep > 0
  // EFFECTS: the position of each PhysicsShape object is updated
  
  for (int i = 0; i < [blockArray count]; i++) {
    // iterate through each block and initialize its velocities (linear and angular)
    // based on external forces and torques acting on it
    // in this context, the only external force acting is gravity
    PhysicsShape *shapeA = [blockArray objectAtIndex:i];
    [shapeA updateVelocity:gravity withForce:[Vector2D vectorWith:0 y:0]];
    [shapeA updateAngularVelocity:0];

    for (int j = 0; j < [blockArray count]; j++) {
      if (i != j) {
        // test current shape for overlap with other shapes
        PhysicsShape *shapeB = [blockArray objectAtIndex:j];
        if ([shapeA isKindOfClass:[PhysicsCircle class]]) {
          if ([shapeB isKindOfClass:[PhysicsCircle class]]) {
            // circle-circle interaction
            if ([(PhysicsCircle*)shapeA testOverlapCircle:(PhysicsCircle*)shapeB]) {
              NSLog(@"circle-circle");
              for (int k = 0; k < 5; k++) {
                [shapeA applyImpulses];
              }
            }
          } else {
            // circle-rectangle interaction
            if ([(PhysicsCircle*)shapeA testOverlap:(PhysicsRect*)shapeB]) {
              NSLog(@"circle-rect");
              for (int k = 0; k < 5; k++) {
                [shapeA applyImpulses];
              }
            }
          }
        } else if (![shapeB isKindOfClass:[PhysicsCircle class]] && [shapeA testOverlap:shapeB]) {
          // do not allow shapeB to be circles, hence rectangle-circle disallowed
          // rectangle-rectangle interaction
          NSLog(@"rect-rect");
          for (int k = 0; k < 5; k++) {
            [shapeA applyImpulses];
          }
        }
      }
    }
    
    for (int m = 0; m < [wallArray count]; m++) {
      // test current shape for overlap with walls
      PhysicsRect *wallRect = [wallArray objectAtIndex:m];
      if ([shapeA testOverlap:wallRect]) {
        // if overlapping, apply impulses to shape
        [shapeA applyImpulses];
      }
      [shapeA moveBodies];
    }
  }
  // notify the view to update the state of the rectangles in the view
  [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveBodies" object:blockArray];
}

@end
