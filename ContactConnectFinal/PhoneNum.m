//
//  PhoneNum.m
//  ContactConnectFinal
//
//  Created by Akhil Yeleswar on 7/8/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneNum.h"
#import "ContactConnectFinal-Swift.h"
#import "MasterViewController.h"


@interface PhoneNum ()

@end

#define getDataURL @"http://techsoftwiki.com/techsoftwiki.com/webservice/fbcheck.php"
@implementation PhoneNum

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.phonetxt.placeholder = @"1xxxxxxxxxx";
    
}

- (IBAction)next:(id)sender {
    self.place = self.phonetxt.text;
    NSString *first = @"(" ;
    NSString *second = @")";
    NSString *minus = @"-";
    NSString *plus = @"+";
    NSString *space = @" ";
    NSRange range = [self.place rangeOfString: first options: NSCaseInsensitiveSearch];
    NSRange range1 = [self.place rangeOfString: second options: NSCaseInsensitiveSearch];
    NSRange range2 = [self.place rangeOfString: minus options: NSCaseInsensitiveSearch];
    NSRange range3 = [self.place rangeOfString: plus options: NSCaseInsensitiveSearch];
    NSRange range4 = [self.place rangeOfString: space options: NSCaseInsensitiveSearch];
    NSLog(@"found: %@", (range.location != NSNotFound) ? @"Yes" : @"No");
    if (range.location != NSNotFound) {
        self.place = [self.place stringByReplacingOccurrencesOfString:@"(" withString:@""];
        NSLog(@"place%@", self.place);
    }
    if (range1.location != NSNotFound) {
        self.place = [self.place stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSLog(@"place%@", self.place);
    }
    if (range2.location != NSNotFound) {
        self.place = [self.place stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"place%@", self.place);
    }
    if (range3.location != NSNotFound) {
        self.place = [self.place stringByReplacingOccurrencesOfString:@"+" withString:@""];
        NSLog(@"place%@", self.place);
    }
    if (range4.location != NSNotFound) {
        self.place = [self.place stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"place%@", self.place);
    }
    if(![self.place hasPrefix:@"1"]) {
        self.place = [@"1" stringByAppendingString:self.place];
        NSLog(@"place%@", self.place);
    }
    NSArray* words = [self.place componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.place = [words componentsJoinedByString:@""];
    if (![self.place isEqual: @""] && (self.facebook.length > 0)) {
        [self performSegueWithIdentifier:@"showNext" sender:self];
        
    }
    
}

- (IBAction)fb:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Please work");
             [self getFacebookProfileInfo];
         }
     }];
}
- (void)getFacebookProfileInfo {
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:nil];
    
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if(result)
        {
            if ([result objectForKey:@"email"]) {
                
                NSLog(@"Email: %@",[result objectForKey:@"email"]);
                
            }
            if ([result objectForKey:@"first_name"]) {
                
                NSLog(@"First Name : %@",[result objectForKey:@"first_name"]);
                
            }
            if ([result objectForKey:@"id"]) {
                NSLog(@"User id : %@",[result objectForKey:@"id"]);
                self.facebook = [result objectForKey:@"id"];
                NSLog(@"yes%@", self.facebook);
                self.fbbut.hidden = YES;
            }
        }
    }];
    [connection start];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showNext"]){
        FacebookCo *controller = (FacebookCo *)segue.destinationViewController;
        controller.number = self.place;
        controller.fbtext = self.facebook;
    }

}


@end