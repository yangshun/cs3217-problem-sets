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
  // default initializer
  // object will appear in palette
  blockType = kStrawBlockObject;
  gameBlocksArchive = [self initializeBlockImages];
  self = [super initWithObject:[self blockImageView:CGRectMake(300, 50, 55, 55) 
                                          withBlock:blockType]];
  if (self) {
    objectType = kGameObjectBlock;
    centerPointInPalette = CGPointMake(327.5, 77.5);
    [self addSingleTapGesture];
  }
  return self;
}

- (id)initWithFrame:(CGRect)customFrame 
        andRotation:(CGFloat)rotation 
       andBlockType:(blockObjectType)type {
  // custom initializer
  // object will appear in gamearea at specified frame, rotatation and block type
  blockType = type;
  gameBlocksArchive = [self initializeBlockImages];
  self = [super initWithObject:[self blockImageView:customFrame withBlock:type]];
  
  if (self) {
    objectType = kGameObjectBlock;
    centerPointInPalette = CGPointMake(327.5, 77.5);
    insideGameArea = YES;
    rotatedState = rotation;
    [self addSingleTapGesture];
    [self customRotation:rotation];
  }
  return self;
}

- (NSArray*)initializeBlockImages {
  // creates an NSArray of block images to be used
  UIImage* strawImage = [UIImage imageNamed:@"straw.png"];
  UIImage* woodImage = [UIImage imageNamed:@"wood.png"];
  UIImage* ironImage = [UIImage imageNamed:@"iron.png"];
  UIImage* stoneImage = [UIImage imageNamed:@"stone.png"];
  return [[NSArray alloc] initWithObjects:strawImage, 
           woodImage, ironImage, stoneImage, nil];
}

- (UIImageView*)blockImageView:(CGRect)frame withBlock:(blockObjectType)type {
  // returns a block image view of the correct position and type
  UIImageView *blockImageView = [[UIImageView alloc] 
                                 initWithImage:[gameBlocksArchive objectAtIndex: (int)type]];
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
  gameObjView.image = [gameBlocksArchive objectAtIndex:blockType];
}

- (CGRect)frameInGameArea:(CGPoint)point {
  return CGRectMake(point.x + 10, point.y - 40, 30, 130);
}


@end
