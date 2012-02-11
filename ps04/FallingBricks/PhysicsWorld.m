//
//  PhysicsWorld.m
//  FallingBricks
//
//  Created by Yang Shun Tay on 9/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "PhysicsWorld.h"

@implementation PhysicsWorld
@synthesize timeStep;
@synthesize gravity;

- (id)initWithObjects:(NSArray*)newObjects
             andWalls:(NSArray*)walls
           andGravity:(Vector2D*)g 
          andTimeStep:(double)dt 
          andObserver:(UIViewController*)worldObserver{
  
  self = [super init];
  
  if (self != nil) {
    phyRectArray = newObjects;
    gravity = g;
    timeStep = dt;
    [[NSNotificationCenter defaultCenter] addObserver:worldObserver
                                             selector:@selector(updateViewRectPositions:) 
                                                 name:@"move bodies"
                                               object:nil];
    wallArray = walls;
    
    for (PhysicsRectangle *phyRect in phyRectArray) {
      phyRect.dt = timeStep;
    }
    /*
    ((PhysicsRectangle*)[phyRectArray objectAtIndex:0]).dt = timeStep;
    ((PhysicsRectangle*)[phyRectArray objectAtIndex:1]).dt = timeStep;
    ((PhysicsRectangle*)[phyRectArray objectAtIndex:2]).dt = timeStep;
     */
    
    //[[phyRectArray objectAtIndex:1] updateVelocity:gravity withForce:[Vector2D vectorWith:0 y:-50]];
    //[[phyRectArray objectAtIndex:2] updateVelocity:gravity withForce:[Vector2D vectorWith:0 y:50]];
  }
  return self;
}

- (void)updateBlocksState {
  
  for (int i = 0; i < [phyRectArray count]; i++) {
  
    PhysicsRectangle *rectA = [phyRectArray objectAtIndex:i];
    [rectA updateVelocity:gravity withForce:[Vector2D vectorWith:0 y:0]];
    //[rectA updatePosition];
    
    for (int j = 0; j < [phyRectArray count]; j++) {
      if (i != j) {
        PhysicsRectangle *rectB = [phyRectArray objectAtIndex:j]; 
        if ([rectA testOverlap:rectB]) {
          [rectA applyImpulses];
          [rectB applyImpulses];
        }
      }
    }
  
    for (int k = 0; k < [wallArray count]; k++) {
      PhysicsRectangle *wallRect = [wallArray objectAtIndex:k];
      if ([rectA testOverlap:wallRect]) {
        [rectA applyImpulses];
      }
      [rectA moveBodies];
      wallRect.v = [Vector2D vectorWith:0 y:0];
      wallRect.w = 0;
      NSLog(@"v.x = %f, v.y = %f, w = %f", wallRect.v.x, wallRect.v.y, wallRect.w);
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"move bodies" object:rectA];
  }
  
  
}

@end
