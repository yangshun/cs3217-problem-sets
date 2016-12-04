//
//  GameBlock.h
//  Game
//
//  Created by Yang Shun Tay on 31/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"

#define kBlockOriginPointInPaletteX 300
#define kBlockOriginPointInPaletteY 50
#define kBlockThumbnailSize 55
#define kBlockNumberOfSpritesBreak 5
#define kBlockCenterPointInPaletteX 327.5
#define kBlockCenterPointInPaletteY 77.5
#define kBlockGameareaOffsetX 10
#define kBlockGameareaOffsetY -40
#define kBlockWidth 30
#define kBlockHeight 130

typedef enum {kStrawBlockObject, kWoodBlockObject, 
  kIronBlockObject, kStoneBlockObject} blockObjectType;

@interface GameBlock : GameObject {

  NSArray *gameBlocksArchive;
  blockObjectType blockType;
  UIImage *strawBreakImage;
  NSMutableArray *strawSpriteBreak;
  
  UITapGestureRecognizer *objSingleTap;
  BOOL destroyed;
}

- (id)init;
  // EFFECTS: object will appear in palette with the thumbnail size

- (id)initWithFrame:(CGRect)customFrame 
        andRotation:(CGFloat)rotation 
       andBlockType:(blockObjectType)type;
  // EFFECTS: initializes a GameBlock of the specified frame, rotation and type

- (NSArray*)initializeBlockImages;
  // MODIFIES: self (GameBlock)
  // EFFECTS: initializes the various images of the blocks

- (UIImageView*)blockImageView:(CGRect)frame withBlock:(blockObjectType)type;
  // EFFECTS: returns a block image view of the correct position and type

- (void)addSingleTapGesture;
  // MODIFIES: self (game objects)
  // EFFECTS: GameBlock will respond to single tap gestures

- (void)changeBlockType:(UITapGestureRecognizer*)gesture;
  // MODIFIES: self (GameBlock)
  // REQUIRES: GameBlock to be in gamearea
  // EFFECTS: changes the block type to a different material

- (void)strawBreakAnimation;
  // MODIFIES: self (GameBlock)
  // REQUIRES: block to be hit by breathe
  // EFFECTS: displays the straw breaking animation and removes self from superview

- (CGRect)frameInGameArea:(CGPoint)point;
  // EFFECTS: returns the size and position of the object in the gamearea

@property (nonatomic, readonly) blockObjectType blockType;

@end
