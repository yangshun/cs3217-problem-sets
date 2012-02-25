//
//  DesignViewController.m
//  Game
//
//  Created by Yang Shun Tay on 25/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "DesignViewController.h"
#import "DesignViewControllerExtension.h"

#define kIpadLandscapeHeight 768

@implementation DesignViewController

@synthesize taskbar;
@synthesize gamearea;
@synthesize palette;
@synthesize levelName;

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
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
  palette = [[UIImageView alloc] initWithImage:paletteImage];
  
  CGFloat groundY = gamearea.frame.size.height - groundHeight;
  CGFloat backgroundY = groundY - backgroundHeight;
  CGFloat paletteY = kIpadLandscapeHeight - backgroundHeight - groundHeight - paletteHeight;
  // The frame property holds the position and size of the views
  // The CGRectMake methods arguments are : x position, y position, width,
  // height. origin at top left hand corner, with positive y-axis downwards
  background.frame = CGRectMake(0, backgroundY, backgroundWidth, backgroundHeight);
  ground.frame = CGRectMake(0, groundY, groundWidth, groundHeight);
  palette.frame = CGRectMake(0, paletteY, paletteWidth, paletteHeight);
  palette.userInteractionEnabled = YES;
  [self.view addSubview:palette];

  backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  backButton.frame = CGRectMake(0, 0, 80, 39);
  [backButton addTarget:self action:@selector(backToMainScreen) forControlEvents:UIControlEventTouchUpInside];
  backButton.backgroundColor = [UIColor clearColor];
  UIImage *backButtonImage = [UIImage imageNamed:@"button-back.png"];
  [backButton setImage:backButtonImage forState:UIControlStateNormal];
  backButton.center = CGPointMake(50, 28);
  [taskbar addSubview:backButton];
  
  startButton = [UIButton buttonWithType:UIButtonTypeCustom];
  startButton.frame = CGRectMake(0, 0, 80, 39);
  [startButton addTarget:self action:@selector(startLevel) forControlEvents:UIControlEventTouchUpInside];
  startButton.backgroundColor = [UIColor clearColor];
  UIImage *startButtonImage = [UIImage imageNamed:@"button-start.png"];
  [startButton setImage:startButtonImage forState:UIControlStateNormal];
  startButton.center = CGPointMake(190, 28);
  [taskbar addSubview:startButton];
  
  resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
  resetButton.frame = CGRectMake(0, 0, 80, 39);
  [resetButton addTarget:self action:@selector(resetLevel) forControlEvents:UIControlEventTouchUpInside];
  resetButton.backgroundColor = [UIColor clearColor];
  UIImage *resetButtonImage = [UIImage imageNamed:@"button-reset.png"];
  [resetButton setImage:resetButtonImage forState:UIControlStateNormal];
  resetButton.center = CGPointMake(280, 28);
  [taskbar addSubview:resetButton];
  
  saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
  saveButton.frame = CGRectMake(0, 0, 80, 39);
  [saveButton addTarget:self action:@selector(saveLevel) forControlEvents:UIControlEventTouchUpInside];
  saveButton.backgroundColor = [UIColor clearColor];
  UIImage *saveButtonImage = [UIImage imageNamed:@"button-save.png"];
  [saveButton setImage:saveButtonImage forState:UIControlStateNormal];
  saveButton.center = CGPointMake(870, 28);
  [taskbar addSubview:saveButton];
  
  loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
  loadButton.frame = CGRectMake(0, 0, 80, 39);
  [loadButton addTarget:self action:@selector(loadLevel) forControlEvents:UIControlEventTouchUpInside];
  loadButton.backgroundColor = [UIColor clearColor];
  UIImage *loadButtonImage = [UIImage imageNamed:@"button-load.png"];
  [loadButton setImage:loadButtonImage forState:UIControlStateNormal];
  loadButton.center = CGPointMake(960, 28);
  [taskbar addSubview:loadButton];
    
  taskbar.userInteractionEnabled = YES;
  
  // Add these views as subviews of the gamearea.
  [gamearea addSubview:background];
  [gamearea addSubview:ground];
  
  // Set the content size so that gamearea is scrollable
  // otherwise it defaults to the current window size
  CGFloat gameareaHeight = backgroundHeight + groundHeight;
  CGFloat gameareaWidth = backgroundWidth;
  [gamearea setContentSize:CGSizeMake(gameareaWidth, gameareaHeight)];
  
  [self setUpPalette];
}

- (void)setUpPalette {
  // MODIFIES: subviews in palette view
  // REQUIRES: wolfController, pigController and blockController to be nil
  // EFFECTS: game objects are added to palette  
  wolfController = [[GameWolf alloc] init];
  wolfController.delegate = self;
  [palette addSubview: wolfController.view];
  wolfController.view.userInteractionEnabled = YES;
  wolfController.view.multipleTouchEnabled = YES;
  
  pigController = [[GamePig alloc] init];
  pigController.delegate = self;
  [palette addSubview: pigController.view];
  pigController.view.userInteractionEnabled = YES;
  pigController.view.multipleTouchEnabled = YES;
  
  blockController = [[GameBlock alloc] init];
  blockController.delegate = self;
  [palette addSubview: blockController.view];
  blockController.view.userInteractionEnabled = YES;
  blockController.view.multipleTouchEnabled = YES;
  
  blocksInGameArea = [[NSMutableArray alloc] init];
  fileDataManager = [[FileDataController alloc] init];
}

- (void)scrollViewDisabled {
  // MODIFIES: scrolling ability of scrollview
  // REQUIRES: GameObject to be in panning mode
  // EFFECTS: disables the scrolling ability of gamearea
  gamearea.scrollEnabled = NO;
}

- (void)scrollViewEnabled {
  // MODIFIES: scrolling ability of scrollview
  // REQUIRES: GameObject to have ended panning mode
  // EFFECTS: enables the scrolling ability of gamearea
  gamearea.scrollEnabled = YES;
}

- (void)dropView:(GameObject*)viewCaller {
  // MODIFIES: gamearea scrollview
  // REQUIRES: GameObject to be out of the palette 
  // EFFECTS: transfers from view from the palette to the point of release in gamearea
  CGRect newSize;
  CGPoint newOrigin = [viewCaller.gameObjView.superview 
                       convertPoint:viewCaller.gameObjView.frame.origin toView: gamearea];
  
  switch ((int)viewCaller.objectType) {
    case kGameObjectWolf:
      newSize = [(GameWolf*)viewCaller frameInGameArea:newOrigin];
      break;
    case kGameObjectPig:
      newSize = [(GamePig*)viewCaller frameInGameArea:newOrigin];
      break;
    case kGameObjectBlock:
      newSize = [(GameBlock*)viewCaller frameInGameArea:newOrigin];
      break;
  }
  
  viewCaller.view.frame = gamearea.frame;
  
  // create a new GameBlock object to be placed in the palette
  if (viewCaller.objectType == kGameObjectBlock) {
    [blocksInGameArea addObject:blockController];
    GameBlock* newBlockController = [[GameBlock alloc] init];
    newBlockController.delegate = self;
    [palette addSubview: newBlockController.view];
    newBlockController.view.userInteractionEnabled = YES;
    newBlockController.view.multipleTouchEnabled = YES;
    blockController = newBlockController;
  }
  
  // adds the new object into the gamearea and modifying its properties
  [gamearea addSubview: viewCaller.view];
  viewCaller.view = viewCaller.gameObjView;
  viewCaller.gameObjView.frame = newSize;
  viewCaller.gameObjView.exclusiveTouch = YES;
  viewCaller.gameObjView.userInteractionEnabled = YES;
  viewCaller.insideGameArea = YES;
}

- (void)returnViewToPalette:(GameObject*)viewCaller {
  // MODIFIES: state and position of GameObject
  // REQUIRES: GameObject to in the gamearea
  // EFFECTS: removes GameObject from gamearea and creates a new one in the palette
  [viewCaller.view removeFromSuperview];
  
  switch ((int)viewCaller.objectType) {
    case kGameObjectWolf:
      newObject = [[GameWolf alloc] init];
      break;
    case kGameObjectPig:
      newObject = [[GamePig alloc] init];
      break;
    case kGameObjectBlock:
      newObject = nil;
      break;
    default:
      break;
  }
  
  newObject.delegate = self;
  [palette addSubview: newObject.view];
  newObject.view.userInteractionEnabled = YES;
  newObject.view.multipleTouchEnabled = YES;
  
  switch ((int)viewCaller.objectType) {
    case kGameObjectWolf:
      wolfController = (GameWolf*)newObject;
      break;
    case kGameObjectPig:
      pigController = (GamePig*)newObject;
      break;
    case kGameObjectBlock:
      for (int i = 0; i < [blocksInGameArea count]; i++) {
        if ([[blocksInGameArea objectAtIndex:i] isEqual:viewCaller]) {
          [blocksInGameArea removeObjectAtIndex:i];
        }
      }
      break;
    default:
      break;
  }
  
  viewCaller = nil;
}

- (void)clearAllObjectsFromView {
  // MODIFIES: all GameObjects
  // EFFECTS: removes all GameObject from both gamearea and palette
  if (wolfController) {
    [wolfController.view removeFromSuperview];
    wolfController = nil;
  }
  if (pigController) {
    [pigController.view removeFromSuperview];
    pigController = nil;
  }
  if (blockController) {
    [blockController.view removeFromSuperview];
    blockController = nil;
  }
  if (blocksInGameArea) {
    for (int i = 0; i < [blocksInGameArea count]; i++) {
      [((GameBlock*)[blocksInGameArea objectAtIndex:i]).view removeFromSuperview];
      GameBlock *temp = [blocksInGameArea objectAtIndex:i];
      temp = nil;
    }
    [blocksInGameArea removeAllObjects];
    blocksInGameArea = nil;
  }
}

- (void)startLevel {
  
  if (!wolfController.insideGameArea || !pigController.insideGameArea) {
    UIAlertView *invalidGameStartAlert = [[UIAlertView alloc] 
                                          initWithTitle:@"Cannot start game"
                                          message:@"Make sure both the wolf and the pig are in the game area" 
                                          delegate:nil 
                                          cancelButtonTitle:@"Back" 
                                          otherButtonTitles:nil];
    [invalidGameStartAlert show];
    return;
  }
  
  playView = [[PlayViewController alloc] initWithWolf:wolfController 
                                                  Pig:pigController
                                               Blocks:blocksInGameArea];
  playView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentViewController:playView animated:YES completion:^(void){}];
}

- (void)proceedToSaveLevel {
  // MODIFIES: save data
  // EFFECTS: properties of all the GameObject controllers are saved in FileDataController object
  fileDataManager.wolfController = wolfController;
  fileDataManager.pigController = pigController;
  fileDataManager.blockController = blockController;
  
  for (GameBlock* blockObj in blocksInGameArea) {
    [blockObj customRotation:-blockObj.rotatedState];
  }
  
  fileDataManager.blocksInGameArea = blocksInGameArea;
  
  [fileDataManager saveDataToArchivesWithLevelName:levelName.text];
  
  for (GameBlock* blockObj in blocksInGameArea) {
    [blockObj customRotation:blockObj.rotatedState];
  }
}

- (void)saveLevel {
  // REQUIRES: game in designer mode
  // EFFECTS: game objects are saved
  // Empty string in levelName text field
  if ([levelName.text isEqualToString:@""]) {
    UIAlertView *noLevelNameAlert = [[UIAlertView alloc] 
                                     initWithTitle:@"No level name entered"
                                     message:@"Please specify a level name." 
                                     delegate:nil 
                                     cancelButtonTitle:@"Back" 
                                     otherButtonTitles:nil];
    [noLevelNameAlert show];
    return;
  }
  
  NSString *filePath = [fileDataManager dataFilePath:levelName.text];
  
  // Query if an existing file should be modified
  if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    UIAlertView *existingLevelAlert = [[UIAlertView alloc] 
                                       initWithTitle:@"Level exists" 
                                       message:@"There is an existing level with the same name.Overwrite save file?" 
                                       delegate:self 
                                       cancelButtonTitle:@"No" 
                                       otherButtonTitles:@"Yes",nil];
    [existingLevelAlert becomeFirstResponder];
    [existingLevelAlert show];
  } else { 
    [self proceedToSaveLevel];
  }
}

- (void)loadLevel {
  // MODIFIES: self (game objects)
  // REQUIRES: game in designer mode
  // EFFECTS: game objects are loaded
  // Empty string in levelName text field
  if ([levelName.text isEqualToString:@""]) {
    UIAlertView *noLevelNameAlert = [[UIAlertView alloc] 
                                     initWithTitle:@"No level name entered"
                                     message:@"Please specify a level name." 
                                     delegate:nil 
                                     cancelButtonTitle:@"Back" 
                                     otherButtonTitles:nil];
    [noLevelNameAlert show];
    return;
  }
  
  NSString *filePath = [fileDataManager dataFilePath:levelName.text];
  
  // Alert to notify user that he is trying to load from a non-existent file
  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    UIAlertView *noLevelAlert = [[UIAlertView alloc] 
                                 initWithTitle:@"Level not found" 
                                 message:@"There is no level with such a name" 
                                 delegate:nil 
                                 cancelButtonTitle:@"Back" 
                                 otherButtonTitles:nil];
    [noLevelAlert show];
    return;
  }
  
  [self clearAllObjectsFromView];
  
  [fileDataManager loadDataFromArchivesWithLevelName:levelName.text];
  
  // Set the attributes for all the GameObjects
  wolfController = fileDataManager.wolfController;
  wolfController.delegate = self;
  
  if (wolfController.insideGameArea) {
    [gamearea addSubview:wolfController.view];
  } else {
    [palette addSubview:wolfController.view];
  }
  
  wolfController.view.userInteractionEnabled = YES;
  wolfController.view.multipleTouchEnabled = YES;
  
  pigController = fileDataManager.pigController;
  pigController.delegate = self;
  
  if (pigController.insideGameArea) {
    [gamearea addSubview:pigController.view];
  } else {
    [palette addSubview:pigController.view];
  }
  
  pigController.view.userInteractionEnabled = YES;
  pigController.view.multipleTouchEnabled = YES;
  
  blockController = [[GameBlock alloc] init];
  [palette addSubview:blockController.view];
  blockController.delegate = self;
  
  blockController.view.userInteractionEnabled = YES;
  blockController.view.multipleTouchEnabled = YES;
  
  blocksInGameArea = fileDataManager.blocksInGameArea;
  for (GameBlock *block in blocksInGameArea) {
    [gamearea addSubview:block.view];
    block.delegate = self;
    block.view.userInteractionEnabled = YES;
    block.view.multipleTouchEnabled = YES;
  }
}

- (void)resetLevel {
  // MODIFIES: self (game objects)
  // REQUIRES: game in designer mode
  // EFFECTS: current game objects are deleted and palette contains all objects
  [self clearAllObjectsFromView];
  [self setUpPalette];
}

- (void)backToMainScreen {
  self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
  if ([title isEqualToString:@"Yes"]) {
    [self proceedToSaveLevel];  
  }
  [alertView resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return YES;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  playView = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

@end
