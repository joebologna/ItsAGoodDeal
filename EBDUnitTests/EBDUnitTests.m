//
//  EBDUnitTests.m
//  EBDUnitTests
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "EBDUnitTests.h"
#import "Savings.h"

@interface EBDUnitTests () {
};
@end;

@implementation EBDUnitTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test02SavingsClass {
    Savings *savings = [Savings theSavingsWithItemA:
                        [Item theItemWithName:@"Item A" price:1.5 qty:2 size:1 qty2Buy:1] itemB:
                        [Item theItemWithName:@"Item B" price:1 qty:2 size:1 qty2Buy:1]];
    Item *better = savings.getBest;
    [self log:@""];
    [better logSelf:better];
 
    [self log:@""];
    @try {
        [savings calcSavings];
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
    
    [self log:@""];
    savings.itemA.qty2Buy = savings.itemB.qty2Buy = MAX(savings.itemA.qty, savings.itemB.qty);
    @try {
        [savings calcSavings];
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
    [self log:@""];
    
    STAssertTrue(YES, @"this should never happen.");
}
@end
