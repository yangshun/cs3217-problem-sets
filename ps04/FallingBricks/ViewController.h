//
//  ViewController.h
//  FallingBricks
//
//  Created by Yang Shun Tay on 6/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhysicsRect.h"
#import "PhysicsWorld.h"

@interface ViewController : UIViewController<UIAccelerometerDelegate> {

  NSTimer *timer;
  double timeStep;
  NSArray *viewRectArray;
  NSArray *blockRectArray;
  NSArray *wallRectArray;
  
  PhysicsWorld *world;
}

- (void)initializeTimer;
  // REQUIRES: PhysicsWorld object, blocks, walls to be created, timestep > 0
  // EFFECTS: repeatedly trigger the updateBlocksState method of PhysicsWorld

- (void)updateViewRectPositions:(NSNotification*)notification;
  // MODIFIES: gravity vector of PhysicsWorld object
  // EFFECTS: changes the gravity vector according to the orientation of the device

- (IBAction)accelerometerSwitch:(id)sender;
  // MODIFIES: gravity vector of PhysicsWorld object
  // EFFECTS: changes the gravity mode of selection between orientation and accelerometer

- (void)rotateView:(NSNotification*)notification;
  // MODIFIES: gravity vector of PhysicsWorld object
  // REQUIRES: device orientation to be changed
  // EFFECTS: changes the gravity vector according to the orientation of the device

- (Vector2D*)selectGravity:(UIDeviceOrientation)interfaceOrientation;
  // EFFECTS: returns a new gravity vector according to the orientation of the device


@end
