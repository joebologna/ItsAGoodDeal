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

// test exceptions.
- (void)test01SavingsClass {
    Savings *savings = [Savings theSavings];

    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:2 size:1 qty2Buy:0];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:2 size:1 qty2Buy:0];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception");

    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:2 size:1 qty2Buy:1];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:2 size:1 qty2Buy:0];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception");

    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:2 size:1 qty2Buy:0];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:2 size:1 qty2Buy:1];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception");

    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:2 size:1 qty2Buy:1];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:2 size:1 qty2Buy:1];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:2 size:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:2 size:1 qty2Buy:1];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:0 size:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:2 size:1 qty2Buy:2];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:2 size:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:0 size:1 qty2Buy:2];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:0 size:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:0 size:1 qty2Buy:2];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:-1 size:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:0 size:1 qty2Buy:2];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:-1 size:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:-1 size:1 qty2Buy:2];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:1 size:1 qty2Buy:-1];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:1 size:1 qty2Buy:2];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:1 size:1 qty2Buy:-1];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:1 size:1 qty2Buy:-1];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception");

    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 qty:1 size:1 qty2Buy:1];
    savings.itemB = [Item theItemWithName:@"B" price:1 qty:1 size:1 qty2Buy:2];
    STAssertThrows([savings calcSavings], @"Expected qty2Buy exception (they should be equal)");
}

// test with same size & same qty2Buy for each
- (void)test02SavingsClass {
    NSNumber *zero = [NSNumber numberWithFloat:0];
    Savings *savings = [Savings theSavings];
    
    for (int i = 1; i <= 2; i++) {
        // same price
        savings.itemA = [Item theItemWithName:@"A" price:1 qty:1 size:1 qty2Buy:i];
        savings.itemB = [Item theItemWithName:@"B" price:1 qty:1 size:1 qty2Buy:i];
        [savings calcSavings];
        STAssertEqualObjects([NSNumber numberWithFloat:savings.moneySaved], zero, @"Should be 0");
        
        // A is cheaper
        savings.itemA = [Item theItemWithName:@"A" price:0.5 qty:1 size:1 qty2Buy:i];
        savings.itemB = [Item theItemWithName:@"B" price:1 qty:1 size:1 qty2Buy:i];
        [savings calcSavings];
        STAssertEqualObjects(
                             [NSNumber numberWithFloat:savings.moneySaved],
                             [NSNumber numberWithFloat:0.5 * i],
                             [NSString stringWithFormat:@"Should be %.2f", 0.5 * i]);
        
        // B is cheaper
        savings.itemA = [Item theItemWithName:@"A" price:1 qty:1 size:1 qty2Buy:i];
        savings.itemB = [Item theItemWithName:@"B" price:0.5 qty:1 size:1 qty2Buy:i];
        [savings calcSavings];
        STAssertEqualObjects(
                             [NSNumber numberWithFloat:savings.moneySaved],
                             [NSNumber numberWithFloat:0.5 * i],
                             [NSString stringWithFormat:@"Should be %.2f", 0.5 * i]);
    }
}

// test with different sizes & same qty2Buy for each
- (void)test03SavingsClass {
    Savings *savings = [Savings theSavings];
    
    for (int i = 1; i <= 2; i++) {
        // same price
        savings.itemA = [Item theItemWithName:@"A" price:1 qty:1 size:1 qty2Buy:i];
        savings.itemB = [Item theItemWithName:@"B" price:1 qty:1 size:2 qty2Buy:i];
        [savings calcSavings];
        STAssertEqualObjects([NSNumber numberWithFloat:savings.moneySaved],
                             [NSNumber numberWithFloat:0 * i],
                             [NSString stringWithFormat:@"(%d)", i]);
        
        // A is cheaper
        savings.itemA = [Item theItemWithName:@"A" price:0.5 qty:1 size:1 qty2Buy:i];
        savings.itemB = [Item theItemWithName:@"B" price:1 qty:1 size:2 qty2Buy:i];
        [savings calcSavings];
        STAssertEqualObjects(
                             [NSNumber numberWithFloat:savings.moneySaved],
                             [NSNumber numberWithFloat:0 * i],
                             [NSString stringWithFormat:@"(%d)", i]);
        
        // B is cheaper
        savings.itemA = [Item theItemWithName:@"A" price:1 qty:1 size:1 qty2Buy:i];
        savings.itemB = [Item theItemWithName:@"B" price:0.5 qty:1 size:2 qty2Buy:i];
        [savings calcSavings];
        STAssertEqualObjects(
                             [NSNumber numberWithFloat:savings.moneySaved],
                             [NSNumber numberWithFloat:0.5 * i],
                             [NSString stringWithFormat:@"(%d)", i]);
    }
}

// test with different sizes & same qty2Buy for each, determine how much more/less product you get
- (void)test05SavingsClass {
    Savings *savings = [Savings theSavings];
    
    // same price
    savings.itemA = [Item theItemWithName:@"A" price:5 qty:2 size:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:5 qty:2 size:2 qty2Buy:2];
    [savings calcSavings];
    STAssertEqualObjects(
                         [NSNumber numberWithFloat:savings.moneySaved],
                         [NSNumber numberWithFloat:0],
                         [NSString stringWithFormat:@"Should be %.2f", 1.0]);
    STAssertEqualObjects(
                         [NSNumber numberWithFloat:savings.sizeDiff],
                         [NSNumber numberWithFloat:1],
                         [NSString stringWithFormat:@"Should be %.2f", 1.0]);
}
@end
