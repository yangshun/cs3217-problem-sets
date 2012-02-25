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
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  cloudGenerator = [[CloudFactory alloc] initCloudsWithTimeStep:0.02];
  [self.view addSubview:cloudGenerator.view];
  [cloudGenerator startGeneratingClouds];
  [self.view addSubview:cloudGenerator.view];
  
  UIImage *gameLogoImage = [UIImage imageNamed:@"game-logo.png"];
  gameLogo = [[UIImageView alloc] initWithImage:gameLogoImage];
  gameLogo.center = CGPointMake(512, -195);
  [self.view addSubview:gameLogo];
  
  startGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
  startGameButton.frame = CGRectMake(0, 0, 400, 100);
  [startGameButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
  startGameButton.backgroundColor = [UIColor clearColor];
  UIImage *startGameButtonImage = [UIImage imageNamed:@"button-start-game.png"];
  [startGameButton setImage:startGameButtonImage forState:UIControlStateNormal];
  [self.view addSubview:startGameButton];
  startGameButton.center = CGPointMake(512, 789);
  
  designLevelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  designLevelButton.frame = CGRectMake(0, 0, 400, 100);
  [designLevelButton addTarget:self action:@selector(designLevel) forControlEvents:UIControlEventTouchUpInside];
  designLevelButton.backgroundColor = [UIColor clearColor];
  UIImage *designLevelButtonImage = [UIImage imageNamed:@"button-design-level.png"];
  [designLevelButton setImage:designLevelButtonImage forState:UIControlStateNormal];
  [self.view addSubview:designLevelButton];
  designLevelButton.center = CGPointMake(512, 926);
  
  [UIView animateWithDuration:1.0
                   animations:^{ 
                     gameLogo.center = CGPointMake(512, 240);
                   } 
                   completion:^(BOOL finished){}];

  [UIView animateWithDuration:1.0
                   animations:^{ 
                     startGameButton.center = CGPointMake(512, 489);
                   } 
                   completion:^(BOOL finished){}];
    
  [UIView animateWithDuration:1.0
                   animations:^{ 
                     designLevelButton.center = CGPointMake(512, 626);
                   } 
                   completion:^(BOOL finished){}];
  
}

- (void)startGame {
  
  
}

- (void)designLevel {
  DesignViewController *designView = [[DesignViewController alloc] initWithNibName:nil bundle:nil];
  designView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentViewController:designView animated:YES completion:^(void){}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return YES;
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AcousticSunrise"
                                                       ofType:@"caf"];
  NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
  audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
  audioPlayer.delegate = self;
  [audioPlayer prepareToPlay];
  [audioPlayer setNumberOfLoops:INFINITY];
  [audioPlayer play];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self doVolumeFade];
}

-(void)doVolumeFade {  
  if (audioPlayer.volume > 0.1) {
    audioPlayer.volume = audioPlayer.volume - 0.1;
    [self performSelector:@selector(doVolumeFade) withObject:nil afterDelay:0.1];           
  } else {
    // Stop and get the sound ready for playing again
    [audioPlayer stop];
    audioPlayer.currentTime = 0;
    [audioPlayer prepareToPlay];
    audioPlayer.volume = 1.0;
  }
}

@end
