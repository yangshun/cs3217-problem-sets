//
//  WolfLives.m
//  Game
//
//  Created by Yang Shun Tay on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "WolfLives.h"

@implementation WolfLives

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithLives:(int)number {
  
  self = [super init];
  
  if (self) {
    
    lives = number;
    livesCount = [[NSMutableArray alloc] initWithCapacity:number];
    heartImage = [UIImage imageNamed:@"heart.png"];

  }
  return self; 
}

- (void)displayLives {
  
  CGFloat heartWidth = heartImage.size.width;
  CGFloat heartHeight = heartImage.size.height;
  
  for (int i = 0; i < lives; i++) {
    CGRect frame = CGRectMake(218 + i * (36 + 10), 131, heartWidth, heartHeight);
    UIImageView *heartImageView = [[UIImageView alloc] initWithImage:heartImage];
    heartImageView.frame = frame;
    [self.view addSubview:heartImageView];
    [livesCount addObject:heartImageView];
  }
}

- (void)deductLife {
  if (lives > 0) {
    lives--;
    [[livesCount objectAtIndex:lives] removeFromSuperview];
    [livesCount removeObjectAtIndex:lives];
  } else {
    [[NSNotificationCenter defaultCenter] performSelector:@selector(postNotificationName:object:) withObject:@"GameOver" afterDelay:1.5];
  }
  
  NSLog(@"%d", lives);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
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
