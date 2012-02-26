//
//  DesignViewController.h
//  Game
//
//  Created by Yang Shun Tay on 25/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"
#import "GameWolf.h"
#import "GamePig.h"
#import "GameBlock.h"

#import "FileDataController.h"
#import "PlayViewController.h"

#define START 1
#define SAVE 2
#define LOAD 3
#define RESET 4

@interface DesignViewController : UIViewController <UIAlertViewDelegate> {
  
  UIImageView* palette;
  
  GameWolf *wolfController;
  GamePig *pigController;
  GameBlock *blockController;
  
  GameObject *newObject;
  NSMutableArray *blocksInGameArea;
  FileDataController *fileDataManager;
  PlayViewController *playView;
  
  UIButton *backButton;
  UIButton *startButton;
  UIButton *resetButton;
  UIButton *loadButton;
  UIButton *saveButton;
}

- (void)dropView:(GameObject*)viewCall;
- (void)setUpPalette;

@property (nonatomic, weak) IBOutlet UIImageView *taskbar;
@property (nonatomic, weak) IBOutlet UITextField *levelName;
@property (nonatomic, weak) IBOutlet UIScrollView *gamearea;
@property (nonatomic, strong) IBOutlet UIImageView *palette;

@end
