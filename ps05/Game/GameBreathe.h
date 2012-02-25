//
//  GameBreathe.h
//  Game
//
//  Created by Yang Shun Tay on 20/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"

@interface GameBreathe : GameObject {
  UIImage *breatheImage;
  UIImage *breatheDisperseImage;
  NSMutableArray *breatheSprite;
  NSMutableArray *breatheSpriteDisperse;
  int currentSpriteFrame;
  NSTimer *breatheTimer;
}

- (id)initWithFrame:(CGRect)customFrame;
- (UIImageView*)breatheImageView:(CGRect)frame;
- (void)breatheTravelAnimation; 
- (void)breatheDisperseAnimation;

@property (nonatomic, strong) UIImage *breatheImage;

@end
