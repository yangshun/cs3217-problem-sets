//
//  FileDataController.m
//  Game
//
//  Created by Yang Shun Tay on 2/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "FileDataController.h"

@implementation FileDataController

@synthesize wolfController;
@synthesize pigController;
@synthesize blockController;
@synthesize blocksInGameArea;

- (id)init {
  self = [super init];
  return self;
}

- (NSString *)dataFilePath:(NSString*)name {
  // REQUIRES: a non-empty string to be keyed into levelName text field
  // EFFECTS: returns the file path 
  NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
  NSString *documentsDirectory = [path objectAtIndex:0];
  return [documentsDirectory stringByAppendingPathComponent:name];
}

- (void)saveDataToArchivesWithLevelName:(NSString *)name {
  // MODIFIES: archives
  // REQUIRES: file path to be valid
  // EFFECTS: saves the state of the current GameObjects
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] 
                               initForWritingWithMutableData:data];
  [archiver encodeCGRect:wolfController.view.frame forKey:@"wolfFrame"];
  [archiver encodeFloat:wolfController.rotatedState forKey:@"wolfRot"];
  [archiver encodeBool:wolfController.insideGameArea forKey:@"wolfState"];
  
  [archiver encodeCGRect:pigController.view.frame forKey:@"pigFrame"];
  [archiver encodeFloat:pigController.rotatedState forKey:@"pigRot"];
  [archiver encodeBool:pigController.insideGameArea forKey:@"pigState"];
  
  [archiver encodeInt:[blocksInGameArea count] forKey:@"blockCount"];
  
  int blocksIter = 0;
  
  for (GameBlock* blockObj in blocksInGameArea) {
    [archiver encodeCGRect: blockObj.view.frame forKey:
      [NSString stringWithFormat:@"blockObjFrame%d", blocksIter]];
    [archiver encodeFloat: blockObj.rotatedState forKey:
      [NSString stringWithFormat:@"blockObjRot%d", blocksIter]];
    [archiver encodeInt: blockObj.blockType forKey:
      [NSString stringWithFormat:@"blockObjType%d", blocksIter]];
    blocksIter++;
  }
  
  [archiver finishEncoding];
  [NSKeyedArchiver archiveRootObject:data 
                              toFile:[self dataFilePath:(NSString*)name]];
}

-(void)loadDataFromArchivesWithLevelName:(NSString*)name {
  // MODIFIES: GameViewController view
  // REQUIRES: file path to be valid
  // EFFECTS: modifies the state of the current GameObjects according to the saved state
  NSMutableData *data;
  NSString *filePath = [self dataFilePath:name];
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
  }
  
  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] 
                                   initForReadingWithData:data];
  
  CGRect loadedWolfFrame = [unarchiver decodeCGRectForKey:@"wolfFrame"];
  CGFloat loadedWolfRotation = [unarchiver decodeFloatForKey:@"wolfRot"];
  BOOL loadedWolfState = [unarchiver decodeBoolForKey:@"wolfState"];
  
  wolfController = [[GameWolf alloc] initWithFrame:loadedWolfFrame
                                       andRotation:loadedWolfRotation 
                                          andState:loadedWolfState];
  
  CGRect loadedPigFrame = [unarchiver decodeCGRectForKey:@"pigFrame"];
  CGFloat loadedPigRotation = [unarchiver decodeFloatForKey:@"pigRot"];
  BOOL loadedPigState = [unarchiver decodeBoolForKey:@"pigState"];
  
  pigController = [[GamePig alloc] initWithFrame:loadedPigFrame 
                                     andRotation:loadedPigRotation 
                                        andState:loadedPigState];
  
  blockController = [[GameBlock alloc] init];
  
  int blocksCount = [unarchiver decodeIntForKey:@"blockCount"];
  
  blocksInGameArea = [[NSMutableArray alloc] initWithCapacity:blocksCount];

  for (int i = 0; i < blocksCount; i++) {
    CGRect tempBlockFrame = [unarchiver decodeCGRectForKey:
                             [NSString stringWithFormat:@"blockObjFrame%d", i]];
    CGFloat tempBlockRotation = [unarchiver decodeFloatForKey:
                                 [NSString stringWithFormat:@"blockObjRot%d", i]];
    blockObjectType tempBlockType = [unarchiver decodeIntForKey:
                                     [NSString stringWithFormat:@"blockObjType%d", i]];
    GameBlock *tempBlock = [[GameBlock alloc] initWithFrame:tempBlockFrame 
                                                andRotation:tempBlockRotation 
                                               andBlockType:tempBlockType];
    [blocksInGameArea addObject:tempBlock];
  }
  
  [unarchiver finishDecoding];
}

@end

