//
//  Copyright (c) Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
#import "GoogleSee.h"

@implementation GoogleSee

// [START viewdidload]
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO(developer) Configure the sign-in button look/feel
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
    // [START_EXCLUDE silent]
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveToggleAuthUINotification:)
     name:@"ToggleAuthUINotification"
     object:nil];
    GIDSignIn*sigNIn=[GIDSignIn sharedInstance];
    [sigNIn setDelegate:self];
    [sigNIn setUiDelegate:self];
    sigNIn.shouldFetchBasicProfile = YES;
    sigNIn.scopes = @[@"https://www.googleapis.com/auth/plus.login",@"https://www.googleapis.com/auth/userinfo.email",@"https://www.googleapis.com/auth/userinfo.profile"];
    sigNIn.clientID =@"240189251154-gfbhqsn43ad9va3dq7s0vo8cgg2uff3u.apps.googleusercontent.com";
    [sigNIn signIn];
    // [END_EXCLUDE]
}
// [END viewdidload]

// Signs the user out of the application for scenarios such as switching
// profiles.
// [START signout_tapped]


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSLog(@"%@", user);
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *name = user.profile.name;
    NSString *email = user.profile.email;
    NSLog(@"Customer details: %@ %@ %@ %@", userId, idToken, name, email);
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"ToggleAuthUINotification"
     object:nil];
    
}

- (void) receiveToggleAuthUINotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"ToggleAuthUINotification"]) {
        NSLog(@"%@", [notification userInfo]);
    }
}
@end
