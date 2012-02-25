//
//  GameWolf.h
//  Game
//
//  Created by Yang Shun Tay on 28/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"

@interface GameWolf : GameObject {
  UIImage *wolfImage;
  UIImage *wolfDieImage;
  NSMutableArray *wolfSpriteBlow;
  NSMutableArray *wolfSpriteDie;
  int currentSpriteFrame;
  NSTimer *wolfBreatheTimer;
  BOOL dead;
}

- (id)initWithFrame:(CGRect)customFrame 
        andRotation:(CGFloat)rotation
           andState:(BOOL)state; 
- (UIImageView*)wolfImageView:(CGRect)frame;
- (CGRect)frameInGameArea:(CGPoint)point;
- (void)startWolfBlow;
- (void)wolfBlowAnimation; 
- (void)wolfDieAnimation;

@property (nonatomic, strong) UIImage* wolfImage;

@end
