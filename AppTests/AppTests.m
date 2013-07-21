//
//  AppTests.m
//  AppTests
//
//  Created by Joe Bologna on 7/21/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "AppTests.h"
#import "ViewController.h"

@interface AppTests () {
    ViewController *vc;
    MyButton *b;
};
@end;

@implementation AppTests

- (void)setUp
{
    [super setUp];
    
    vc = (ViewController *)[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
    b = [[MyButton alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    b.tag = 403;
    for(int i = 0; i < 3; i++) {
        [vc buttonPushed:b];
    }
    STFail(@"Unit tests are not implemented yet in AppTests");
}

@end
