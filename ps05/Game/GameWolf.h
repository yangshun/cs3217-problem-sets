//
//  GameWolf.h
//  Game
//
//  Created by Yang Shun Tay on 28/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"

#define kWolfOriginPointInPaletteX 20
#define kWolfOriginPointInPaletteY 20
#define kWolfThumbnailWidth 150
#define kWolfThumbnailHeight 100
#define kWolfNumberOfSpritesBlow 15
#define kWolfNumberOfSpritesDie 16
#define kWolfSpriteDieWidth 237
#define kWolfSpriteDieHeight 185
#define kWolfCenterPointInPaletteX 95
#define kWolfCenterPointInPaletteY 70
#define kWolfGameareaOffsetX -35
#define kWolfGameareaOffsetY -10
#define kWolfWidth 225
#define kWolfHeight 150
#define kWolfScale 1.2
#define kWolfDieOffsetY -14

@interface GameWolf : GameObject {
  UIImage *wolfImage;
  UIImage *wolfDieImage;
  NSMutableArray *wolfSpriteBlow;
  NSMutableArray *wolfSpriteDie;
  int currentSpriteFrame;
  NSTimer *wolfBreatheTimer;
  BOOL dead;
}

- (id)init;
  // EFFECTS: object will appear in palette with the thumbnail size

- (id)initWithFrame:(CGRect)customFrame 
        andRotation:(CGFloat)rotation
           andState:(BOOL)state; 
  // EFFECTS: object will appear in gamearea at specified position and size

- (UIImageView*)wolfImageView:(CGRect)frame;
  // EFFECTS: initializes the sprites for the blowing wolf and dying wolf
  //          returns an UIImageView of this GameObject subclass at the specified position

- (void)startWolfBlow;
  // MODIFIES: self (view)
  // REQUIRES: fire button to be pressed
  // EFFECTS: wolf displays blowing animation

- (void)wolfBlowAnimation;
  // MODIFIES: current frame of the wolf image
  // REQUIRES: wolf breathe time to have been fired
  // EFFECTS: wolf view cycles through the blowing image sprites and tells the
  //          view controller to fire the breathe at the 12th frame

- (void)wolfDieAnimation;
  // MODIFIES: self (view)
  // REQUIRES: wolf to have ran out of lives
  // EFFECTS: wolf shows dying animation

- (void)wolfLieOnFloor;
  // MODIFIES: self (view)
  // REQUIRES: wolf to have displayed dying animation
  // EFFECTS: view of the wolf is set to the last frame

- (CGRect)frameInGameArea:(CGPoint)point;
  // EFFECTS: returns the size and position of the object in the gamearea


@property (nonatomic, strong) UIImage* wolfImage;

@end
