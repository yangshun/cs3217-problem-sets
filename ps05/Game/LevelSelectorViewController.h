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

- (void)startLoadedLevel;

@end
