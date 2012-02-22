//
//  GameBlock.h
//  Game
//
//  Created by Yang Shun Tay on 31/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameObject.h"

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

- (id)initWithFrame:(CGRect)customFrame 
        andRotation:(CGFloat)rotation 
       andBlockType:(blockObjectType)type;
- (NSArray*)initializeBlockImages;
- (UIImageView*)blockImageView:(CGRect)frame withBlock:(blockObjectType)type;
- (void)addSingleTapGesture;
- (void)changeBlockType:(UITapGestureRecognizer*)gesture;
- (CGRect)frameInGameArea:(CGPoint)point;
- (void)strawBreakAnimation;

@property (nonatomic, readonly) blockObjectType blockType;

@end
