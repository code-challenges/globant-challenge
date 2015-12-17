//
//  ViewController.m
//  CrimeMap
//
//  Created by Julio César Guzman on 12/16/15.
//  Copyright © 2015 Julio. All rights reserved.
//

#import "ViewController.h"
#import <CrimeMap-Swift.h>

NSString *kEndpoint = @"https://data.sfgov.org/resource/ritf-b9ki.json?";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    EventRequestManager *eventRequestManager = [[EventRequestManager alloc] initWithEndpoint:kEndpoint limitOfObjectsPerPage:1 monthsBack:1];
    [eventRequestManager performRequestOnPage:0 completionHandler:^(NSArray * array, NSError * error) {
        
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
