//
//  GameBar.m
//  Game
//
//  Created by Yang Shun Tay on 16/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameBar.h"

@implementation GameBar
@synthesize barImage;

- (id)initWithFrame:(CGRect)customFrame {
  // custom initializer
  // object will appear at bottom at specified frame
  self = [super initWithObject:[self barImageView:customFrame]];
  
  if (self) {
    insideGameArea = YES;
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view removeGestureRecognizer:objDoubleTap];
    [self.view removeGestureRecognizer:objRotate];
    [self.view removeGestureRecognizer:objZoom];
  }
  return self;
}

- (UIImageView*)barImageView:(CGRect)frame {
  // returns an UIImageView of this GameObject subclass at the specified position
  barImage = [UIImage imageNamed:@"breath-bar.png"];
  UIImageView *barImageView = [[UIImageView alloc] initWithImage:barImage];
  barImageView.frame = frame;
  return barImageView;
}

- (void)translate:(UIPanGestureRecognizer *)gesture {
  // MODIFIES: self (game object)
  // REQUIRES: a pan gesture to be recognized
  // EFFECTS: modifies the length of the bar
  
  CGPoint curr = [gesture locationInView:self.view.superview];
  
  self.view.frame = CGRectMake(self.view.frame.origin.x, 
                               self.view.frame.origin.y, 
                               curr.x - self.view.frame.origin.x, 
                               self.view.frame.size.height);
    
  if (gesture.state == UIGestureRecognizerStateBegan) {
    gameObjView.image = barImage;
  }
  
  if (gesture.state == UIGestureRecognizerStateEnded) {
    gameObjView.image = barImage;
  }
  
  if ([delegate respondsToSelector:@selector(scrollViewEnabled)]) {
    [delegate scrollViewEnabled];
  }
  
  prevPanPoint = curr;
}

@end
