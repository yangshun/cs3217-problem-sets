//
//  ViewController.h
//  Game
//
//  Created by Yang Shun Tay on 18/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
  UIImageView* wolf;
  UIImageView* brick;
  UIImageView* pig;
}

- (IBAction)buttonPressed:(id)sender;
- (IBAction)wolfPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *gamearea;
@property (nonatomic, strong) IBOutlet UIImageView *wolf;
@property (nonatomic, strong) IBOutlet UIImageView *brick;
@property (nonatomic, strong) IBOutlet UIImageView *pig;

@end
