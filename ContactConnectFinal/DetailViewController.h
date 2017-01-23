#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BZFoursquare.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, BZFoursquareRequestDelegate, BZFoursquareSessionDelegate>

@property (nonatomic, weak) IBOutlet UILabel *lblContactName;
@property (nonatomic, weak) IBOutlet UIImageView *imgContactImage;
@property (nonatomic, weak) IBOutlet UITableView *tblContactDetails;
@property(nonatomic, strong) NSDictionary *dictContactDetails;
@property (nonatomic, strong) NSMutableArray *json;
@property (nonatomic, retain) NSString *happyString;
@property (nonatomic, retain) NSString *selectedPhoneNumber;
@property (nonatomic, retain) NSString *caty;
@property (nonatomic, retain) NSString *name1;
@property (nonatomic, strong) NSMutableArray *citiesArray;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) NSString *fbid;
@property (nonatomic, retain) NSString *chosen;
@property (nonatomic, retain) NSString *newchoose;
@property (nonatomic, retain) NSString *number2;
@property (nonatomic, retain) NSString *test;
@property (nonatomic, retain) NSString *facebook;
@property (nonatomic, retain) NSString *twitter;
@property (nonatomic, retain) NSString *linkedin;
@property (nonatomic, retain) NSString *soundcloud;
@property (nonatomic, retain) NSString *google;
@property (nonatomic, retain) NSString *foursquare;

-(IBAction)makeCall:(id)sender;
-(IBAction)sendSMS:(id)sender;
@end