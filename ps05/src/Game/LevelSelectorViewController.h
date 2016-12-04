//
//  LevelSelectorViewController.h
//  Game
//
//  Created by Yang Shun Tay on 25/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamePig.h"
#import "GameWolf.h"
#import "GameBlock.h"
#import "PlayViewController.h"
#import "FileDataController.h"

@interface LevelSelectorViewController : UIViewController {
  
  UIButton *level1Button;
  UIButton *level2Button;
  UIButton *level3Button;
  UIButton *backButton;

  GameWolf *wolf;
  GamePig *pig;
  NSMutableArray *blocks;
  
  PlayViewController *gameLevel;
  FileDataController *savedLevelManager;
}

- (void)loadLevel1;
  // REQUIRES: file called "1.txt" present
  // EFFECTS: loads the pre-designed level 1

- (void)loadLevel2; 
// REQUIRES: file called "2.txt" present
// EFFECTS: loads the pre-designed level 2

- (void)loadLevel3; 
  // REQUIRES: file called "3.txt" present
  // EFFECTS: loads the pre-designed level 3

- (void)startLoadedLevel;
  // REQUIRES: level to be loaded from file bundle
  // EFFECTS: starts playing the loaded level

- (void)backToMainScreen;
  // EFFECTS: returns to the starting screen
@end
