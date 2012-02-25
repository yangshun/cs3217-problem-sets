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

- (id)initCloudsWithTimeStep:(double)dt;
- (void)addCloud:(CloudType)type;
- (void)startGeneratingClouds;
- (void)generateClouds;
- (void)moveClouds; 

@end
