//
//  GameWolf.m
//  Game
//
//  Created by Yang Shun Tay on 28/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameWolf.h"

@implementation GameWolf

@synthesize wolfImage;

- (id)init {
  // default initializer
  // object will appear in palette
  self = [super initWithObject:[self wolfImageView:CGRectMake(20, 20, 150, 100)]];
  
  if (self) {
    objectType = kGameObjectWolf;
    centerPointInPalette = CGPointMake(95, 70);
  }
  return self;
}
   
- (id)initWithFrame:(CGRect)customFrame andState:(BOOL)state {
  // custom initializer
  // object will appear in gamearea at specified frame
  self = [super initWithObject:[self wolfImageView:customFrame]];
  
  if (self) {
    objectType = kGameObjectWolf;
    centerPointInPalette = CGPointMake(95, 70);
    insideGameArea = state;
  }
  return self;
}

- (UIImageView*)wolfImageView:(CGRect)frame {
  // initializes the sprites for the blowing wolf and dying wolf
  // returns an UIImageView of this GameObject subclass at the specified position
  wolfImage = [UIImage imageNamed:@"wolfs.png"];
  wolfSpriteBlow = [[NSMutableArray alloc] init];
  wolfSpriteDie = [[NSMutableArray alloc] init];
  
  for (int i = 0; i < 15; i++) {
    CGRect spriteFrame = CGRectMake(225 * (i % 5), 150 * floor(i / 5.0), 225, 150);
    CGImageRef wolfImageRef = CGImageCreateWithImageInRect([wolfImage CGImage], spriteFrame);
    UIImage *croppedWolf = [UIImage imageWithCGImage:wolfImageRef];
    [wolfSpriteBlow addObject:croppedWolf];
  }
  
  wolfDieImage = [UIImage imageNamed:@"wolfdie.png"];
  for (int i = 0; i < 16; i++) {
    CGRect spriteFrame = CGRectMake(225 * (i % 4), 150 * floor(i / 4.0), 225, 150);
    CGImageRef wolfImageRef = CGImageCreateWithImageInRect([wolfDieImage CGImage], spriteFrame);
    UIImage *croppedWolfDie = [UIImage imageWithCGImage:wolfImageRef];
    [wolfSpriteDie addObject:croppedWolfDie];
  }
  
  UIImageView *wolfImageView = [[UIImageView alloc] initWithImage:[wolfSpriteBlow objectAtIndex:0]];
  wolfImageView.frame = frame;
  return wolfImageView;
}

- (CGRect)frameInGameArea:(CGPoint)point {
  return CGRectMake(point.x - 35, point.y - 10, 225, 150);
}

- (void)startWolfBlow {
  wolfBreatheTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
                                                      target:self 
                                                    selector:@selector(wolfBlowAnimation) 
                                                    userInfo:nil 
                                                     repeats:YES];
}

- (void)wolfBlowAnimation {
  currentSpriteFrame++;
  currentSpriteFrame %= 15;
  if (currentSpriteFrame == 0) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayShootingGuide" object:nil];
    [wolfBreatheTimer invalidate];
  }
  gameObjView.image = [wolfSpriteBlow objectAtIndex:currentSpriteFrame];
}

@end
