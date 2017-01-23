//
//  PhoneNum.h
//  ContactConnectFinal
//
//  Created by Akhil Yeleswar on 7/8/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface PhoneNum : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *phonetxt;
@property (nonatomic, retain) NSString *place;
@property (nonatomic, retain) NSString *facebook;
@property (weak, nonatomic) IBOutlet UIButton *fbbut;
@property (nonatomic, strong) NSMutableArray *json;
@property (nonatomic, retain) NSString *number;
@end