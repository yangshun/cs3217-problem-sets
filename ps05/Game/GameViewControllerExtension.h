//
//  GameViewControllerExtension.h
//

#import "GameViewController.h"

@interface GameViewController (Extension)

- (void)start;
  // REQUIRES: game in designer mode
  // EFFECTS: start the game, loading the arrow and the degree guide 

- (void)save;
  // REQUIRES: game in designer mode
  // EFFECTS: game objects are saved 

- (void)load;
  // MODIFIES: self (game objects)
  // REQUIRES: game in designer mode
  // EFFECTS: game objects are loaded

- (void)reset;
  // MODIFIES: self (game objects)
  // REQUIRES: game in designer mode
  // EFFECTS: current game objects are deleted and palette contains all objects


@end
