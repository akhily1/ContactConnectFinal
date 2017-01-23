//
//  SoundCloud.h
//  Stofkat.org
//
// First basic version of my custom SoundCloud library
// The one from SoundCloud has 5 dependancy projects just
// for some very basic funtionality. This project only uses
// JSONKit as an aditional library and should be much easier
// to implement in your own projects
// if you have any questions you can mail me at stofkat@gmail.com
//  Created by Stofkat on 08-05-14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface SoundCloud : NSObject

//Change these to your own apps values
#define CLIENT_ID @"3dfd0e49b732d3f47628e5056c1dc8e7"
#define CLIENT_SECRET @"fa2ba4f9cf0c49fdf30349f51df3e7c2"
#define REDIRECT_URI @"yourappname://oauth"//don't forget to change this in Info.plist as well

#define SC_API_URL @"https://api.soundcloud.com"
#define SC_TOKEN @"SC_TOKEN"
#define SC_CODE @"SC_CODE"

@property (strong, nonatomic)  NSMutableArray *scTrackResultList;
@property (nonatomic,retain) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic)  NSString *scToken;
@property (strong, nonatomic)  NSString *scCode;


-(NSMutableArray *) searchForTracksWithQuery: (NSString *) query;
-(NSData *) downloadTrackData :(NSString *)songURL;
-(NSMutableArray *) getUserTracks;
-(BOOL) login;
@end