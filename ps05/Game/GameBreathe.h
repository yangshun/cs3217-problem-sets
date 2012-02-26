//
//  GameBreathe.h
//  Game
//
//  Created by Yang Shun Tay on 20/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"

#define kBreatheNumberOfSpritesTravel 4
#define kBreatheNumberOfSpritesDisperse 10
#define kBreatheWidth 113
#define kBreatheHeight 104
#define kBreatheDisperseWidth 253
#define kBreatheDisperseHeight 259

@interface GameBreathe : GameObject {
  UIImage *breatheImage;
  UIImage *breatheDisperseImage;
  NSMutableArray *breatheSprite;
  NSMutableArray *breatheSpriteDisperse;
  NSTimer *breatheTimer;
}

- (id)initWithFrame:(CGRect)customFrame;
  // EFFECTS: object will appear in gamearea at specified frame

- (UIImageView*)breatheImageView:(CGRect)frame;
  // EFFECTS: initializes the sprites for the travelling breathe and dispersing breathe
  //          returns an UIImageView of this GameObject subclass at the specified position

- (void)breatheTravelAnimation; 
  // MODIFIES: self (GameBreathe)
  // EFFECTS: the view will start animating

- (void)breatheDisperseAnimation;
  // MODIFIES: self (GameBreathe)
  // EFFECTS: the view will show the disperse animation and remove itself from subview

@property (nonatomic, strong) UIImage *breatheImage;

@end
