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
  // EFFECTS: object will appear in gamearea at specified frame
  self = [super initWithObject:[self breatheImageView:customFrame]];
  
  if (self) {
    [self removeAllGestureRecognizers];
    gameObjView.contentMode = UIViewContentModeScaleAspectFit;
  }
  return self;
}

- (UIImageView*)breatheImageView:(CGRect)frame {
  // EFFECTS: initializes the sprites for the travelling breathe and dispersing breathe
  //          returns an UIImageView of this GameObject subclass at the specified position
  breatheImage = [UIImage imageNamed:@"windblow.png"];
  breatheSprite = [[NSMutableArray alloc] init];
  breatheSpriteDisperse = [[NSMutableArray alloc] init];
  
  CGFloat breatheImageWidth = breatheImage.size.width / 4;
  CGFloat breatheImageHeight = breatheImage.size.height;
  
  for (int i = 0; i < kBreatheNumberOfSpritesTravel; i++) {
    CGRect spriteFrame = CGRectMake(breatheImageWidth * i, 0, 
                                    breatheImageWidth,
                                    breatheImageHeight);
    CGImageRef breatheImageRef = CGImageCreateWithImageInRect([breatheImage CGImage], spriteFrame);
    UIImage *croppedBreathe = [UIImage imageWithCGImage:breatheImageRef];
    [breatheSprite addObject:croppedBreathe];
    CGImageRelease(breatheImageRef);
  }

  breatheDisperseImage = [UIImage imageNamed:@"wind-disperse.png"];
  
  CGFloat breatheDisperseImageWidth = breatheDisperseImage.size.width / 5;
  CGFloat breatheDisperseImageHeight = breatheDisperseImage.size.height / 2;
  
  for (int i = 0; i < kBreatheNumberOfSpritesDisperse; i++) {
    CGRect spriteFrame = CGRectMake(breatheDisperseImageWidth * (i % (kBreatheNumberOfSpritesDisperse / 2)), 
                                    breatheDisperseImageHeight * (i / (kBreatheNumberOfSpritesDisperse / 2)), 
                                    breatheDisperseImageWidth, 
                                    breatheDisperseImageWidth);
    CGImageRef breatheImageRef = CGImageCreateWithImageInRect([breatheDisperseImage CGImage], spriteFrame);
    UIImage *croppedBreatheDisperse = [UIImage imageWithCGImage:breatheImageRef];
    [breatheSpriteDisperse addObject:croppedBreatheDisperse];
    CGImageRelease(breatheImageRef);
  }
  
  UIImageView *breatheImageView = [[UIImageView alloc] initWithImage:[breatheSprite objectAtIndex:0]];
  breatheImageView.animationImages = breatheSprite;
  breatheImageView.animationDuration = 0.5;
  breatheImageView.animationRepeatCount = INFINITY;
  breatheImageView.frame = frame;
  return breatheImageView;
}

- (void)breatheTravelAnimation {
  // MODIFIES: self (GameBreathe)
  // EFFECTS: the view will start animating
  [self.gameObjView startAnimating];
}

- (void)breatheDisperseAnimation {
  // MODIFIES: self (GameBreathe)
  // EFFECTS: the view will show the disperse animation and remove itself from subview
  if (objectState == kGameAlive) {    
    [self.gameObjView stopAnimating];
    self.view.transform = CGAffineTransformScale(self.view.transform, 2, 2);
    self.gameObjView = [[UIImageView alloc] initWithImage:[breatheSpriteDisperse objectAtIndex:0]];
    self.gameObjView.animationImages = breatheSpriteDisperse;
    self.gameObjView.animationDuration = 1.0;
    self.gameObjView.animationRepeatCount = INFINITY;
    self.view = self.gameObjView;
    [self.gameObjView startAnimating];
    [self performSelector:@selector(destroyObject) withObject:nil afterDelay:1.0];
    objectState = kGameDead;
  }
}

@end
