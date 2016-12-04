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
  // EFFECTS: object will appear in palette with the thumbnail size
  self = [super initWithObject:[self pigImageView:CGRectMake(kPigOriginPointInPaletteX,
                                                             kPigOriginPointInPaletteY, 
                                                             kPigThumbnailSize, 
                                                             kPigThumbnailSize)]];
  if (self) {
    objectType = kGameObjectPig;
    centerPointInPalette = CGPointMake(kPigCenterPointInPaletteX, kPigCenterPointInPaletteY);
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)customFrame 
        andRotation:(CGFloat)rotation 
           andState:(BOOL)state {
  // EFFECTS: object will appear in gamearea at specified frame and rotation
  self = [super initWithObject:[self pigImageView:customFrame]];
  
  if (self) {
    objectType = kGameObjectPig;
    centerPointInPalette = CGPointMake(kPigCenterPointInPaletteX, kPigCenterPointInPaletteY);
    insideGameArea = state;
    if (insideGameArea) {
      [self customRotation:rotation];
    }
  }
  return self;
}


- (UIImageView*)pigImageView:(CGRect)frame {
  // MODIFIES: self
  // EFFECTS: initializes the sprites for the pig animation and returns a 
  //          UIImageView of this GameObject subclass at the specified position
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
  
  UIImage *pigDieImage = [UIImage imageNamed:@"pig-die-smoke.png"];
  
  CGFloat pigDieImageWidth = pigDieImage.size.width / 5;
  CGFloat pigDieImageHeight = pigDieImage.size.height / 2;
  
  for (int i = 0; i < kPigNumberOfSpritesCry; i++) {
    CGRect spriteFrame = CGRectMake(pigDieImageWidth * (i % (kPigNumberOfSpritesCry / 2)),
                                    pigDieImageHeight * (i / (kPigNumberOfSpritesCry / 2)), 
                                    pigDieImageWidth, pigDieImageHeight);
    CGImageRef pigImageRef = CGImageCreateWithImageInRect([pigDieImage CGImage], spriteFrame);
    UIImage *croppedSmoke = [UIImage imageWithCGImage:pigImageRef];
    [pigSprite addObject:croppedSmoke];
    CGImageRelease(pigImageRef);
  }
 
  UIImageView *gamePigImageView = [[UIImageView alloc]initWithImage:[pigSprite objectAtIndex:0]];
  gamePigImageView.animationImages = pigSprite;
  gamePigImageView.animationDuration = 2;
  gamePigImageView.animationRepeatCount = 0;
  gamePigImageView.frame = frame;
  return gamePigImageView;
}

- (void)pigDieAnimation {
  // MODIFIES: self view
  // REQUIRES: pig to be hit by breathe / ground
  // EFFECTS: shows the pig dying animation
  [self.gameObjView startAnimating];
  [self performSelector:@selector(destroyObject) withObject:nil afterDelay:1.9];
}

- (CGRect)frameInGameArea:(CGPoint)point {
  // EFFECTS: returns the size and position of the object in the gamearea
  return CGRectMake(point.x + kPigGameareaOffsetX, 
                    point.y + kPigGameareaOffsetY, 
                    kPigWidth, kPigHeight);
}

@end
