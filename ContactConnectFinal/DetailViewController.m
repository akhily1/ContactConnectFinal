
//  ContactConnectFinal
//
//  Created by Akhil Yeleswar on 7/6/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//

#import "DetailViewController.h"
#import "ContactConnectFinal-Swift.h"
#import "MasterViewController.h"


@interface DetailViewController ()

-(void)populateContactData;
-(void)performPhoneAction:(BOOL)shouldMakeCall;
-(void)makeCallToNumber:(NSString *)numberToCall;
-(void)sendSMSToNumber:(NSString *)numberToSend;

@end
#define getDataURL @"http://techsoftwiki.com/techsoftwiki.com/webservice/phone.php"
#define getProfURL @"http://techsoftwiki.com/techsoftwiki.com/webservice/getProfile.php"
@implementation DetailViewController
@synthesize json;
@synthesize happyString;
@synthesize citiesArray;
#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[_tblContactDetails registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"yes%@", self.number);
    NSString *first = @"(" ;
    NSString *second = @")";
    NSString *minus = @"-";
    NSString *plus = @"+";
    NSString *space = @" ";
    NSRange range = [self.number2 rangeOfString: first options: NSCaseInsensitiveSearch];
    NSRange range1 = [self.number2 rangeOfString: second options: NSCaseInsensitiveSearch];
    NSRange range2 = [self.number2 rangeOfString: minus options: NSCaseInsensitiveSearch];
    NSRange range3 = [self.number2 rangeOfString: plus options: NSCaseInsensitiveSearch];
    NSRange range4 = [self.number2 rangeOfString: space options: NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        self.number2 = [self.number2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    if (range1.location != NSNotFound) {
        self.number2 = [self.number2 stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    if (range2.location != NSNotFound) {
        self.number2 = [self.number2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    if (range3.location != NSNotFound) {
        self.number2 = [self.number2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    }
    if (range4.location != NSNotFound) {
        self.number2 = [self.number2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if(![self.number2 hasPrefix:@"1"]) {
        self.number2 = [@"1" stringByAppendingString:self.number2];
    }
    NSArray* words = [self.number2 componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.number2 = [words componentsJoinedByString:@""];
        NSLog(@"number2%@", self.number2);
    [_tblContactDetails setDelegate:self];
    [_tblContactDetails setDataSource:self];
    [self retrieveProfiles];
    [self populateContactData];
   [self retrieveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) retrieveData {
    NSURL *url = [NSURL URLWithString:getDataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *foreign = self.number2;
    NSString *first = @"(" ;
    NSString *second = @")";
    NSString *minus = @"-";
    NSString *plus = @"+";
    NSString *space = @" ";
    NSRange range = [foreign rangeOfString: first options: NSCaseInsensitiveSearch];
    NSRange range1 = [foreign rangeOfString: second options: NSCaseInsensitiveSearch];
    NSRange range2 = [foreign rangeOfString: minus options: NSCaseInsensitiveSearch];
    NSRange range3 = [foreign rangeOfString: plus options: NSCaseInsensitiveSearch];
    NSRange range4 = [foreign rangeOfString: space options: NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        foreign = [foreign stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    if (range1.location != NSNotFound) {
        foreign = [foreign stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    if (range2.location != NSNotFound) {
        foreign = [foreign stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    if (range3.location != NSNotFound) {
        foreign = [foreign stringByReplacingOccurrencesOfString:@"+" withString:@""];
    }
    if (range4.location != NSNotFound) {
        foreign = [foreign stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if(![foreign hasPrefix:@"1"]) {
        foreign = [@"1" stringByAppendingString:foreign];
    }
    for (int i = 0; i < json.count; i++) {
        NSString *recap = [[json objectAtIndex:i] objectForKey:@"recap"];
        NSString *sender = [[json objectAtIndex:i] objectForKey:@"sender"];
        if ((recap == nil || [recap isEqual:[NSNull null]]) || (sender == nil || [sender isEqual:[NSNull null]])){
            // handle the place not being available
        } else {
            NSString *first = @"(" ;
            NSString *second = @")";
            NSString *minus = @"-";
            NSString *plus = @"+";
            NSString *space = @" ";
            NSRange range = [recap rangeOfString: first options: NSCaseInsensitiveSearch];
            NSRange range1 = [recap rangeOfString: second options: NSCaseInsensitiveSearch];
            NSRange range2 = [recap rangeOfString: minus options: NSCaseInsensitiveSearch];
            NSRange range3 = [recap rangeOfString: plus options: NSCaseInsensitiveSearch];
            NSRange range4 = [recap rangeOfString: space options: NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@"(" withString:@""];
            }
            if (range1.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@")" withString:@""];
            }
            if (range2.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            if (range3.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@"+" withString:@""];
            }
            if (range4.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            NSArray* words = [recap componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            recap = [words componentsJoinedByString:@""];
            if(![recap hasPrefix:@"1"]) {
                recap = [@"1" stringByAppendingString:recap];
            }
            NSRange range12 = [sender rangeOfString: first options: NSCaseInsensitiveSearch];
            NSRange range11 = [sender rangeOfString: second options: NSCaseInsensitiveSearch];
            NSRange range21 = [sender rangeOfString: minus options: NSCaseInsensitiveSearch];
            NSRange range31 = [sender rangeOfString: plus options: NSCaseInsensitiveSearch];
            NSRange range41 = [sender rangeOfString: space options: NSCaseInsensitiveSearch];
            if (range12.location != NSNotFound) {
                sender = [sender stringByReplacingOccurrencesOfString:@"(" withString:@""];
            }
            if (range11.location != NSNotFound) {
                sender = [sender stringByReplacingOccurrencesOfString:@")" withString:@""];
            }
            if (range21.location != NSNotFound) {
                sender = [sender stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            if (range31.location != NSNotFound) {
                sender = [sender stringByReplacingOccurrencesOfString:@"+" withString:@""];
            }
            if (range41.location != NSNotFound) {
                sender = [sender stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            if(![sender hasPrefix:@"1"]) {
                sender = [@"1" stringByAppendingString:sender];
            }
            NSArray* words1 = [sender componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            sender = [words1 componentsJoinedByString:@""];
            if ([recap isEqualToString:foreign] && [sender isEqualToString:self.number])  {
                self.chosen = [[json objectAtIndex:i] objectForKey:@"category"];
            } else {
                self.chosen = @"Default";
            }
        }
    }
}
-(void) retrieveProfiles {
    NSURL *url = [NSURL URLWithString:getDataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *foreign = self.number2;
    NSString *first = @"(" ;
    NSString *second = @")";
    NSString *minus = @"-";
    NSString *plus = @"+";
    NSString *space = @" ";
    NSRange range = [foreign rangeOfString: first options: NSCaseInsensitiveSearch];
    NSRange range1 = [foreign rangeOfString: second options: NSCaseInsensitiveSearch];
    NSRange range2 = [foreign rangeOfString: minus options: NSCaseInsensitiveSearch];
    NSRange range3 = [foreign rangeOfString: plus options: NSCaseInsensitiveSearch];
    NSRange range4 = [foreign rangeOfString: space options: NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        foreign = [foreign stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    if (range1.location != NSNotFound) {
        foreign = [foreign stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    if (range2.location != NSNotFound) {
        foreign = [foreign stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    if (range3.location != NSNotFound) {
        foreign = [foreign stringByReplacingOccurrencesOfString:@"+" withString:@""];
    }
    if (range4.location != NSNotFound) {
        foreign = [foreign stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    NSArray* words = [foreign componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    foreign = [words componentsJoinedByString:@""];
    if(![foreign hasPrefix:@"1"]) {
        foreign = [@"1" stringByAppendingString:foreign];
    }
    for (int i = 0; i < json.count; i++) {
        NSString *recap = [[json objectAtIndex:i] objectForKey:@"recap"];
        NSString *sender = [[json objectAtIndex:i] objectForKey:@"sender"];
        if ((recap == nil || [recap isEqual:[NSNull null]]) || (sender == nil || [sender isEqual:[NSNull null]])){
            // handle the place not being available
        } else {
            NSString *first = @"(" ;
            NSString *second = @")";
            NSString *minus = @"-";
            NSString *plus = @"+";
            NSString *space = @" ";
            NSRange range = [recap rangeOfString: first options: NSCaseInsensitiveSearch];
            NSRange range1 = [recap rangeOfString: second options: NSCaseInsensitiveSearch];
            NSRange range2 = [recap rangeOfString: minus options: NSCaseInsensitiveSearch];
            NSRange range3 = [recap rangeOfString: plus options: NSCaseInsensitiveSearch];
            NSRange range4 = [recap rangeOfString: space options: NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@"(" withString:@""];
            }
            if (range1.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@")" withString:@""];
            }
            if (range2.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            if (range3.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@"+" withString:@""];
            }
            if (range4.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            NSArray* words = [recap componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            recap = [words componentsJoinedByString:@""];
            if(![recap hasPrefix:@"1"]) {
                recap = [@"1" stringByAppendingString:recap];
            }
            NSRange range12 = [sender rangeOfString: first options: NSCaseInsensitiveSearch];
            NSRange range11 = [sender rangeOfString: second options: NSCaseInsensitiveSearch];
            NSRange range21 = [sender rangeOfString: minus options: NSCaseInsensitiveSearch];
            NSRange range31 = [sender rangeOfString: plus options: NSCaseInsensitiveSearch];
            NSRange range41 = [sender rangeOfString: space options: NSCaseInsensitiveSearch];
            if (range12.location != NSNotFound) {
                sender = [sender stringByReplacingOccurrencesOfString:@"(" withString:@""];
            }
            if (range11.location != NSNotFound) {
                sender = [sender stringByReplacingOccurrencesOfString:@")" withString:@""];
            }
            if (range21.location != NSNotFound) {
                sender = [sender stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            if (range31.location != NSNotFound) {
                sender = [sender stringByReplacingOccurrencesOfString:@"+" withString:@""];
            }
            if (range41.location != NSNotFound) {
                sender = [sender stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            NSArray* words1 = [sender componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            sender = [words1 componentsJoinedByString:@""];
            if(![sender hasPrefix:@"1"]) {
                sender = [@"1" stringByAppendingString:sender];
            }
            // handle the place being available
            if ([recap isEqualToString:self.number] && [sender isEqualToString:foreign])  {
                self.newchoose = [[json objectAtIndex:i] objectForKey:@"category"];
                NSLog(@"chosennew%@", self.newchoose);
            } else {
            }
            if (!(self.newchoose > 0)) {
                self.newchoose = @"Default";
            }
            NSLog(@"now%@", self.newchoose);
        }
        }
    
    if (self.newchoose.length > 0) {
        NSURL *url1 = [NSURL URLWithString:getProfURL];
        NSData * data1 = [NSData dataWithContentsOfURL:url1];
        json = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        for (int i = 0; i < json.count; i++) {
            NSString *other = [[json objectAtIndex:i] objectForKey:@"phone_number"];
            NSString *category = [[json objectAtIndex:i] objectForKey:@"category"];
            NSString *recap = self.number2;
            NSString *first = @"(" ;
            NSString *second = @")";
            NSString *minus = @"-";
            NSString *plus = @"+";
            NSString *space = @" ";
            NSRange range = [recap rangeOfString: first options: NSCaseInsensitiveSearch];
            NSRange range1 = [recap rangeOfString: second options: NSCaseInsensitiveSearch];
            NSRange range2 = [recap rangeOfString: minus options: NSCaseInsensitiveSearch];
            NSRange range3 = [recap rangeOfString: plus options: NSCaseInsensitiveSearch];
            NSRange range4 = [recap rangeOfString: space options: NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@"(" withString:@""];
            }
            if (range1.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@")" withString:@""];
            }
            if (range2.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            if (range3.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@"+" withString:@""];
            }
            if (range4.location != NSNotFound) {
                recap = [recap stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            NSArray* words = [recap componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            recap = [words componentsJoinedByString:@""];
            if(![recap hasPrefix:@"1"]) {
                recap = [@"1" stringByAppendingString:recap];
            }
            NSRange range12 = [other rangeOfString: first options: NSCaseInsensitiveSearch];
            NSRange range11 = [other rangeOfString: second options: NSCaseInsensitiveSearch];
            NSRange range21 = [other rangeOfString: minus options: NSCaseInsensitiveSearch];
            NSRange range31 = [other rangeOfString: plus options: NSCaseInsensitiveSearch];
            NSRange range41 = [other rangeOfString: space options: NSCaseInsensitiveSearch];
            if (range12.location != NSNotFound) {
                other = [other stringByReplacingOccurrencesOfString:@"(" withString:@""];
            }
            if (range11.location != NSNotFound) {
                other = [other stringByReplacingOccurrencesOfString:@")" withString:@""];
            }
            if (range21.location != NSNotFound) {
                other = [other stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
            if (range31.location != NSNotFound) {
                other = [other stringByReplacingOccurrencesOfString:@"+" withString:@""];
            }
            if (range41.location != NSNotFound) {
                other = [other stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            NSArray* words1 = [other componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            other = [words1 componentsJoinedByString:@""];
            if(![other hasPrefix:@"1"]) {
                other = [@"1" stringByAppendingString:other];
            }
            if ([category isEqualToString:self.newchoose] && [other isEqualToString:recap])  {
                self.facebook = [[json objectAtIndex:i] objectForKey:@"facebook"];
                self.twitter = [[json objectAtIndex:i] objectForKey:@"twitter"];
                self.linkedin = [[json objectAtIndex:i] objectForKey:@"linkedin"];
                self.soundcloud = [[json objectAtIndex:i] objectForKey:@"soundcloud"];
                self.google = [[json objectAtIndex:i] objectForKey:@"gmail"];
                self.foursquare = [[json objectAtIndex:i] objectForKey:@"foursquare"];
            } else {
            }
        }
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"insert"]){
        SubmitCategory *controller = (SubmitCategory *)segue.destinationViewController;
        controller.phone2 = self.number;
        controller.phone1 = self.number2;
        controller.category = self.caty;
        controller.name1 = self.name1;
        [[segue destinationViewController] setDictContactDetails:self.dictContactDetails];
    }
    if([segue.identifier isEqualToString:@"goBack"]){
        MasterViewController *controller = (MasterViewController *)segue.destinationViewController;
        controller.number = self.number;
    }
    
}

-(void)populateContactData{
    NSString *contactFullName = [NSString stringWithFormat:@"%@", self.name1];
    
    [_lblContactName setText:contactFullName];
    
    
    // Set the contact image.
    if ([_dictContactDetails objectForKey:@"image"] != nil) {
        [_imgContactImage setImage:[UIImage imageWithData:[_dictContactDetails objectForKey:@"image"]]];
    }
    
    
    // Reload the tableview.
    [_tblContactDetails reloadData];
}


-(void)performPhoneAction:(BOOL)shouldMakeCall{
    // Check if both mobile and home numbers exist.
    if (![self.number2 isEqualToString:@""]) {
        // In this case show an action sheet to let user select a number.
        UIActionSheet *phoneOptions = [[UIActionSheet alloc] initWithTitle:@"Pick a number"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                    destructiveButtonTitle:@""
                                                         otherButtonTitles:self.number2, nil];
        [phoneOptions showInView:self.view];
        
        // Depending on whether the action should be made regards a phone call or sending a SMS, set the appropriate tag
        // value to the action sheet.
        if (shouldMakeCall) {
            [phoneOptions setTag:101];
        }
        else{
            [phoneOptions setTag:102];
        }
        
    }
    else{
        self.selectedPhoneNumber = nil;
        
        // Otherwise make a call to any of the phone numbers that may exit.
            self.selectedPhoneNumber = self.number2;
            
        }
        
        if (self.selectedPhoneNumber != nil) {
            if (shouldMakeCall) {
                [self makeCallToNumber:self.selectedPhoneNumber];
            }
            else{
                [self sendSMSToNumber:self.selectedPhoneNumber];
            }
            
        }
    }


-(void)makeCallToNumber:(NSString *)numberToCall{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberToCall]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}


-(void)sendSMSToNumber:(NSString *)numberToSend{
    if (![MFMessageComposeViewController canSendText]) {
        NSLog(@"Unable to send SMS message.");
    }
    else {
        MFMessageComposeViewController *sms = [[MFMessageComposeViewController alloc] init];
        [sms setMessageComposeDelegate:self];
        
        [sms setRecipients:[NSArray arrayWithObjects:numberToSend, nil]];
        [sms setBody:@""];
        [sms setBody:@"Connect with me on Swap!"];
        [self presentViewController:sms animated:YES completion:nil];
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 3){
        return 6;
    }
    else if (section == 4) {
        return 3;
    }
    else {
        return 2;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Name";
            break;
        case 1:
            return @"Phone Number";
            break;
        case 2:
            return @"E-mail Addresses";
            break;
        case 3:
            return @"Social Media Profiles";
            break;
        case 4:
            return @"Connection Status";
            break;
        default:
            return @"";
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text  isEqual: @"Default"]) {
        NSLog(@"category%@", @"Default");
        self.caty = @"Default";
        [self performSegueWithIdentifier:@"insert" sender:self];
    }
    if ([cell.textLabel.text  isEqual: @"Friends"]) {
        NSLog(@"category%@", @"Friends");
        self.caty = @"Friends";
        [self performSegueWithIdentifier:@"insert" sender:self];
    }
    if ([cell.textLabel.text  isEqual: @"Professional"]) {
        NSLog(@"category%@", @"Professional");
        self.caty = @"Professional";
        [self performSegueWithIdentifier:@"insert" sender:self];
    }
    if ([cell.textLabel.text  isEqual: @"Facebook"]) {
        if (self.facebook.length > 0) {
            NSString *str = @"http://www.facebook.com/";
            str = [str stringByAppendingString:self.facebook];
            NSString *phoneURLString = [NSString stringWithFormat:@"http://facebook.com/%@", self.facebook];
            NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
                [[UIApplication sharedApplication] openURL:phoneURL];
            }
            }
        }
    if ([cell.textLabel.text  isEqual: @"Twitter"]) {
        if (self.twitter.length > 0) {
        NSString *phoneURLString = [NSString stringWithFormat:@"twitter://user?screen_name=%@", self.twitter];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
            [[UIApplication sharedApplication] openURL:phoneURL];
        } else {
            NSString *phoneURLString = [NSString stringWithFormat:@"http://twitter.com/%@", self.twitter];
            NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }
    }
    if ([cell.textLabel.text  isEqual: @"LinkedIn"]) {
        if (self.linkedin.length > 0) {
        NSString *phoneURLString = [NSString stringWithFormat:self.linkedin];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }
    }
    if ([cell.textLabel.text  isEqual: @"SoundCloud"]) {
        if (self.soundcloud.length > 0) {
        NSString *phoneURLString = [NSString stringWithFormat:self.soundcloud];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
        }
    }
    if ([cell.textLabel.text  isEqual: @"Google Plus"]) {
        if (self.google.length > 0) {
            
        NSString *phoneURLString = [NSString stringWithFormat:@"http://plus.google.com/%@", self.google];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSString *cellText = @"";
    NSString *detailText = @"";
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cellText = self.name1;
                    if (self.name1 > 0) {
                        cell.textLabel.textColor = [UIColor blackColor];
                    } else {
                        cell.textLabel.textColor = [UIColor blackColor];
                    }
                    detailText = @"";
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cellText = self.number2;
                    if (self.number2 > 0) {
                        cell.textLabel.textColor = [UIColor blackColor];
                    } else {
                        cell.textLabel.textColor = [UIColor blackColor];
                    }
                    detailText = @"Mobile Number";
                    break;
                case 1:
                  //  cellText = [_dictContactDetails objectForKey:@"otherphone"];
                    detailText = @"Home Number";
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    //cellText = [_dictContactDetails objectForKey:@"homeEmail"];
                    detailText = @"Home E-mail";
                    break;
                case 1:
                    //cellText = [_dictContactDetails objectForKey:@"workEmail"];
                    detailText = @"Work E-mail";
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    cellText = @"Facebook";
                    if (self.facebook.length > 0) {
                        cell.textLabel.textColor = [UIColor blueColor];
                    } else {
                        cell.textLabel.textColor = [UIColor redColor];
                    }
                    break;
                case 1:
                    cellText = @"Twitter";
                    if (self.twitter.length > 0) {
                        cell.textLabel.textColor = [UIColor blueColor];
                    } else {
                        cell.textLabel.textColor = [UIColor redColor];
                    }
                    break;
                case 2:
                    cellText = @"LinkedIn";
                    if (self.linkedin.length > 0) {
                        cell.textLabel.textColor = [UIColor blueColor];
                    } else {
                        cell.textLabel.textColor = [UIColor redColor];
                    }
                    break;
                case 3:
                    cellText = @"SoundCloud";
                    if (self.soundcloud.length > 0) {
                        cell.textLabel.textColor = [UIColor blueColor];
                    } else {
                        cell.textLabel.textColor = [UIColor redColor];
                    }
                    break;
                case 4:
                    cellText = @"Google Plus";
                    if (self.google.length > 0) {
                        cell.textLabel.textColor = [UIColor blueColor];
                    } else {
                        cell.textLabel.textColor = [UIColor redColor];
                    }
                    break;
                case 5:
                    cellText = @"FourSquare";
                    cell.textLabel.textColor = [UIColor redColor];
    
                    break;
            }
            break;
        case 4:
            switch (indexPath.row) {
                case 0:
                    cellText = @"Default";
                    if ([self.chosen  isEqual: @"Default"]) {
                        cell.textLabel.textColor = [UIColor greenColor];
                    } else {
                        cell.textLabel.textColor = [UIColor blackColor];
                    }
                    break;
                case 1:
                    cellText = @"Professional";
                    if ([self.chosen  isEqual: @"Professional"]) {
                        cell.textLabel.textColor = [UIColor greenColor];
                    } else {
                        cell.textLabel.textColor = [UIColor blackColor];
                    }
                    break;
                case 2:
                    cellText = @"Friends";
                    if ([self.chosen  isEqual: @"Friends"]) {
                        cell.textLabel.textColor = [UIColor greenColor];
                    } else {
                        cell.textLabel.textColor = [UIColor blackColor];
                    }
                    break;
            }
        default:
            break;
    }
    
    cell.textLabel.text = cellText;
    cell.detailTextLabel.text = detailText;
    
    return cell;
}


#pragma mark - IBAction method implementation

-(IBAction)makeCall:(id)sender{
    [self performPhoneAction:YES];
}


-(IBAction)sendSMS:(id)sender{
    [self performPhoneAction:NO];
}


#pragma mark - UIActionSheet Delegate method implementation

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Proceed if only the selected button index is other than 3 (the Cancel button).
    if (buttonIndex != 3) {
        // Get the selected phone number.
        NSString *selectedPhoneNumber = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        // If the action sheet tag is equal to 101 then make a call to the selected number.
        // Otherwise send a SMS.
        if ([actionSheet tag] == 101) {
            NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", selectedPhoneNumber];
            NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
                [[UIApplication sharedApplication] openURL:phoneURL];
            }

        } else{
            [self sendSMSToNumber:selectedPhoneNumber];
        }
    }
    
}
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self performSegueWithIdentifier:@"goBack" sender:self];
    }
    [super viewWillDisappear:animated];
}


#pragma mark - MessageComposeViewController Delegate method

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
