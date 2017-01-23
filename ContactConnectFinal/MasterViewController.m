#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CategoryChosen.h"
#import "ContactConnectFinal-Swift.h"

@interface MasterViewController ()

@property (nonatomic, strong) NSMutableArray *arrContactsData;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;

-(void)showAddressBook;

@end

#define getDataURL @"http://techsoftwiki.com/techsoftwiki.com/webservice/fbcheck.php"
#define getProfURL @"http://techsoftwiki.com/techsoftwiki.com/webservice/tbcells.php"
@implementation MasterViewController
@synthesize json;
@synthesize happyString;
@synthesize citiesArray;
- (void)awakeFromNib
{
    [super awakeFromNib]; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    if ([FBSDKAccessToken currentAccessToken]) {
        [self getFacebookProfileInfo];
    } else {
        [self performSegueWithIdentifier:@"nexter" sender:self];
    }
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(showAddressBook)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    [self starto];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) starto {
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted) {
        // if you got here, user had previously denied/revoked permission for your
        // app to access the contacts, and all you can do is handle this gracefully,
        // perhaps telling the user that they have to go to settings to grant access
        // to contacts
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (!addressBook) {
        NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
        return;
    }
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (error) {
            NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
        }
        
        if (granted) {
            // if they gave you permission, then just carry on
            
            [self listPeopleInAddressBook:addressBook];
        } else {
            // however, if they didn't give you permission, handle it gracefully, for example...
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // BTW, this is not on the main thread, so dispatch UI updates back to the main queue
                
                [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        }
        
        CFRelease(addressBook);
    });
}
- (void)listPeopleInAddressBook:(ABAddressBookRef)addressBook
{
    self.allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault,
                                                               CFArrayGetCount(people),
                                                               people);
    
    CFArraySortValues(peopleMutable,
                      CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      kABPersonSortByFirstName);
    
    // or to sort by the address book's choosen sorting technique
    //
    // CFArraySortValues(peopleMutable,
    //                   CFRangeMake(0, CFArrayGetCount(peopleMutable)),
    //                   (CFComparatorFunction) ABPersonComparePeopleByName,
    //                   (void*) ABPersonGetSortOrdering());
    
    CFRelease(people);
    self.outputArray=[NSMutableArray new];
    // If you don't want to have to go through this ABRecordCopyValue logic
    // in the rest of your app, rather than iterating through doing NSLog,
    // build a new array as you iterate through the records.
    
    for (CFIndex i = 0; i < CFArrayGetCount(peopleMutable); i++)
    {
        ABRecordRef record = CFArrayGetValueAtIndex(peopleMutable, i);
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonFirstNameProperty));
        [self.outputArray addObject:(__bridge id _Nonnull)(record)];
        NSString *lastName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonLastNameProperty));
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(record, kABPersonPhoneProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
        }
    }
    

    CFRelease(peopleMutable);
    [self.tableView reloadData];
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
                self.fbid = [result objectForKey:@"id"];
                [self retrieveData];
            }
        }
    }];
    [connection start];
    
}
-(void) retrieveData {
    NSURL *url = [NSURL URLWithString:getDataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    for (int i = 0; i < json.count; i++) {
        NSString *facebook = [[json objectAtIndex:i] objectForKey:@"facebook"];
        NSString *num = [[json objectAtIndex:i] objectForKey:@"number"];
        if ((facebook == nil || [facebook isEqual:[NSNull null]]) || (num == nil || [num isEqual:[NSNull null]])){
        } else {
            if ([self.fbid isEqualToString:[[json objectAtIndex:i] objectForKey:@"facebook"]]) {
                self.number = [[json objectAtIndex:i] objectForKey:@"number"];
            }
        }
    }
    
    if (!(self.number.length > 0)) {
        [self performSegueWithIdentifier:@"nexter" sender:self];
    }
    //[self retrieveProfiles];

}

#pragma mark - Private method implementation

-(void)showAddressBook{
    [self.tableView reloadData];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.outputArray) {
        return self.outputArray.count;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) // Not possible to re-use cell, so create a new cell
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }


    self.firstNam = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(self.outputArray[indexPath.row]), kABPersonFirstNameProperty));
        self.lastNam = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(self.outputArray[indexPath.row]), kABPersonLastNameProperty));
    cell.tag = indexPath.row;
    if (!(self.lastNam > 0)) {
        self.lastNam = @"";
    }
    if (self.firstNam.length > 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ ", self.firstNam, self.lastNam ];

    }
    return cell;
    }


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *controller = (DetailViewController *)segue.destinationViewController;
        ABMultiValueRef phoneNumbers = ABRecordCopyValue((__bridge ABRecordRef)(self.outputArray[self.tableView.indexPathForSelectedRow.row]), kABPersonPhoneProperty);
            self.phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
        if (!(self.phoneNumber > 0)) {
            self.phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, 1);
        }
        self.firstNamo = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(self.outputArray[self.tableView.indexPathForSelectedRow.row]), kABPersonFirstNameProperty));
        self.lastNamo = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(self.outputArray[self.tableView.indexPathForSelectedRow.row]), kABPersonLastNameProperty));
        if (!(self.lastNamo > 0)) {
            self.lastNamo = @"";
        }
        NSString *combined = [NSString stringWithFormat:@"%@ %@", self.firstNamo, self.lastNamo];
         NSLog(@"phonesssss:%@", self.phoneNumber);
        controller.name1 = combined;
        NSLog(@"first%@", self.firstNamo);
        controller.number2 = self.phoneNumber;
        controller.number = self.number;
    }
    if ([[segue identifier] isEqualToString:@"category"]) {
        CategoryChosen *controller = (CategoryChosen *)segue.destinationViewController;
        controller.number = self.number;
    }
    if ([[segue identifier] isEqualToString:@"checker"]) {
        ArrCounts *controller = (ArrCounts *)segue.destinationViewController;
        controller.number = self.number;
        controller.fbid = self.fbid;
        controller.yournumber = self.number;
        controller.first = self.first;
        controller.last = self.last;
        controller.othernumber = self.othernumber;
    }
}


-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}


-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}

@end
