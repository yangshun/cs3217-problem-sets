//
//  CloudFactory.h
//  Game
//
//  Created by Yang Shun Tay on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudObject.h"

typedef enum {kCloudType1, kCloudType2, kCloudType3, kCloudType4} CloudType;

@interface CloudFactory : UIViewController {
  
  UIImage *cloudImage1;
  UIImage *cloudImage2;
  UIImage *cloudImage3;
  UIImage *cloudImage4;
  
  NSMutableArray *clouds;
  
  NSTimer *cloudTimer;
  double timeStep;
}

- (id)initWithTimeStep:(double)dt;
  // REQUIRES: dt to be non-nil
  // EFFECTS: cloud images are loaded

- (void)addCloud:(CloudType)type;
  // MODIFIES: clouds array
  // REQUIRES: self != nil
  // EFFECTS: a cloud object is initialized and added into the clouds array

- (void)startGeneratingClouds;
  // MODIFIES: view
  // REQUIRES: parameters to be non-nil
  // EFFECTS: starts the timer for the cloud factory

- (void)updateClouds;
  // MODIFIES: number of clouds in clouds array
  // REQUIRES: timer to have started
  // EFFECTS: randomly adds clouds of random sizes into the cloud array and     
  //          moves them

- (void)moveClouds; 
  // MODIFIES: position of clouds in clouds array
  // REQUIRES: timer to have started
  // EFFECTS: moves a cloud object by its speed given


@end
