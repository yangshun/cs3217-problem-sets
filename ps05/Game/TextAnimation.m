//
//  TextAnimation.m
//  Game
//
//  Created by Yang Shun Tay on 21/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "TextAnimation.h"

#define kAnimationStep 120

@implementation TextAnimation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      startText = [UIImage imageNamed:@"huff-and-puff-away"];
      self.image = startText;
    }
    return self;
}

- (void)flyInStartText {
  textTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                               target:self 
                                             selector:@selector(flyAcrossText) 
                                             userInfo:nil 
                                              repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:textTimer forMode:NSRunLoopCommonModes];
  [self performSelector:@selector(pauseTimer) withObject:nil afterDelay:0.5];
}

- (void)pauseTimer {
  [textTimer invalidate];
  [self performSelector:@selector(flyOutStartText) withObject:nil afterDelay:1.0];
}

- (void)flyOutStartText {
  textTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                               target:self 
                                             selector:@selector(flyAcrossText) 
                                             userInfo:nil 
                                              repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:textTimer forMode:NSRunLoopCommonModes];
  [self performSelector:@selector(endTimer) withObject:nil afterDelay:0.5];
}

- (void)endTimer {
  [textTimer invalidate];
}

- (void)flyAcrossText {
  self.center = CGPointMake(self.center.x + kAnimationStep, self.center.y);
}

@end
