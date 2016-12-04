//
//  GameBlock.m
//  Game
//
//  Created by Yang Shun Tay on 31/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameBlock.h"

@implementation GameBlock

@synthesize blockType;

- (id)init {
  // EFFECTS: object will appear in palette with the thumbnail size
  blockType = kStrawBlockObject;
  gameBlocksArchive = [self initializeBlockImages];
  self = [super initWithObject:[self blockImageView:CGRectMake(kBlockOriginPointInPaletteX,
                                                               kBlockOriginPointInPaletteY,
                                                               kBlockThumbnailSize,
                                                               kBlockThumbnailSize) 
                                          withBlock:blockType]];
  if (self) {
    objectType = kGameObjectBlock;
    centerPointInPalette = CGPointMake(kBlockCenterPointInPaletteX, kBlockCenterPointInPaletteY);
    [self addSingleTapGesture];
  }
  return self;
}

- (id)initWithFrame:(CGRect)customFrame 
        andRotation:(CGFloat)rotation 
       andBlockType:(blockObjectType)type {
  // EFFECTS: initializes a GameBlock of the specified frame, rotation and type
  blockType = type;
  gameBlocksArchive = [self initializeBlockImages];
  self = [super initWithObject:[self blockImageView:customFrame withBlock:type]];
  
  if (self) {
    objectType = kGameObjectBlock;
    centerPointInPalette = CGPointMake(kBlockCenterPointInPaletteX, kBlockCenterPointInPaletteY);
    insideGameArea = YES;
    rotatedState = rotation;
    [self addSingleTapGesture];
    [self customRotation:rotation];
  }
  return self;
}

- (NSArray*)initializeBlockImages {
  // MODIFIES: self (GameBlock)
  // EFFECTS: initializes the various images of the blocks
  UIImage* strawImage = [UIImage imageNamed:@"straw.png"];
  UIImage* woodImage = [UIImage imageNamed:@"wood.png"];
  UIImage* ironImage = [UIImage imageNamed:@"iron.png"];
  UIImage* stoneImage = [UIImage imageNamed:@"stone.png"];
  
  return [[NSArray alloc] initWithObjects:strawImage, 
           woodImage, ironImage, stoneImage, nil];
}

- (UIImageView*)blockImageView:(CGRect)frame withBlock:(blockObjectType)type {
  // EFFECTS: returns a block image view of the correct position and type
  UIImageView *blockImageView = [[UIImageView alloc] 
                                 initWithImage:[gameBlocksArchive objectAtIndex: (int)type]];
  
  strawSpriteBreak = [[NSMutableArray alloc] init];
  strawBreakImage = [UIImage imageNamed:@"straw-break.png"];
  
  CGFloat spriteWidth = strawBreakImage.size.width / 5;
  CGFloat spriteHeight = strawBreakImage.size.height;
  
  for (int i = 0; i < kBlockNumberOfSpritesBreak; i++) {
    CGRect spriteFrame = CGRectMake(spriteWidth * i, 0, spriteWidth, spriteHeight);
    CGImageRef strawImageRef = CGImageCreateWithImageInRect([strawBreakImage CGImage], spriteFrame);
    UIImage *croppedStrawImage = [UIImage imageWithCGImage:strawImageRef];
    [strawSpriteBreak addObject:croppedStrawImage];
    CGImageRelease(strawImageRef);
  } 
  blockImageView.frame = frame;
  return blockImageView;
}

- (void)removeAllGestureRecognizers {
  [super removeAllGestureRecognizers];
  [self.view removeGestureRecognizer:objSingleTap];
}

- (void)addSingleTapGesture {
  // MODIFIES: self (game objects)
  // EFFECTS: GameBlock will respond to single tap gestures
  objSingleTap = [[UITapGestureRecognizer alloc] 
                  initWithTarget:self action:@selector(changeBlockType:)];
  
  objSingleTap.delegate = self;
  objSingleTap.numberOfTapsRequired = 1;
  [self.view addGestureRecognizer:objSingleTap];
  [objSingleTap requireGestureRecognizerToFail : objDoubleTap];
}

- (void)changeBlockType:(UITapGestureRecognizer*)gesture {
  // MODIFIES: self (GameBlock)
  // REQUIRES: GameBlock to be in gamearea
  // EFFECTS: changes the block type to a different material
  if (!insideGameArea) {
    return;
  }
  switch (blockType) {
    case kStrawBlockObject:
      blockType = kWoodBlockObject;
      break;
    case kWoodBlockObject:
      blockType = kIronBlockObject;
      break;
    case kIronBlockObject:
      blockType = kStoneBlockObject;
      break;
    case kStoneBlockObject:
      blockType = kStrawBlockObject;
      break;
  }
  self.gameObjView.image = [gameBlocksArchive objectAtIndex:blockType];
}

- (void)strawBreakAnimation {
  // MODIFIES: self (GameBlock)
  // REQUIRES: block to be hit by breathe
  // EFFECTS: displays the straw breaking animation and removes self from superview
  if (objectState == kGameAlive) {
    [self customRotation:-rotatedState];
    self.gameObjView = [[UIImageView alloc] initWithImage:[strawSpriteBreak objectAtIndex:0]];
    self.gameObjView.animationImages = strawSpriteBreak;
    [self customRotation:rotatedState];
    self.gameObjView.animationDuration = 1.0;
    self.gameObjView.animationRepeatCount = 1;
    
    [self.gameObjView startAnimating];
    self.view = self.gameObjView;
    [self performSelector:@selector(destroyObject) withObject:nil afterDelay:1.0];
    objectState = kGameDead;
  }
}

- (CGRect)frameInGameArea:(CGPoint)point {
  // EFFECTS: returns the size and position of the object in the gamearea
  return CGRectMake(point.x + kBlockGameareaOffsetX, 
                    point.y + kBlockGameareaOffsetY,
                    kBlockWidth,
                    kBlockHeight);
}


@end
