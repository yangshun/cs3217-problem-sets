//
//  GameBreathe.m
//  Game
//
//  Created by Yang Shun Tay on 20/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameBreathe.h"

@implementation GameBreathe

@synthesize breatheImage;

- (id)initWithFrame:(CGRect)customFrame {
  // custom initializer
  // object will appear in gamearea at specified frame
  self = [super initWithObject:[self breatheImageView:customFrame]];
  
  if (self) {
    [self removeAllGestureRecognizers];
    currentSpriteFrame = 0;
  }
  return self;
}

- (UIImageView*)breatheImageView:(CGRect)frame {
  // initializes the sprites for the travelling breathe and dispersing breathe
  // returns an UIImageView of this GameObject subclass at the specified position
  breatheImage = [UIImage imageNamed:@"windblow.png"];
  breatheSprite = [[NSMutableArray alloc] init];
  breatheSpriteDisperse = [[NSMutableArray alloc] init];
  
  for (int i = 0; i < 4; i++) {
    CGRect spriteFrame = CGRectMake(113 * i, 0, 113, 104);
    CGImageRef breatheImageRef = CGImageCreateWithImageInRect([breatheImage CGImage], spriteFrame);
    UIImage *croppedBreathe = [UIImage imageWithCGImage:breatheImageRef];
    [breatheSprite addObject:croppedBreathe];
  }
  
  breatheDisperseImage = [UIImage imageNamed:@"wind-disperse.png"];
  for (int i = 0; i < 10; i++) {
    CGRect spriteFrame = CGRectMake(253 * (i % 5), 259 * (i / 5), 253, 259);
    CGImageRef breatheImageRef = CGImageCreateWithImageInRect([breatheDisperseImage CGImage], spriteFrame);
    UIImage *croppedBreatheDisperse = [UIImage imageWithCGImage:breatheImageRef];
    [breatheSpriteDisperse addObject:croppedBreatheDisperse];
  }
  
  UIImageView *breatheImageView = [[UIImageView alloc] initWithImage:[breatheSprite objectAtIndex:0]];
  breatheImageView.animationImages = breatheSprite;
  breatheImageView.animationDuration = 0.5;
  breatheImageView.animationRepeatCount = 0;
  breatheImageView.frame = frame;
  return breatheImageView;
}

- (void)startBreathe {
  [self.gameObjView startAnimating];
}

- (void)breatheAnimation {
  currentSpriteFrame++;
  currentSpriteFrame %= 4;
  gameObjView.image = [breatheSprite objectAtIndex:currentSpriteFrame];
}


@end