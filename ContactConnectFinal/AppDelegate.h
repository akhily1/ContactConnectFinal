//
//  ViewAppDelegate.h
//  LibSoundCloud
//
//  Created by Stofkat.org on 23-05-14.
//  Copyright (c) 2014 Stofkat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <Google/SignIn.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *mainViewController;


@end
