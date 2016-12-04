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
  // EFFECTS: object will appear in palette with the thumbnail size
  self = [super initWithObject:[self wolfImageView:CGRectMake(kWolfOriginPointInPaletteX,
                                                              kWolfOriginPointInPaletteY,
                                                              kWolfThumbnailWidth,
                                                              kWolfThumbnailHeight)]];
  if (self) {
    objectType = kGameObjectWolf;
    centerPointInPalette = CGPointMake(kWolfCenterPointInPaletteX, kWolfCenterPointInPaletteY);
    currentSpriteFrame = 0;
  }
  return self;
}
   
- (id)initWithFrame:(CGRect)customFrame 
        andRotation:(CGFloat)rotation
           andState:(BOOL)state {
  // EFFECTS: object will appear in gamearea at specified position and size
  self = [super initWithObject:[self wolfImageView:customFrame]];
  
  if (self) {
    objectType = kGameObjectWolf;
    centerPointInPalette = CGPointMake(kWolfCenterPointInPaletteX, kWolfCenterPointInPaletteY);
    insideGameArea = state;
    if (insideGameArea) {
      [self customRotation:rotation];
    }
  }
  return self;
}

- (UIImageView*)wolfImageView:(CGRect)frame {
  // EFFECTS: initializes the sprites for the blowing wolf and dying wolf
  //          returns an UIImageView of this GameObject subclass at the specified position
  wolfImage = [UIImage imageNamed:@"wolfs.png"];
  wolfSpriteBlow = [[NSMutableArray alloc] init];
  wolfSpriteDie = [[NSMutableArray alloc] init];
  
  CGFloat wolfBlowImageWidth = wolfImage.size.width / 5;
  CGFloat wolfBlowImageHeight = wolfImage.size.height / 3;
  
  for (int i = 0; i < kWolfNumberOfSpritesBlow; i++) {
    CGRect spriteFrame = CGRectMake(wolfBlowImageWidth * (i % (kWolfNumberOfSpritesBlow / 3)), 
                                    wolfBlowImageHeight * (i / (kWolfNumberOfSpritesBlow / 3)), 
                                    wolfBlowImageWidth, wolfBlowImageHeight);
    CGImageRef wolfImageRef = CGImageCreateWithImageInRect([wolfImage CGImage], spriteFrame);
    UIImage *croppedWolf = [UIImage imageWithCGImage:wolfImageRef];
    [wolfSpriteBlow addObject:croppedWolf];
    CGImageRelease(wolfImageRef);
  }
  
  wolfDieImage = [UIImage imageNamed:@"wolfdie.png"];
  
  CGFloat wolfDieImageWidth = wolfDieImage.size.width / 4;
  CGFloat wolfDieImageHeight = wolfDieImage.size.height / 4;
  
  for (int i = 0; i < kWolfNumberOfSpritesDie; i++) {
    CGRect spriteFrame = CGRectMake(wolfDieImageWidth * (i % (kWolfNumberOfSpritesDie / 4)),
                                    wolfDieImageHeight * (i / (kWolfNumberOfSpritesDie / 4)), 
                                    wolfDieImageWidth, wolfDieImageHeight);
    CGImageRef wolfImageRef = CGImageCreateWithImageInRect([wolfDieImage CGImage], spriteFrame);
    UIImage *croppedWolfDie = [UIImage imageWithCGImage:wolfImageRef];
    [wolfSpriteDie addObject:croppedWolfDie];
    CGImageRelease(wolfImageRef);
  }
  
  UIImageView *wolfImageView = [[UIImageView alloc] initWithImage:[wolfSpriteBlow objectAtIndex:0]];
  wolfImageView.frame = frame;
  return wolfImageView;
}

- (void)startWolfBlow {
  // MODIFIES: self (view)
  // REQUIRES: fire button to be pressed
  // EFFECTS: wolf displays blowing animation
  wolfBreatheTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 
                                                      target:self 
                                                    selector:@selector(wolfBlowAnimation) 
                                                    userInfo:nil 
                                                     repeats:YES];
  //[[NSRunLoop mainRunLoop] addTimer:wolfBreatheTimer forMode:NSRunLoopCommonModes];
}

- (void)wolfBlowAnimation {
  // MODIFIES: current frame of the wolf image
  // REQUIRES: wolf breathe time to have been fired
  // EFFECTS: wolf view cycles through the blowing image sprites and tells the
  //          view controller to fire the breathe at the 12th frame
  currentSpriteFrame++;
  currentSpriteFrame %= 15;
  switch (currentSpriteFrame) {
    case 0:
      [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleShootingGuide" object:nil];
      [wolfBreatheTimer invalidate];
      break;
    case 12:
      [[NSNotificationCenter defaultCenter] postNotificationName:@"ShootProjectile" object:nil];
      break;
    default:
      break;
  }
  gameObjView.image = [wolfSpriteBlow objectAtIndex:currentSpriteFrame];
}

- (void)wolfDieAnimation {
  // MODIFIES: self (view)
  // REQUIRES: wolf to have ran out of lives
  // EFFECTS: wolf shows dying animation
  if(objectState == kGameAlive) {
    self.view.transform = CGAffineTransformScale(self.view.transform, kWolfScale, kWolfScale);
    self.view.transform = CGAffineTransformTranslate(self.view.transform, 0.0, kWolfDieOffsetY);
    self.gameObjView = [[UIImageView alloc] initWithImage:[wolfSpriteDie objectAtIndex:0]];
    self.view = self.gameObjView;
    self.gameObjView.animationImages = wolfSpriteDie;
    self.gameObjView.animationDuration = 3.0;
    self.gameObjView.animationRepeatCount = 0;
    [self.gameObjView startAnimating];
    [self performSelector:@selector(wolfLieOnFloor) withObject:nil afterDelay:3.0];
    objectState = kGameDead;
  }
}

- (void)wolfLieOnFloor {
  // MODIFIES: self (view)
  // REQUIRES: wolf to have displayed dying animation
  // EFFECTS: view of the wolf is set to the last frame
  self.gameObjView = [[UIImageView alloc] initWithImage:
                      [wolfSpriteDie objectAtIndex:(kWolfNumberOfSpritesDie - 1)]];
  self.view = self.gameObjView;
}

- (CGRect)frameInGameArea:(CGPoint)point {
  return CGRectMake(point.x + kWolfGameareaOffsetX, 
                    point.y + kWolfGameareaOffsetY, kWolfWidth, kWolfHeight);
}

@end
