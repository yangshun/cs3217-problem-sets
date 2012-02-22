//
//  GamePig.m
//  Game
//
//  Created by Yang Shun Tay on 31/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GamePig.h"

@implementation GamePig

- (id)init {
  // default initializer
  // object will appear in palette
  self = [super initWithObject:[self pigImageView:CGRectMake(190, 50, 55, 55)]];
  
  if (self) {
    objectType = kGameObjectPig;
    centerPointInPalette = CGPointMake(217.5, 77.5);
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)customFrame andState:(BOOL)state {
  // custom initializer
  // object will appear in gamearea at specified frame
  self = [super initWithObject:[self pigImageView:customFrame]];
  
  if (self) {
    objectType = kGameObjectPig;
    centerPointInPalette = CGPointMake(217.5, 77.5);
    insideGameArea = state;
  }
  
  return self;
}

- (UIImageView*)pigImageView:(CGRect)frame {
  // returns an UIImageView of this GameObject subclass at the specified position
  UIImage *pigImage = [UIImage imageNamed:@"pig.png"];
  UIImage *pigCryImage = [UIImage imageNamed:@"pig2.png"];
  
  pigSprite = [[NSMutableArray alloc] init];
  
  for (int i = 0; i < 10; i++) {
    if (i % 2) {
      [pigSprite addObject:pigCryImage];
      [pigSprite addObject:pigCryImage];
    } else {
      [pigSprite addObject:pigImage];
      [pigSprite addObject:pigImage];
    }
  }
  
  UIImage *smokeImage = [UIImage imageNamed:@"pig-die-smoke.png"];

  for (int i = 0; i < 10; i++) {
    CGRect spriteFrame = CGRectMake(80 * (i % 5), 80 * (i / 5), 80, 80);
    CGImageRef pigImageRef = CGImageCreateWithImageInRect([smokeImage CGImage], spriteFrame);
    UIImage *croppedSmoke = [UIImage imageWithCGImage:pigImageRef];
    [pigSprite addObject:croppedSmoke];
  }
 
  
  UIImageView *gamePigImageView = [[UIImageView alloc]initWithImage:[pigSprite objectAtIndex:0]];
  gamePigImageView.animationImages = pigSprite;
  gamePigImageView.animationDuration = 2;
  gamePigImageView.animationRepeatCount = 0;
  gamePigImageView.frame = frame;
  return gamePigImageView;
}

- (void)pigDieAnimation {
  if (alive) {
    [self.gameObjView startAnimating];
    [self performSelector:@selector(destroyObject) withObject:nil afterDelay:1.9];
    alive = NO;
  }
}

- (CGRect)frameInGameArea:(CGPoint)point {
  return CGRectMake(point.x - 15, point.y + 10, 88, 88);
}

@end
