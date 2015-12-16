//
//  ViewController.m
//  CrimeMap
//
//  Created by Julio César Guzman on 12/16/15.
//  Copyright © 2015 Julio. All rights reserved.
//

#import "ViewController.h"
#import <CrimeMap-Swift.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    SODAAPIRequestManager *requestManager = [[SODAAPIRequestManager alloc] initWithEndpoint:@"https://data.sfgov.org/resource/ritf-b9ki.json?"
                                                                      limitOfObjectsPerPage:3
                                                                                      query:@""];
    [requestManager performRequestOnPage:0];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
