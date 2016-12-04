//
//  GameArrow.m
//  Game
//
//  Created by Yang Shun Tay on 16/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameArrow.h"

@implementation GameArrow

@synthesize arrowImage;

- (id)initWithFrame:(CGRect)customFrame {
  // EFFECTS: object will appear on wolf at specified frame
  self = [super initWithObject:[self arrowImageView:customFrame]];
  
  if (self) {
    selectedArrowImage = [UIImage imageNamed:@"direction-arrow-selected.png"];
    self.view.transform = CGAffineTransformMakeRotation(M_PI_4);
    rotatedState = M_PI_4;
    [self.view removeGestureRecognizer:objDoubleTap];
    [self.view removeGestureRecognizer:objRotate];
    [self.view removeGestureRecognizer:objZoom];
  }
  return self;
}

- (UIImageView*)arrowImageView:(CGRect)frame {
  // EFFECTS: returns a UIImageView of this GameObject subclass at the specified position
  arrowImage = [UIImage imageNamed:@"direction-arrow.png"];
  UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
  arrowImageView.frame = frame;
  return arrowImageView;
}

- (void)translate:(UIPanGestureRecognizer *)gesture {
  // MODIFIES: self (game object)
  // REQUIRES: a pan gesture to be recognized
  // EFFECTS: modifies the angle of the arrow
  CGPoint curr = [gesture locationInView:self.view.superview];
  
  CGFloat rotationAngle = atan((curr.y - self.view.center.y) / 
                               (curr.x - self.view.center.x)) + M_PI_2;
  
  rotatedState += rotationAngle;
  
  if (rotationAngle < M_PI_4/4 || rotationAngle > M_PI * 3/4) {
    gameObjView.image = arrowImage;
    return;
  }
  // changes the image of the arrow if it is being shifted around
  if (gesture.state == UIGestureRecognizerStateBegan) {
    gameObjView.image = selectedArrowImage;
  }
  
  if ([delegate respondsToSelector:@selector(scrollViewDisabled)]) {
    [delegate scrollViewDisabled];
  }
  
  self.view.transform = CGAffineTransformMakeRotation(rotationAngle);
  
  if (gesture.state == UIGestureRecognizerStateEnded) {
    gameObjView.image = arrowImage;
  }
  
  if ([delegate respondsToSelector:@selector(scrollViewEnabled)]) {
    [delegate scrollViewEnabled];
  }
}


@end
