//
//  ViewController.h
//  FallingBricks
//
//  Created by Yang Shun Tay on 6/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhysicsRectangle.h"
#import "PhysicsWorld.h"

@interface ViewController : UIViewController {

  NSTimer *timer;
  CGFloat timeStep;
  NSArray *viewRectArray;
  NSArray *phyRectArray;
  NSArray *wallsArray;
  
  PhysicsWorld *world;
  
}

- (void)initializeTimer;



@end
