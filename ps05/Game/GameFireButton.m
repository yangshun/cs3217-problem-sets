//
//  GameFireButton.m
//  Game
//
//  Created by Yang Shun Tay on 20/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameFireButton.h"

@implementation GameFireButton

@synthesize buttonImage;

- (id)initWithFrame:(CGRect)customFrame {
  // custom initializer
  // object will appear at bottom at specified frame
  self = [super initWithObject:[self buttonImageView:customFrame]];
  
  if (self) {
    insideGameArea = YES;
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view removeGestureRecognizer:objDoubleTap];
    [self.view removeGestureRecognizer:objRotate];
    [self.view removeGestureRecognizer:objZoom];
    [self.view removeGestureRecognizer:objDrag];
    objSingleTap = [[UITapGestureRecognizer alloc] 
                    initWithTarget:self action:@selector(pressed:)];
    objSingleTap.delegate = self;
    objSingleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:objSingleTap];
  }
  return self;
}

- (UIImageView*)buttonImageView:(CGRect)frame {
  // returns an UIImageView of this GameObject subclass at the specified position
  buttonImage = [UIImage imageNamed:@"breath-bar.png"];
  UIImageView *buttonImageView = [[UIImageView alloc] initWithImage:buttonImage];
  buttonImageView.frame = frame;
  return buttonImageView;
}

- (void)pressed:(UITapGestureRecognizer*)gesture {
  // EFFECTS: fires a projectile from the wolf's mouth
  [[NSNotificationCenter defaultCenter] postNotificationName:@"FireButtonPressed" object:nil];
}

@end
