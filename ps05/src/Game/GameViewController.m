//
//  GameViewController.m
//  Game
//
//  Created by Yang Shun Tay on 18/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  NSLog(@"main screen received memory warning");
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  
  [super viewDidLoad];

  cloudGenerator = [[CloudFactory alloc] initWithTimeStep:0.05];
  [self.view addSubview:cloudGenerator.view];
  
  UIImage *gameLogoImage = [UIImage imageNamed:@"game-logo.png"];
  gameLogo = [[UIImageView alloc] initWithImage:gameLogoImage];
  gameLogo.center = CGPointMake(kIpadMiddlePointX, kGameLogoStartPointY);
  [self.view addSubview:gameLogo];
  
  UIImage *startGameButtonImage = [UIImage imageNamed:@"button-start-game.png"];
  startGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
  CGFloat startGameButtonWidth = startGameButtonImage.size.width;
  CGFloat startGameButtonHeight = startGameButtonImage.size.height;
  startGameButton.frame = CGRectMake(0, 0, startGameButtonWidth, startGameButtonHeight);
  [startGameButton addTarget:self 
                      action:@selector(startGame) 
            forControlEvents:UIControlEventTouchUpInside];
  startGameButton.backgroundColor = [UIColor clearColor];

  [startGameButton setImage:startGameButtonImage forState:UIControlStateNormal];
  [self.view addSubview:startGameButton];
  startGameButton.center = CGPointMake(kIpadMiddlePointX, kStartGameButtonStartPointY);
  
  UIImage *designLevelButtonImage = [UIImage imageNamed:@"button-design-level.png"];
  designLevelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  CGFloat designLevelButtonWidth = designLevelButtonImage.size.width;
  CGFloat designLevelButtonHeight = startGameButtonImage.size.height;
  designLevelButton.frame = CGRectMake(0, 0, designLevelButtonWidth, designLevelButtonHeight);
  [designLevelButton addTarget:self 
                        action:@selector(designLevel) 
              forControlEvents:UIControlEventTouchUpInside];
  designLevelButton.backgroundColor = [UIColor clearColor];
  [designLevelButton setImage:designLevelButtonImage forState:UIControlStateNormal];
  [self.view addSubview:designLevelButton];
  designLevelButton.center = CGPointMake(kIpadMiddlePointX, 
                                         kDesignLevelButtonStartPointY);
  
  [UIView animateWithDuration:1.0
                   animations:^{ 
                     gameLogo.center = CGPointMake(kIpadMiddlePointX, 
                                                   kGameLogoEndPointY);
                   } 
                   completion:^(BOOL finished){}];

  [UIView animateWithDuration:1.0
                   animations:^{ 
                     startGameButton.center = CGPointMake(kIpadMiddlePointX, kStartGameButtonEndPointY);
                   } 
                   completion:^(BOOL finished){}];
    
  [UIView animateWithDuration:1.0
                   animations:^{ 
                     designLevelButton.center = CGPointMake(kIpadMiddlePointX, 
                                                            kDesignLevelButtonEndPointY);
                   } 
                   completion:^(BOOL finished){}];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(toggleMusic) 
                                               name:@"ToggleMusic"
                                             object:nil];
  
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AcousticSunrise"
                                                       ofType:@"caf"];
  NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
  audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
  audioPlayer.delegate = self;
  [audioPlayer prepareToPlay];
  [audioPlayer setNumberOfLoops:INFINITY];
  [audioPlayer play];
  playAudioOnNextCall = NO;
  
}

- (void)startGame {
  // EFFECTS: changes view to the level selector
  LevelSelectorViewController *levelSelectorView = [[LevelSelectorViewController alloc] initWithNibName:nil bundle:nil];
  levelSelectorView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentViewController:levelSelectorView animated:YES completion:^(void){}];
}

- (void)designLevel {
  // EFFECTS: changes view to the level designer
  DesignViewController *designView = [[DesignViewController alloc] init];
  designView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentViewController:designView animated:YES completion:^(void){}];
}

-(void)toggleMusic { 
  // MODIFIES: background music
  // REQUIRES: background music to be initialized
  // EFFECTS: turns background music on/off
  if (!audioPlayer.playing) {
    [audioPlayer play];
  } else if (audioPlayer.volume >= 0.1) {
    audioPlayer.volume -= 0.1;
    [self performSelector:@selector(toggleMusic) withObject:nil afterDelay:0.1];           
  } else {
    // Stop and get the sound ready for playing again
    [audioPlayer stop];
    audioPlayer.currentTime = 0;
    [audioPlayer prepareToPlay];
    audioPlayer.volume = 1.0;
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [cloudGenerator createInitialClouds];
  [cloudGenerator startGeneratingClouds];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [cloudGenerator removeAllClouds];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return YES;
  }
}


@end
