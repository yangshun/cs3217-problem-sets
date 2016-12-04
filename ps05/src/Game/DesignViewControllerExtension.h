//
//  DesignViewControllerExtension.h
//

#import "DesignViewController.h"

@interface DesignViewController (Extension)

- (void)startLevel;
  // REQUIRES: game in designer mode
  // EFFECTS: start the game, loading the arrow and the degree guide 

- (void)saveLevel;
  // REQUIRES: game in designer mode
  // EFFECTS: game objects are saved 

- (void)loadLevel;
  // MODIFIES: self (game objects)
  // REQUIRES: game in designer mode
  // EFFECTS: game objects are loaded

- (void)resetLevel;
  // MODIFIES: self (game objects)
  // REQUIRES: game in designer mode
  // EFFECTS: current game objects are deleted and palette contains all objects


@end
