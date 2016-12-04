//
//  WolfLives.m
//  Game
//
//  Created by Yang Shun Tay on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "WolfLives.h"

@implementation WolfLives

- (id)initWithLives:(int)number {
  // EFFECTS: initializes the lives of the wolf depending on the parameter value
  self = [super init];
  
  if (self) {
    lives = number;
    livesCount = [[NSMutableArray alloc] init];
    heartImage = [UIImage imageNamed:@"heart.png"];
  }
  return self; 
}

- (void)displayLives {
  // MODIFIES: view
  // EFFECTS: view to display the number of hearts corresponding to the number of lives left
  CGFloat heartWidth = heartImage.size.width;
  CGFloat heartHeight = heartImage.size.height;
  
  for (int i = 0; i < lives; i++) {
    CGRect frame = CGRectMake(kHeartStartingPositionX + i * (heartWidth + kDistanceBetweenHearts), 
                              kHeartStartingPositionY, 
                              heartWidth, 
                              heartHeight);
    UIImageView *heartImageView = [[UIImageView alloc] initWithImage:heartImage];
    heartImageView.frame = frame;
    [self.view addSubview:heartImageView];
    [livesCount addObject:heartImageView];
  }
}

- (void)deductLife {
  // MODIFIES: self (number of lives)
  // REQUIRIES: wolf to have shot a breathe
  // EFFECTS: number of lives of wolf is reduced by one
  if (lives > 0) {
    lives = lives - 1;
    [[livesCount objectAtIndex:lives] removeFromSuperview];
    [livesCount removeObjectAtIndex:lives];
  } else {
    [[NSNotificationCenter defaultCenter] performSelector:@selector(postNotificationName:object:) 
                                               withObject:@"GameOver" afterDelay:1.5];
  }
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  NSLog(@"wolf lives board received memory warnings");
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
