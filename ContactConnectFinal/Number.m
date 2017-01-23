//
//  Number.m
//  ContactConnectFinal
//
//  Created by Akhil Yeleswar on 7/6/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Number.h"
#import "CategoryChosen.h"

@interface Number ()

@end

@implementation Number

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    
}
- (IBAction)next:(id)sender {
    if (![self.phonetxt.text  isEqual: @""]) {
        [self performSegueWithIdentifier:@"Next" sender:self];
        
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetailSegue"]){
        CategoryChosen *controller = (CategoryChosen *)segue.destinationViewController;
        controller.number = self.phonetxt.text;
    }
}


@end
