//
//  AppTests.m
//  AppTests
//
//  Created by Joe Bologna on 7/21/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "AppTests.h"
#import "IGDViewController.h"
#import "Fields.h"

@interface AppTests () {
    IGDViewController *vc;
    MyButton *b;
};
@end;

@implementation AppTests

- (void)setUp
{
    [super setUp];
    
    vc = ((IGDViewController *)[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController]);
    b = [[MyButton alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

/*
 - (void)test01PushButtons
{
    b.tag = 403;
    for(int i = 0; i < 3; i++) {
        [vc buttonPushed:b];
    }
    STAssertTrue(TRUE, @"oops");
}
 */

- (void)test02MakeFields {
    NSLog(@"%s, %@", __func__, [vc description]);
    Fields *f = [Fields allocFields];
    f.vc = vc;
    [f populateScreen];
    STAssertTrue(TRUE, @"oops");
}

@end
