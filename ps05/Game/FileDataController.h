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
- (void)saveDataToArchivesWithLevelName:(NSString*)name;
- (void)loadDataFromArchivesWithLevelName:(NSString*)name;
- (void)loadSavedLevelWithFileName:(NSString*)name;
- (void)unarchiveDataFromFilePath:(NSString*)filePath;

@property (nonatomic, strong) GameWolf *wolfController;
@property (nonatomic, strong) GamePig *pigController;
@property (nonatomic, strong) GameBlock *blockController;
@property (nonatomic, strong) NSMutableArray *blocksInGameArea;

@end
