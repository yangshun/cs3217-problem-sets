//
//  ViewController.m
//  Game
//
//  Created by Yang Shun Tay on 18/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize gamearea;
@synthesize wolf;
@synthesize pig;
@synthesize brick;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  UIImage *bgImage = [UIImage imageNamed:@"background.png"];
  UIImage *groundImage = [UIImage imageNamed:@"ground.png"];
  UIImage *paletteImage = [UIImage imageNamed:@"palette.png"];
  
  // Get the width and height of the two images
  CGFloat backgroundWidth = bgImage.size.width;
  CGFloat backgroundHeight = bgImage.size.height;
  CGFloat groundWidth = groundImage.size.width;
  CGFloat groundHeight = groundImage.size.height;
  CGFloat paletteWidth = paletteImage.size.width;
  CGFloat paletteHeight = paletteImage.size.height;
  
  
  // Place each of them in an UIImageView
  UIImageView *background = [[UIImageView alloc] initWithImage:bgImage];
  UIImageView *ground = [[UIImageView alloc] initWithImage:groundImage];
  UIImageView *palette = [[UIImageView alloc] initWithImage:paletteImage];
  
  CGFloat groundY = gamearea.frame.size.height - groundHeight;
  CGFloat backgroundY = groundY - backgroundHeight;
  CGFloat paletteY = 768 - backgroundHeight - groundHeight - paletteHeight;

  //the frame property holds the position and size of the views
  //the CGRectMake methods arguments are : x position, y position, width,
  //height. origin at top left hand corner, with positive y-axis downwards
  background.frame = CGRectMake(0, backgroundY, backgroundWidth, backgroundHeight);
  ground.frame = CGRectMake(0, groundY, groundWidth, groundHeight);
  palette.frame = CGRectMake(0, paletteY, paletteWidth, paletteHeight);
  
  printf("palette height = %lf", paletteY);
  
  //add these views as subviews of the gamearea.
  [gamearea addSubview:background];
  [gamearea addSubview:ground];
  //[self.view addSubview:palette];
  
  //set the content size so that gamearea is scrollable
  //otherwise it defaults to the current window size
  CGFloat gameareaHeight = backgroundHeight + groundHeight;
  CGFloat gameareaWidth = backgroundWidth;
  [gamearea setContentSize:CGSizeMake(gameareaWidth, gameareaHeight)];
}

- (void)viewDidUnload
{
  [self setGamearea:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

- (IBAction)buttonPressed:(id)sender {
  UIColor *newColor;
  UIButton *button = (UIButton*)sender;
  if ([button titleColorForState:UIControlStateNormal] == [UIColor blackColor]) {
    newColor = [UIColor lightGrayColor];
  } else {
    newColor = [UIColor blackColor];
  }
  [button setTitleColor:newColor forState:UIControlStateNormal];
}

- (IBAction)wolfPressed:(id)sender {
  NSLog(@"wolf button pressed");
  UIImage *wolfImage = [UIImage imageNamed:@"wolfSmall.png"];
  UIImageView *gameWolf = [[UIImageView alloc]initWithImage:wolfImage];
  CGRect newFrame = gameWolf.frame;
  newFrame.origin = CGPointMake(400, 400);
  gameWolf.frame = newFrame;
  [self.gamearea addSubview:gameWolf];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:touch.view];
	wolf.center = location;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *aTouch = [touches anyObject];
  CGPoint loc = [aTouch locationInView:self];
  CGPoint prevloc = [aTouch previousLocationInView:self];
  
  CGRect myFrame = self.frame;
  float deltaX = loc.x - prevloc.x;
  float deltaY = loc.y - prevloc.y;
  myFrame.origin.x += deltaX;
  myFrame.origin.y += deltaY;
  [self setFrame:myFrame];
}

@end
