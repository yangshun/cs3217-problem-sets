//
//  AppDelegate.h
//  Game
//
//  Created by Yang Shun Tay on 18/1/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
  UIViewController *mainController;
}

@property (strong, nonatomic) IBOutlet UIViewController *mainController;
@property (strong, nonatomic) UIWindow *window;

@end
