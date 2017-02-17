//
//  AppDelegate.m
//  ContactConnectFinal
//
//  Created by Akhil Yeleswar on 7/6/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "SoundCloud.h"
#import "BZFoursquare.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [Fabric with:@[[Twitter class]]];

    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    return YES;
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if Info.plist specifies a protocol to handle }

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if([[url scheme] isEqualToString:@"fb1738270703087924"]) {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                            sourceApplication:sourceApplication
                                                                   annotation:annotation
                        ];
        // Add any custom logic here.
        return handled;
    }
    
    if ([[url scheme] isEqualToString:@"fsqdemo"])
    {
        UINavigationController *navigationController = (UINavigationController *)_window.rootViewController;
        ViewController *ViewController = [[navigationController viewControllers] lastObject];
        BZFoursquare *foursquare = ViewController.foursquare;
        return [foursquare handleOpenURL:url];

      
    } else if ([[url scheme] isEqualToString:@"com.googleusercontent.apps.240189251154-gfbhqsn43ad9va3dq7s0vo8cgg2uff3u"]) {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                                   annotation:annotation];
    }
    // Instagram call back checking.
    else
    {
        if (!url) {
            return NO;
        } else {
            
            [self checkForSoundCloudLogin:url.absoluteString];
            //do your other custom url handling here
            
            return YES;
        }
         
    }
    
  
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    // ...
}
-(void) checkForSoundCloudLogin :(NSString *) url
{
    if( [url rangeOfString:REDIRECT_URI].location!=NSNotFound)
    {
        NSLog(@"Found oauth");
        //NSArray *tokenArray =[url componentsSeparatedByString:@"token"];
        NSArray *codeArray =[url componentsSeparatedByString:@"code="];
        NSLog(@"If logging in does not work, please look for this log message and check if the code is being stored correctly");
        if(codeArray.count>1) {
            NSString *code = codeArray[1];
            if([code hasSuffix:@"#"])code = [code substringToIndex:code.length-1];
            NSLog(@"Found login code for SoundCloud");
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:SC_CODE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
