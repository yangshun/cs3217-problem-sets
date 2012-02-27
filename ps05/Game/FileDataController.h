//
//  FileDataController.h
//  Game
//
//  Created by Yang Shun Tay on 2/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"
#import "GameWolf.h"
#import "GamePig.h"
#import "GameBlock.h"

@interface FileDataController : UIViewController {
  
  GameWolf* wolfController;
  GamePig* pigController;
  GameBlock* blockController;
  NSMutableArray* blocksInGameArea;
  FileDataController *savedLevelManager;
  
}

- (NSString*)dataFilePath:(NSString*)name;
  // REQUIRES: a non-empty string to be keyed into levelName text field
  // EFFECTS: returns the file path 

- (void)saveDataToArchivesWithLevelName:(NSString*)name;
  // MODIFIES: archives
  // REQUIRES: file path to be valid
  // EFFECTS: saves the state of the current GameObjects

- (void)loadDataFromArchivesWithLevelName:(NSString*)name;
  // MODIFIES: GameObjects in self
  // REQUIRES: file path to be valid
  // EFFECTS: modifies the state of the current GameObjects in self 
  //          according to the saved state

- (void)loadSavedLevelWithFileName:(NSString*)name;
  // MODIFIES: GameObjects in self
  // REQUIRES: file path to be valid
  // EFFECTS: modifies the state of the current GameObjects in self
  //          according to the saved state in the application bundle

- (void)unarchiveDataFromFilePath:(NSString*)filePath;
  // MODIFIES: GameObjects in self
  // REQUIRES file path to be valid
  // EFFECTS: modifies the state of the GameObjects in self according to the 
  //          archived data given

@property (nonatomic, strong) GameWolf *wolfController;
@property (nonatomic, strong) GamePig *pigController;
@property (nonatomic, strong) GameBlock *blockController;
@property (nonatomic, strong) NSMutableArray *blocksInGameArea;

@end
