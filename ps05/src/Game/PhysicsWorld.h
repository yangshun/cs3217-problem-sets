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
}

- (id)initWithObjects:(NSArray*)newObjects
             andWalls:(NSArray*)walls
           andGravity:(Vector2D*)g 
          andTimeStep:(double)dt;
  // MODIFIES: PhysicsWorld object (state)
  // REQUIRES: parameters to be non-nil
  // EFFECTS: an array of PhysicsRect objects (blocks and walls) are stored

- (void)updateBlocksState;
  // MODIFIES: position of the blocks based on inter-block collisions
  // REQUIRES: timer to be started, timestep > 0
  // EFFECTS: the position of each PhysicsRect object is updated

- (void)notifyViewForObjectCollisionsBetween:(int)index1 andObject:(int)index2;
  // REQUIRES: two objects to be overlapping with each other
  // EFFECTS: the view controller is notified of the collision of these two objects

- (void)notifyViewForObjectCollisionsWithWall:(int)index1; 
  // REQUIRES: an object to be overlapping with a wall
  // EFFECTS: the view controller is notified of the collision of the wall and the object

@property (nonatomic, strong, readwrite) Vector2D *gravity;
@property (nonatomic, readwrite) double timeStep;


@end
