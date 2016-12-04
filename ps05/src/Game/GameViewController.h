//
//  GameViewController.h
//  Game
//
//  Created by Yang Shun Tay on 18/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "CloudFactory.h"
#import "DesignViewController.h"
#import "LevelSelectorViewController.h"

#define kIpadMiddlePointX 512
#define kGameLogoStartPointY -195
#define kGameLogoEndPointY 240
#define kStartGameButtonStartPointY 789
#define kStartGameButtonEndPointY 489
#define kDesignLevelButtonStartPointY 926
#define kDesignLevelButtonEndPointY 626

@interface GameViewController : UIViewController <UIAlertViewDelegate, 
                                                  AVAudioPlayerDelegate> {
  CloudFactory *cloudGenerator;
  UIImageView *gameLogo;
  UIButton *startGameButton;
  UIButton *designLevelButton;
  AVAudioPlayer *audioPlayer;
  BOOL playAudioOnNextCall;
}

- (void)startGame;
  // EFFECTS: changes view to the level selector

- (void)designLevel;
  // EFFECTS: changes view to the level designer

-(void)toggleMusic;
  // MODIFIES: background music
  // REQUIRES: background music to be initialized
  // EFFECTS: turns background music on/off


@end
