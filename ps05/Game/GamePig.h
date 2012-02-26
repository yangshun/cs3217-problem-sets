//
//  GamePig.h
//  Game
//
//  Created by Yang Shun Tay on 31/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"

#define kPigOriginPointInPaletteX 190
#define kPigOriginPointInPaletteY 50
#define kPigThumbnailSize 55
#define kPigNumberOfSpritesCry 10
#define kPigSpriteCryWidth 80
#define kPigSpriteCryHeight 80
#define kPigCenterPointInPaletteX 217.5
#define kPigCenterPointInPaletteY 77.5
#define kPigGameareaOffsetX -15
#define kPigGameareaOffsetY 10
#define kPigWidth 88
#define kPigHeight 88

@interface GamePig : GameObject {
  NSMutableArray *pigSprite;

}

- (id)init;
  // EFFECTS: object will appear in palette with the thumbnail size

- (id)initWithFrame:(CGRect)customFrame 
        andRotation:(CGFloat)rotation 
           andState:(BOOL)state;
  // EFFECTS: object will appear in gamearea at specified frame and rotation

- (UIImageView*)pigImageView:(CGRect)frame;
  // MODIFIES: self
  // EFFECTS: initializes the sprites for the pig animation and returns a 
  //          UIImageView of this GameObject subclass at the specified position

- (void)pigDieAnimation;
  // MODIFIES: self view
  // REQUIRES: pig to be hit by breathe / ground
  // EFFECTS: shows the pig dying animation

- (CGRect)frameInGameArea:(CGPoint)point;
  // EFFECTS: returns the size and position of the object in the gamearea

@end
