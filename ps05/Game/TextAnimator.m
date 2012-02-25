//
//  TextAnimator.m
//  Game
//
//  Created by Yang Shun Tay on 21/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "TextAnimator.h"

#define kAnimationStep 120

@implementation TextAnimator

- (id)init {
    self = [super init];
    if (self) {
      startText = [UIImage imageNamed:@"text-huff-and-puff-away.png"];
      victoryText = [UIImage imageNamed:@"text-victory.png"];
      gameOverText = [UIImage imageNamed:@"text-game-over.png"];
    }
    return self;
}

- (void)animateZoomScreenAcrossWithPause:(TextType)type {
  self.image = [self selectImage:type];
  [self flyInStartText];
  [self performSelector:@selector(pauseTimer) withObject:nil afterDelay:0.5];
  [self performSelector:@selector(flyOutStartText) withObject:nil afterDelay:1.5];
  [self performSelector:@selector(endTimer) withObject:nil afterDelay:2.0];
}
  
- (void)animatePauseAtMiddleOfScreen:(TextType)type {
  self.image = [self selectImage:type];
  [self flyInStartText];
  [self performSelector:@selector(pauseTimer) withObject:nil afterDelay:0.5];
}

- (UIImage*)selectImage:(TextType)type {
  UIImage *image;
  switch (type) {
    case kHuffAndPuff:
      image = startText;
      self.frame = CGRectMake(-920, 375, 477, 28);
      break;
    case kVictory:
      image = victoryText;
      self.frame = CGRectMake(-810, 375, 213, 28);
      break;
    case kGameOver:
      image = gameOverText;
      self.frame = CGRectMake(-830, 375, 267, 28);
      break;      
  }
  return image;
}

- (void)flyInStartText {
  textTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                               target:self 
                                             selector:@selector(flyAcrossText) 
                                             userInfo:nil 
                                              repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:textTimer forMode:NSRunLoopCommonModes];

}

- (void)pauseTimer {
  [textTimer invalidate];
}

- (void)flyOutStartText {
  textTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                               target:self 
                                             selector:@selector(flyAcrossText) 
                                             userInfo:nil 
                                              repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:textTimer forMode:NSRunLoopCommonModes];

}

- (void)endTimer {
  [textTimer invalidate];
  [self removeFromSuperview];
}

- (void)flyAcrossText {
  self.center = CGPointMake(self.center.x + kAnimationStep, self.center.y);
}

@end
