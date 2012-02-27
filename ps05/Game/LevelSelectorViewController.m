//
//  LevelSelectorViewController.m
//  Game
//
//  Created by Yang Shun Tay on 25/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "LevelSelectorViewController.h"

#define kButton1CenterX 410
#define kButton1CenterY 370
#define kButton2CenterX 512
#define kButton2CenterY 370
#define kButton3CenterX 614
#define kButton3CenterY 370
#define kBackButtonWidth 150
#define kBackButtonHeight 75
#define kBackButtonCenterX 512
#define kBackButtonCenterY 468

@implementation LevelSelectorViewController

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  NSLog(@"level selector view received memory warning");
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  UIImage *level1ButtonImage = [UIImage imageNamed:@"button-level-1.png"];
  CGFloat level1ButtonWidth = level1ButtonImage.size.width;
  CGFloat level1ButtonHeight = level1ButtonImage.size.height;
  level1Button = [UIButton buttonWithType:UIButtonTypeCustom];
  level1Button.frame = CGRectMake(0, 0, level1ButtonWidth, level1ButtonHeight);
  [level1Button addTarget:self 
                   action:@selector(loadLevel1) 
         forControlEvents:UIControlEventTouchUpInside];
  level1Button.backgroundColor = [UIColor clearColor];
  [level1Button setImage:level1ButtonImage forState:UIControlStateNormal];
  level1Button.center = CGPointMake(kButton1CenterX, kButton1CenterY);
  [self.view addSubview:level1Button];
  
  UIImage *level2ButtonImage = [UIImage imageNamed:@"button-level-2.png"];
  CGFloat level2ButtonWidth = level2ButtonImage.size.width;
  CGFloat level2ButtonHeight = level2ButtonImage.size.height;
  level2Button = [UIButton buttonWithType:UIButtonTypeCustom];
  level2Button.frame = CGRectMake(0, 0, level2ButtonWidth, level2ButtonHeight);
  [level2Button addTarget:self 
                   action:@selector(loadLevel2) 
         forControlEvents:UIControlEventTouchUpInside];
  level2Button.backgroundColor = [UIColor clearColor];
  [level2Button setImage:level2ButtonImage forState:UIControlStateNormal];
  level2Button.center = CGPointMake(kButton2CenterX, kButton2CenterY);
  [self.view addSubview:level2Button];
  
  UIImage *level3ButtonImage = [UIImage imageNamed:@"button-level-3.png"];
  CGFloat level3ButtonWidth = level3ButtonImage.size.width;
  CGFloat level3ButtonHeight = level3ButtonImage.size.height;
  level3Button = [UIButton buttonWithType:UIButtonTypeCustom];
  level3Button.frame = CGRectMake(0, 0, level3ButtonWidth, level3ButtonHeight);
  [level3Button addTarget:self 
                   action:@selector(loadLevel3) 
         forControlEvents:UIControlEventTouchUpInside];
  level3Button.backgroundColor = [UIColor clearColor];
  [level3Button setImage:level3ButtonImage forState:UIControlStateNormal];
  level3Button.center = CGPointMake(kButton3CenterX, kButton3CenterY);
  [self.view addSubview:level3Button];
  
  backButton = [UIButton buttonWithType:UIButtonTypeCustom];

  backButton.frame = CGRectMake(0, 0, kBackButtonWidth, kBackButtonHeight);
  [backButton addTarget:self 
                 action:@selector(backToMainScreen) 
       forControlEvents:UIControlEventTouchUpInside];
  backButton.backgroundColor = [UIColor clearColor];
  UIImage *backButtonImage = [UIImage imageNamed:@"button-back-pink.png"];
  [backButton setImage:backButtonImage forState:UIControlStateNormal];
  backButton.center = CGPointMake(kBackButtonCenterX, kBackButtonCenterY);
  [self.view addSubview:backButton];

}

- (void)loadLevel1 {
  // REQUIRES: file called "1.txt" present
  // EFFECTS: loads the pre-designed level 1
  savedLevelManager = [[FileDataController alloc] init];
  [savedLevelManager loadSavedLevelWithFileName:@"1"];
  [self startLoadedLevel];
}

- (void)loadLevel2 {
  // REQUIRES: file called "2.txt" present
  // EFFECTS: loads the pre-designed level 2
  savedLevelManager = [[FileDataController alloc] init];
  [savedLevelManager loadSavedLevelWithFileName:@"2"];
  [self startLoadedLevel];
}

- (void)loadLevel3 {  
  // REQUIRES: file called "3.txt" present
  // EFFECTS: loads the pre-designed level 3
  savedLevelManager = [[FileDataController alloc] init];
  [savedLevelManager loadSavedLevelWithFileName:@"3"];
  [self startLoadedLevel];
}

- (void)startLoadedLevel {
  // REQUIRES: level to be loaded from file bundle
  // EFFECTS: starts playing the loaded level
  wolf = savedLevelManager.wolfController;
  pig = savedLevelManager.pigController;
  blocks = savedLevelManager.blocksInGameArea;
  
  gameLevel = [[PlayViewController alloc] initWithWolf:wolf
                                                   Pig:pig
                                                Blocks:blocks];
  gameLevel.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentViewController:gameLevel animated:YES completion:^(void){}];
  savedLevelManager = nil;
}

- (void)backToMainScreen {
  // EFFECTS: returns to the starting screen
  self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self dismissViewControllerAnimated:YES completion:^(void){}]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
