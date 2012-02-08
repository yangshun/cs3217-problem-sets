//
//  ViewController.h
//  FallingBricks
//
//  Created by Yang Shun Tay on 6/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rectangle.h"

@interface ViewController : UIViewController {
  
  Rectangle *testRect;
  Rectangle *testRect2;
  NSTimer *timer;
  CGFloat timeStep;
}

- (void)initializeTimer;

@end
