//
//  PhysicsWorld.h
//  FallingBricks
//
//  Created by Yang Shun Tay on 9/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhysicsRect.h"
#import "PhysicsCircle.h"

@interface PhysicsWorld : NSObject {
  
  Vector2D *gravity;
  double timeStep;
  NSArray *blockArray;
  NSArray *wallArray;
  BOOL accelerometerActivated;
  
}

- (id)initWithObjects:(NSArray*)newObjects
             andWalls:(NSArray*)walls
           andGravity:(Vector2D*)g 
          andTimeStep:(double)dt 
          andObserver:(UIViewController*)worldObserver;
  // MODIFIES: PhysicsWorld object (state)
  // REQUIRES: parameters to be non-nil
  // EFFECTS: an array of PhysicsRect objects (blocks and walls) are stored

- (void)updateBlocksState;
  // MODIFIES: position of the blocks based on inter-block collisions
  // REQUIRES: timer to be started, timestep > 0
  // EFFECTS: the position of each PhysicsRect object is updated

@property (nonatomic, strong, readwrite) Vector2D *gravity;
@property (nonatomic, readwrite) double timeStep;
@property (nonatomic, readwrite) BOOL accelerometerActivated;


@end
