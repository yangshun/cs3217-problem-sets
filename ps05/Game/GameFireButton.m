//
//  GameFireButton.m
//  Game
//
//  Created by Yang Shun Tay on 20/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameFireButton.h"

@implementation GameFireButton

@synthesize buttonImage;

- (id)initWithFrame:(CGRect)customFrame {
  // EFFECTS: object will appear at specified frame
  self = [super initWithObject:[self buttonImageView:customFrame]];
  
  if (self) {
    insideGameArea = YES;
    [self.view removeGestureRecognizer:objDoubleTap];
    [self.view removeGestureRecognizer:objRotate];
    [self.view removeGestureRecognizer:objZoom];
    [self.view removeGestureRecognizer:objDrag];
    objSingleTap = [[UITapGestureRecognizer alloc] 
                    initWithTarget:self action:@selector(pressed:)];
    objSingleTap.delegate = self;
    objSingleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:objSingleTap];
    self.responseState = kAwaitingEvent;
  }
  return self;
}

- (UIImageView*)buttonImageView:(CGRect)frame {
  // EFFECTS: returns an UIImageView of this GameObject subclass at the specified position
  buttonImage = [UIImage imageNamed:@"fire-button.png"];
  buttonImagePressed = [UIImage imageNamed:@"fire-button-pressed.png"];
  
  UIImageView *buttonImageView = [[UIImageView alloc] initWithImage:buttonImage];
  buttonImageView.frame = frame;
  return buttonImageView;
}

- (void)pressed:(UITapGestureRecognizer*)gesture {
  // MODIFIES: play view controller
  // REQUIRES: the button to be pressed
  // EFFECTS: fires a projectile from the wolf's mouth
  if (responseState == kAwaitingEvent) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FireButtonPressed" object:nil];
    [self changeState];
  }
}

- (void)changeState {
  // MODIFIES: button image of self
  // EFFECTS: changes the button image, according to the current state
  if(responseState == kAwaitingEvent) {
    responseState = kEventOccurred;
    self.gameObjView.image = buttonImagePressed;
  } else {
    responseState = kAwaitingEvent;
    self.gameObjView.image = buttonImage;
  }
}


@end
