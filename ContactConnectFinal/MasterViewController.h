#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface MasterViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *json;
@property (nonatomic, strong) NSMutableArray *json1;
@property (nonatomic, strong) NSMutableArray *outputArray;
@property (nonatomic, strong) NSMutableArray *outputSects;
@property (nonatomic, strong) NSMutableArray *outputAreas;
@property (nonatomic, strong) NSMutableArray *citiesArray;
@property (nonatomic) NSInteger *numberOfPeople;
@property (nonatomic, retain) NSString *happyString;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *firstNam;
@property (nonatomic, retain) NSString *firstNamo;
@property (nonatomic, retain) NSString *lastNam;
@property (nonatomic, retain) NSString *lastNamo;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) NSString *fbid;
@property (nonatomic, retain) NSString *first;
@property (nonatomic, retain) NSString *last;
@property (nonatomic, retain) NSString *othernumber;
@property (nonatomic, retain) NSArray *allPeople;
@end
