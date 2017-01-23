//
//  ViewViewController.h
//  LibSoundCloud
//
//  Created by Stofkat.org on 23-05-14.
//  Copyright (c) 2014 Stofkat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZFoursquare.h"
#import "SoundCloud.h"
#import <Google/SignIn.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#define kPostURL @"http://techsoftwiki.com/techsoftwiki.com/webservice/insertshare.php"
#define kPhoneNumber = @"phone_number"
#define kFacebook = @"facebook"
#define kTwitter = @"twitter"
#define kLinkedIn = @"linkedin"
#define kSoundCloud = @"soundcloud"
#define kGmail = @"gmail"
#define kFourSquare = @"foursquare"
#define CLIENT_ID @"2b1d2313e10fe33954e8a8cd8d629eab"
#define CLIENT_SECRET @"8d29a6f3bb5e8214acd539a9c29f749b"
#define REDIRECT_URI @"yourappname://oauth"//don't forget to change this in Info.plist as well
#define SC_API_URL @"https://api.soundcloud.com"
#define SC_TOKEN @"SC_TOKEN"
#define SC_CODE @"SC_CODE"
@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, BZFoursquareRequestDelegate, BZFoursquareSessionDelegate>


@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UITableView *detailsDict;

@property (weak, nonatomic) IBOutlet UIButton *but1;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (nonatomic, retain) NSString *linktext;
@property (nonatomic, retain) NSString *fourtext;
@property (nonatomic, retain) NSString *gtext;
@property (nonatomic, retain) NSString *fbtext;
@property (nonatomic, retain) NSString *twtext;
@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) NSString *soundcloudtext;
@property (nonatomic, retain) SoundCloud *soundCloud;
@property(nonatomic,readonly,strong) BZFoursquare *foursquare;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property(nonatomic,copy,readonly) NSString *clientID;
@property(nonatomic,copy,readonly) NSString *callbackURL;
@property(nonatomic,copy) NSString *clientSecret; // for userless access
@property (weak, nonatomic) IBOutlet UIButton *fourbutton;
@property(nonatomic,copy) NSString *version; // YYYYMMDD
@property(nonatomic,copy) NSString *locale;  // en (default), fr, de, it, etc.
@property(nonatomic,assign) id<BZFoursquareSessionDelegate> sessionDelegate;
@property(nonatomic,copy) NSString *accessToken;
- (IBAction)linkey:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCont1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCont2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCont3;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCont4;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCont5;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCont6;
@property (strong, nonatomic)  NSMutableArray *scTrackResultList;
@property (strong, nonatomic)  NSString *scToken;
@property (strong, nonatomic)  NSString *scCode;
@property (strong, nonatomic) NSString *ur;
@property(strong, nonatomic) NSURLConnection *postConnection;
@property (weak, nonatomic) IBOutlet UIButton *btnToggleLoginState;
- (id)initWithClientID:(NSString *)clientID callbackURL:(NSString *)callbackURL;

- (BOOL)startAuthorization;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)invalidateSession;
- (BOOL)isSessionValid;
-(NSMutableArray *) searchForTracksWithQuery: (NSString *) query;
-(NSData *) downloadTrackData :(NSString *)songURL;
-(NSMutableArray *) getUserTracks;
-(BOOL) login;
@end
