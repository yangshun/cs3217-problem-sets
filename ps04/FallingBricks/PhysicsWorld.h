//
//  PhysicsWorld.h
//  FallingBricks
//
//  Created by Yang Shun Tay on 9/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhysicsRectangle.h"

@interface PhysicsWorld : NSObject {
  
  Vector2D *gravity;
  double timeStep;
  NSArray *phyRectArray;
  NSArray *wallArray;
  UIViewController *vc;
  
}

- (id)initWithObjects:(NSArray*)newObjects
             andWalls:(NSArray*)walls
           andGravity:(Vector2D*)g 
          andTimeStep:(double)dt 
          andObserver:(UIViewController*)worldObserver;
- (void)updateBlocksState;

@property (nonatomic, readwrite) double timeStep;
@property (nonatomic, strong, readwrite) Vector2D *gravity;

@end
