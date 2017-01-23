//
//  CategoryChosen.m
//  ContactConnectFinal
//
//  Created by Akhil Yeleswar on 7/6/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryChosen.h"
#import "ViewController.h"

@interface CategoryChosen ()

@end

@implementation CategoryChosen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}
- (IBAction)default:(id)sender {
    [self performSegueWithIdentifier:@"Default" sender:self];
}
- (IBAction)professional:(id)sender {
    [self performSegueWithIdentifier:@"Professional" sender:self];
}
- (IBAction)friends:(id)sender {
    [self performSegueWithIdentifier:@"Friends" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Default"]){
        ViewController *controller = (ViewController *)segue.destinationViewController;
        controller.category = @"Default";
        controller.number = self.number;
        NSLog(@"s%@", self.number);
    }
    if([segue.identifier isEqualToString:@"Professional"]){
        ViewController *controller = (ViewController *)segue.destinationViewController;
        controller.category = @"Professional";
        controller.number = self.number;
    }
    if([segue.identifier isEqualToString:@"Friends"]){
        ViewController *controller = (ViewController *)segue.destinationViewController;
        controller.category = @"Friends";
        controller.number = self.number;
    }
}


@end
