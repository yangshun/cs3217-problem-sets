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

@interface GameViewController : UIViewController <UIAlertViewDelegate, 
                                                  AVAudioPlayerDelegate> {
  
  CloudFactory *cloudGenerator;
  UIImageView *gameLogo;
  UIButton *startGameButton;
  UIButton *designLevelButton;
  AVAudioPlayer *audioPlayer;
  BOOL playAudioOnNextCall;
}

-(void)toggleMusic;


@end
