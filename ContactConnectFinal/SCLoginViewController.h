
//  ContactConnectFinal
//
//  Created by Akhil Yeleswar on 7/6/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic)  NSString *scToken;
@property (strong, nonatomic)  NSString *scCode;
@property id soundCloudDelegate;
@end
