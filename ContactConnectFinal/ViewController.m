//
//  ViewViewController.m
//  LibSoundCloud

//  Created by Stofkat.org on 23-05-14.
//  Copyright (c) 2014 Stofkat. All rights reserved.
//

#import "ViewController.h"
#import "FSQJSONObjectViewController.h"
#import "JSONKit.h"
#import "ContactConnectFinal-Swift.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>
#import "SoundCloud.h"
#import <QuartzCore/QuartzCore.h>
#define kClientID       @"F32QXG4CAISXZMD4I3MOSE4H5BUTX1BRRBE4P2H0CW5GWVMF"
#define kCallbackURL    @"fsqdemo://foursquare"

@interface ViewController ()

@property(nonatomic,readwrite,strong) BZFoursquare *foursquare;
@property(nonatomic,strong) BZFoursquareRequest *request;
@property(nonatomic,copy) NSDictionary *meta;
@property(nonatomic,copy) NSArray *notifications;
@property(nonatomic,copy) NSDictionary *response;
@property(nonatomic,copy,readwrite) NSString *clientID;
@property(nonatomic,copy,readwrite) NSString *callbackURL;

- (void)updateView;
- (void)cancelRequest;
- (void)prepareForRequest;
- (void)searchVenues;
- (void)checkin;
- (void)addPhoto;

enum {
    kAuthenticationSection = 0,
    kEndpointsSection,
    kResponsesSection,
    kSectionCount
};

enum {
    kAccessTokenRow = 0,
    kAuthenticationRowCount
};

enum {
    kSearchVenuesRow = 0,
    kCheckInRow,
    kAddPhotoRow,
    kEndpointsRowCount
};

enum {
    kMetaRow = 0,
    kNotificationsRow,
    kResponseRow,
    kResponsesRowCount
};

@end

@implementation ViewController

BOOL hasBeenLoggedIn;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.foursquare = [[BZFoursquare alloc] initWithClientID:kClientID callbackURL:kCallbackURL];
        _foursquare.version = @"20120609";
        _foursquare.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        _foursquare.sessionDelegate = self;
    }
    return self;
}

- (void)dealloc {
    
    _foursquare.sessionDelegate = nil;
    [self cancelRequest];
}
- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.soundcloudtext = @"";
    [super viewDidLoad];
    
  
    self.but1.alpha = 0.0f;
    
    // This will wait 1 sec until calling showButtons, where we will do the trick
    NSTimeInterval timeInterval = 1.0;
    [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(showButtons) userInfo:nil repeats:NO];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered
                                                target:self
                                                action:@selector(next)];
    self.navigationItem.rightBarButtonItem = addButton;
    [_detailsDict setDelegate:self];
    [_detailsDict setDataSource:self];
    [self.detailsDict reloadData];
     self.soundCloud =[[SoundCloud alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
[super viewDidLoad];
}
// Do your init stuff here

// We will call your buttons as if they are declared as properties of your class, ask if you don't know how to set them

- (void) showButtons {
    [UIView beginAnimations:@"buttonShowUp" context:nil];
    [UIView setAnimationDuration:0.5]; // Set it as you want, it's the length of your animation
    
    self.but1.alpha = 1.0f;
    
    // If you want to move them from right to left, here is how we gonna do it :
    float move = 100.0f; // Set it the way you want it
    self.but1.frame = CGRectMake(self.but1.frame.origin.x - move,
                                    self.but1.frame.origin.y,
                                    self.but1.frame.size.width,
                                    self.but1.frame.size.height);
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) sounddo{
    NSLog(@"hi%@", self.label1.text);
    [self searchForTracksWithQuery:self.label1.text];
    //self.circle1.backgroundColor = [UIColor greenColor];
}

-(BOOL) login {
    
    //check if we have the token stored in userprefs
    self.scToken=[[NSUserDefaults standardUserDefaults] objectForKey:SC_TOKEN];
    if(self.scToken && self.scToken.length>0) {
        //we are already logged in
        return true;
    }
    else {
        
        self.scCode=[[NSUserDefaults standardUserDefaults] objectForKey:SC_CODE];
        if(self.scCode)
        {
            [self doOauthWithCode:self.scCode];
            return true;
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               //[self openLoginViewController];
                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://soundcloud.com/connect?scope=non-expiring&client_id=%@&redirect_uri=%@&response_type=code",CLIENT_ID,REDIRECT_URI]]];
                           });
            return false;
        }
    }
    
}


- (void)doOauthWithCode: (NSString *)code {
    
    NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/oauth2/token/"];
    NSString *postString =[NSString stringWithFormat:@"scope=non-expiring&client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",CLIENT_ID,CLIENT_SECRET,REDIRECT_URI,code];
    NSLog(@"post string: %@",postString);
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSString *responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"response body; %@",responseBody);
    
    NSMutableDictionary *resultJSON =[responseBody objectFromJSONString];
    self.scToken=[resultJSON objectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] setObject:self.scToken forKey:SC_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}




-(void) loginCallback :(NSString *) token
{
    if(token !=nil)
    {
        hasBeenLoggedIn=true;
        self.scToken = token;
    }
    
}

//Get list with full user tracks
-(NSMutableArray *) getUserTracks {
    
    NSString *jsonString =[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.soundcloud.com/me/tracks.json?oauth_token=%@",self.scToken]] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *musicArray =[jsonString objectFromJSONString];
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    NSLog(@"%@",jsonString);
    
    self.scTrackResultList = [[NSMutableArray alloc]init];
    for(int i=0; i< musicArray.count;i++)
    {
        NSMutableDictionary *result = [musicArray objectAtIndex:i];
        if([[result objectForKey:@"kind" ] isEqualToString:@"track"])
        {
            [returnArray addObject:result];
        }
    }
    
    return returnArray;
}



//Search for music with the given query
-(NSMutableArray *) searchForTracksWithQuery: (NSString *) query {
    
    if(!self.scToken)
    {
        if(![self login])
        {
            return nil;
        }
    }
    if(query.length >0)
        query = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *jsonString1 =[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.soundcloud.com/me?oauth_token=%@",self.scToken]] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *musicArray =[jsonString1 objectFromJSONString];
    self.scTrackResultList = [[NSMutableArray alloc]init];
   // NSLog(@"h%@", musicArray);
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    dictionary = [musicArray mutableCopy];
   // NSLog(@"h%@", dictionary);
    NSString * string = [dictionary objectForKey:@"permalink_url"];
    NSLog(@"str%@", string);
    self.soundcloudtext = [dictionary objectForKey:@"permalink_url"];
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    [self.detailsDict reloadData];
    return returnArray;
}


- (void) fbget {
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
                self.fbtext = [result objectForKey:@"id"];
                [self.detailsDict reloadData];
            }
        }
        }];
     [connection start];
    
     }
- (void) next {
    NSLog(@"Customer details: %@ %@ %@ %@ %@ %@ %@ %@", self.number, self.category, self.fourtext, self.data, self.fbtext, self.twtext, self.soundcloudtext, self.gtext);
   [self performSegueWithIdentifier:@"nexterman" sender:self];
}

- (void) logFour {
    [self check];
    }

-(void) check {
    if (![_foursquare isSessionValid]) {
        [_foursquare startAuthorization];
        NSLog(@"first:%@", [[[_response objectForKey:@"checkin"] objectForKey:@"user"] objectForKey:@"id"]);
        self.fourtext = [[[_response objectForKey:@"checkin"] objectForKey:@"user"] objectForKey:@"id"];
    } else {
        self.fourtext = [[[_response objectForKey:@"checkin"] objectForKey:@"user"] objectForKey:@"id"];
    }
    self.fourtext = [[[_response objectForKey:@"checkin"] objectForKey:@"user"] objectForKey:@"id"];
    NSLog(@"middle:%@", self.fourtext);
    [self.detailsDict reloadData];
}
- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[error userInfo][@"errorDetail"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark BZFoursquareSessionDelegate

- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kAccessTokenRow inSection:kAuthenticationSection];
    NSArray *indexPaths = @[indexPath];
    [self checkin];
    id JSONObject = nil;
    JSONObject = _response;
//    FSQJSONObjectViewController *JSONObjectViewController = [[FSQJSONObjectViewController alloc] initWithJSONObject:JSONObject];
//    [self.navigationController pushViewController:JSONObjectViewController animated:YES];
    NSLog(@"after:%@", [_response objectForKey:@"checkin"]);
}

- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, errorInfo);
}

#pragma mark -
#pragma mark Anonymous category

- (void)updateView {
    if ([self isViewLoaded]) {
   
    }
}

- (void)cancelRequest {
    if (_request) {
        _request.delegate = nil;
        [_request cancel];
        self.request = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)prepareForRequest {
    [self cancelRequest];
    self.meta = nil;
    self.notifications = nil;
    self.response = nil;
}

- (void)searchVenues {
    [self prepareForRequest];
    NSDictionary *parameters = @{@"ll": @"40.7,-74"};
    self.request = [_foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [_request start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void) gsignMan{
    GIDSignIn*sigNIn=[GIDSignIn sharedInstance];
    [sigNIn setDelegate:self];
    [sigNIn setUiDelegate:self];
    sigNIn.shouldFetchBasicProfile = YES;
    sigNIn.scopes = @[@"https://www.googleapis.com/auth/plus.login",@"https://www.googleapis.com/auth/userinfo.email",@"https://www.googleapis.com/auth/userinfo.profile"];
    sigNIn.clientID =@"240189251154-gfbhqsn43ad9va3dq7s0vo8cgg2uff3u.apps.googleusercontent.com";
    [sigNIn signIn];

    
}


- (void)checkin {
    [self prepareForRequest];
    NSDictionary *parameters = @{@"venueId": @"4d341a00306160fcf0fc6a88", @"broadcast": @"public"};
    self.request = [_foursquare requestWithPath:@"checkins/add" HTTPMethod:@"POST" parameters:parameters delegate:self];
    [_request start];
    [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)addPhoto {
    [self prepareForRequest];
    NSURL *photoURL = [[NSBundle mainBundle] URLForResource:@"TokyoBa-Z" withExtension:@"jpg"];
    NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    NSDictionary *parameters = @{@"photo.jpg": photoData, @"venueId": @"4d341a00306160fcf0fc6a88"};
    self.request = [_foursquare requestWithPath:@"photos/add" HTTPMethod:@"POST" parameters:parameters delegate:self];
    [_request start];
    [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) tw {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            self.twtext = [session userName];
            [self.detailsDict reloadData];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSLog(@"%@", user);
    self.userID = user.userID;
    self.gtext = user.userID;// For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *name = user.profile.name;
    NSString *email = user.profile.email;
    NSLog(@"Customer details: %@ %@ %@ %@", self.userID, idToken, name, email);
[self.detailsDict reloadData];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"linked"]){
        ChooseViewController *controller = (ChooseViewController *)segue.destinationViewController;
        
        controller.fourtext = self.fourtext;
        controller.number = self.number;
        controller.category = self.category;
        controller.fbtext = self.fbtext;
        controller.twtext = self.twtext;
        controller.soundcloudtext = self.soundcloudtext;
        controller.gtext = self.gtext;
    }
    if([segue.identifier isEqualToString:@"nexterman"]){
        Finalize *controller1 = (Finalize *)segue.destinationViewController;
        
        controller1.fourtext = self.fourtext;
        controller1.number = self.number;
        controller1.category = self.category;
        controller1.fbtext = self.fbtext;
        controller1.twtext = self.twtext;
        controller1.data = self.data;
        controller1.soundcloudtext = self.soundcloudtext;
        controller1.gtext = self.gtext;
        
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) receiveToggleAuthUINotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"ToggleAuthUINotification"]) {
        NSLog(@"%@", [notification userInfo]);
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text  isEqual: @"Facebook"]) {
        [self fbget];
    }
    if ([cell.textLabel.text  isEqual: @"Twitter"]) {
        [self tw];
    }
    if ([cell.textLabel.text  isEqual: @"LinkedIn"]) {
        [self performSegueWithIdentifier:@"linked" sender:self];
    }
    if ([cell.textLabel.text  isEqual: @"SoundCloud"]) {
        [self sounddo];
    }
    if ([cell.textLabel.text  isEqual: @"Google Plus"]) {
        [self gsignMan];
    }
    if ([cell.textLabel.text  isEqual: @"FourSquare"]) {
        [self logFour];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSString *cellText = @"";
    
    NSString *detailText = @"";
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 2:
                    cellText = @"FourSquare";
                    if (self.fourtext.length > 4) {
                        cell.backgroundColor = [UIColor greenColor];
                    }
                    cell.textLabel.textColor = [UIColor redColor];
                    break;
                case 4:
                    cellText = @"Facebook";
                    if (self.fbtext.length > 1) {
                        cell.backgroundColor = [UIColor greenColor];
                    }
                    cell.textLabel.textColor = [UIColor blueColor];
                    break;
                case 8:
                    cellText = @"Twitter";
                    cell.textLabel.textColor = [UIColor blueColor];
                    if (self.twtext.length > 1) {
                        cell.backgroundColor = [UIColor greenColor];
                    }
                    break;
                case 6:
                    cellText = @"LinkedIn";
                    cell.textLabel.textColor = [UIColor grayColor];
                    if (self.data.length > 1) {
                        cell.backgroundColor = [UIColor greenColor];
                    }
                    break;
                case 12:
                    cellText = @"Google Plus";
                    cell.textLabel.textColor = [UIColor blueColor];
                    if (self.gtext.length > 1) {
                        cell.backgroundColor = [UIColor greenColor];
                    }
                    break;
                case 10:
                    cellText = @"SoundCloud";
                    cell.textLabel.textColor = [UIColor orangeColor];
                    if (self.soundcloudtext.length > 1) {
                        cell.backgroundColor = [UIColor greenColor];
                    }
                    break;
            }
            break;
              case 4:
            switch (indexPath.row) {
                case 0:
                    cellText = @"Default";
                   
                    break;
                case 1:
                    cellText = @"Professional";
            
                    break;
                case 2:
                    cellText = @"Friends";
                  
                    break;
            }
        default:
            break;
    }
    
    cell.textLabel.text = cellText;
    cell.detailTextLabel.text = detailText;
    
    return cell;}


@end
