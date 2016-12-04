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
@synthesize accelerometerActivated;

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
    accelerometerActivated = NO;
    // TA: It should be the main view controller which add the observer
    // for the notification.
    [[NSNotificationCenter defaultCenter] addObserver:worldObserver
                                             selector:@selector(updateViewRectPositions:) 
                                                 name:@"MoveBodies"
                                               object:nil];
    wallArray = walls;
    
    for (PhysicsRect *blockRect in blockArray) {
      blockRect.dt = timeStep;
    }
  }
  return self;
}


- (void)updateBlocksState {
  // MODIFIES: position of the blocks based on inter-block collisions
  // REQUIRES: timer to be started, timestep > 0
  // EFFECTS: the position of each PhysicsRect object is updated
  for (int i = 0; i < [blockArray count]; i++) {
    // iterate through each block and initialize its velocities (linear and angular)
    // based on external forces and torques acting on it
    // in this context, the only external force acting is gravity
    PhysicsRect *rectA = [blockArray objectAtIndex:i];
    [rectA updateVelocity:gravity withForce:[Vector2D vectorWith:0 y:0]];
    [rectA updateAngularVelocity:0];
    
    for (int j = 0; j < [blockArray count]; j++) {
      // test current rectangle for overlap with other rectangles
      if (i != j) {
        PhysicsRect *rectB = [blockArray objectAtIndex:j]; 
        if ([rectA testOverlap:rectB]) {
          // if overlapping, apply impulses to rectangles
          for (int k = 0; k < 10; k++) {
            [rectA applyImpulses];
          }
        }
      }
    }
    
    for (int m = 0; m < [wallArray count]; m++) {
      // test current rectangle for overlap with walls
      PhysicsRect *wallRect = [wallArray objectAtIndex:m];
      if ([rectA testOverlap:wallRect]) {
        // if overlapping, apply impulses to rectangle
        [rectA applyImpulses];
      }
      [rectA moveBodies];
    }
    // notify the view to update the state of the rectangles in the view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveBodies" object:rectA];
  }
}

@end
