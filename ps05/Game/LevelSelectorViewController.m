//
//  LevelSelectorViewController.m
//  Game
//
//  Created by Yang Shun Tay on 25/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "LevelSelectorViewController.h"

@implementation LevelSelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  level1Button = [UIButton buttonWithType:UIButtonTypeCustom];
  level1Button.frame = CGRectMake(0, 0, 75, 75);
  [level1Button addTarget:self 
                   action:@selector(loadLevel1) 
         forControlEvents:UIControlEventTouchUpInside];
  level1Button.backgroundColor = [UIColor clearColor];
  UIImage *level1ButtonImage = [UIImage imageNamed:@"button-level-1.png"];
  [level1Button setImage:level1ButtonImage forState:UIControlStateNormal];
  level1Button.center = CGPointMake(410, 370);
  [self.view addSubview:level1Button];

  level2Button = [UIButton buttonWithType:UIButtonTypeCustom];
  level2Button.frame = CGRectMake(0, 0, 75, 75);
  [level2Button addTarget:self 
                   action:@selector(loadLevel2) 
         forControlEvents:UIControlEventTouchUpInside];
  level2Button.backgroundColor = [UIColor clearColor];
  UIImage *level2ButtonImage = [UIImage imageNamed:@"button-level-2.png"];
  [level2Button setImage:level2ButtonImage forState:UIControlStateNormal];
  level2Button.center = CGPointMake(512, 370);
  [self.view addSubview:level2Button];
  
  level3Button = [UIButton buttonWithType:UIButtonTypeCustom];
  level3Button.frame = CGRectMake(0, 0, 75, 75);
  [level3Button addTarget:self 
                   action:@selector(loadLevel3) 
         forControlEvents:UIControlEventTouchUpInside];
  level3Button.backgroundColor = [UIColor clearColor];
  UIImage *level3ButtonImage = [UIImage imageNamed:@"button-level-3.png"];
  [level3Button setImage:level3ButtonImage forState:UIControlStateNormal];
  level3Button.center = CGPointMake(614, 370);
  [self.view addSubview:level3Button];
  
  backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  backButton.frame = CGRectMake(0, 0, 150, 75);
  [backButton addTarget:self 
                 action:@selector(backToMainScreen) 
       forControlEvents:UIControlEventTouchUpInside];
  backButton.backgroundColor = [UIColor clearColor];
  UIImage *backButtonImage = [UIImage imageNamed:@"button-back-pink.png"];
  [backButton setImage:backButtonImage forState:UIControlStateNormal];
  backButton.center = CGPointMake(512, 468);
  [self.view addSubview:backButton];
  
  savedLevelManager = [[FileDataController alloc] init];
}

- (void)loadLevel1 {
  [savedLevelManager loadSavedLevelWithFileName:@"1"];
  [self startLoadedLevel];
}

- (void)loadLevel2 {
  [savedLevelManager loadSavedLevelWithFileName:@"2"];
  [self startLoadedLevel];
}

- (void)loadLevel3 {
  [savedLevelManager loadSavedLevelWithFileName:@"3"];
  [self startLoadedLevel];
}

- (void)startLoadedLevel {

  wolf = savedLevelManager.wolfController;
  pig = savedLevelManager.pigController;
  blocks = savedLevelManager.blocksInGameArea;
  
  gameLevel = [[PlayViewController alloc] initWithWolf:wolf
                                                   Pig:pig
                                            Blocks:blocks];
  gameLevel.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentViewController:gameLevel animated:YES completion:^(void){}];
}

- (void)backToMainScreen {
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
