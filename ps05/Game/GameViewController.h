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

@interface GameViewController : UIViewController <UIAlertViewDelegate, 
                                                  AVAudioPlayerDelegate> {
  
  CloudFactory *cloudGenerator;
  UIImageView *gameLogo;
  UIButton *startGameButton;
  UIButton *designLevelButton;
  AVAudioPlayer *audioPlayer;
}

-(void)doVolumeFade;


@end
