//
//  IGDUnitTests.m
//  IGDUnitTests
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "IGDUnitTests.h"
#import "Savings.h"

@interface IGDUnitTests () {
};
@end;

@implementation IGDUnitTests

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
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:NO_QTY unitsPerItem:1 qty2Buy:NO_QTY];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:2 unitsPerItem:1 qty2Buy:0];
    STAssertTrue([savings calcSavings] == CalcIncomplete, @"Incomplete Qty Test Failed.");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:2 unitsPerItem:1 qty2Buy:NO_QTY];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:2 unitsPerItem:1 qty2Buy:0];
    STAssertTrue([savings calcSavings] == NeedQty2Buy, @"Incomplete Qty Test Failed.");

    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:2 unitsPerItem:1 qty2Buy:0];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:2 unitsPerItem:1 qty2Buy:NO_QTY];
    STAssertTrue([savings calcSavings] == NeedQty2Buy, @"Incomplete Qty Test Failed.");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:2 unitsPerItem:1 qty2Buy:NO_QTY];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:2 unitsPerItem:1 qty2Buy:NO_QTY];
    STAssertTrue([savings calcSavings] == NeedQty2Buy, @"Incomplete Qty Test Failed.");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:2 unitsPerItem:1 qty2Buy:0];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:2 unitsPerItem:1 qty2Buy:0];
    STAssertTrue([savings calcSavings] == NeedQty2Buy, @"Qty Test Failed.");

    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:2 unitsPerItem:1 qty2Buy:1];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:2 unitsPerItem:1 qty2Buy:0];
    STAssertTrue([savings calcSavings] == NeedQty2Buy, @"Qty Test Failed.");

    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:2 unitsPerItem:1 qty2Buy:0];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:2 unitsPerItem:1 qty2Buy:1];
    STAssertTrue([savings calcSavings] == NeedQty2Buy, @"Qty Test Failed.");

    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:2 unitsPerItem:1 qty2Buy:1];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:2 unitsPerItem:1 qty2Buy:1];
    STAssertTrue([savings calcSavings] == NeedQty2Buy, @"Qty Test Failed.");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:2 unitsPerItem:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:2 unitsPerItem:1 qty2Buy:1];
    STAssertTrue([savings calcSavings] == NeedQty2Buy, @"Qty Test Failed.");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:0 unitsPerItem:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:2 unitsPerItem:1 qty2Buy:2];
    STAssertTrue([savings calcSavings] == CalcIncomplete, @"Qty Test Failed.");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:2 unitsPerItem:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:0 unitsPerItem:1 qty2Buy:2];
    STAssertTrue([savings calcSavings] == CalcIncomplete, @"Qty Test Failed.");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:0 unitsPerItem:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:0 unitsPerItem:1 qty2Buy:2];
    STAssertTrue([savings calcSavings] == CalcIncomplete, @"Qty Test Failed.");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:NO_QTY unitsPerItem:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:0 unitsPerItem:1 qty2Buy:2];
    STAssertTrue([savings calcSavings] == CalcIncomplete, @"Qty Test Failed.");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:NO_QTY unitsPerItem:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:NO_QTY unitsPerItem:1 qty2Buy:2];
    STAssertTrue([savings calcSavings] == CalcIncomplete, @"Qty Test Failed.");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:1 unitsPerItem:1 qty2Buy:-1];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:1 unitsPerItem:1 qty2Buy:2];
    STAssertTrue([savings calcSavings] == NeedQty2Buy, @"Qty Test Failed.");
    
    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:1 unitsPerItem:1 qty2Buy:-1];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:1 unitsPerItem:1 qty2Buy:-1];
    STAssertTrue([savings calcSavings] == NeedQty2Buy, @"Qty Test Failed.");

    [self log:@""];
    savings.itemA = [Item theItemWithName:@"A" price:1.5 minQty:1 unitsPerItem:1 qty2Buy:1];
    savings.itemB = [Item theItemWithName:@"B" price:1 minQty:1 unitsPerItem:1 qty2Buy:2];
    STAssertTrue([savings calcSavings] == NeedQty2Buy, @"Qty Test Failed.");
}

// test with same unitsPerItem & same qty2Buy for each
- (void)test02SavingsClass {
    NSNumber *zero = [NSNumber numberWithFloat:0];
    Savings *savings = [Savings theSavings];
    
    for (int i = 1; i <= 2; i++) {
        // same price
        savings.itemA = [Item theItemWithName:@"A" price:1 minQty:1 unitsPerItem:1 qty2Buy:i];
        savings.itemB = [Item theItemWithName:@"B" price:1 minQty:1 unitsPerItem:1 qty2Buy:i];
        STAssertTrue([savings calcSavings] == CalcComplete, @"Qty Test Failed.");
        STAssertEqualObjects([NSNumber numberWithFloat:savings.moneySaved], zero, @"Should be 0");
        
        // A is cheaper
        savings.itemA = [Item theItemWithName:@"A" price:0.5 minQty:1 unitsPerItem:1 qty2Buy:i];
        savings.itemB = [Item theItemWithName:@"B" price:1 minQty:1 unitsPerItem:1 qty2Buy:i];
        STAssertTrue([savings calcSavings] == CalcComplete, @"Qty Test Failed.");
        STAssertEqualObjects(
                             [NSNumber numberWithFloat:savings.moneySaved],
                             [NSNumber numberWithFloat:0.5 * i],
                             [NSString stringWithFormat:@"Should be %.2f", 0.5 * i]);
        
        // B is cheaper
        savings.itemA = [Item theItemWithName:@"A" price:1 minQty:1 unitsPerItem:1 qty2Buy:i];
        savings.itemB = [Item theItemWithName:@"B" price:0.5 minQty:1 unitsPerItem:1 qty2Buy:i];
        STAssertTrue([savings calcSavings] == CalcComplete, @"Qty Test Failed.");
        STAssertEqualObjects(
                             [NSNumber numberWithFloat:savings.moneySaved],
                             [NSNumber numberWithFloat:0.5 * i],
                             [NSString stringWithFormat:@"Should be %.2f", 0.5 * i]);
    }
}

// test with different unitsPerItems & same qty2Buy for each
- (void)test03SavingsClass {
    Savings *savings = [Savings theSavings];
    
    for (int i = 1; i <= 2; i++) {
        // same price
        savings.itemA = [Item theItemWithName:@"A" price:1 minQty:1 unitsPerItem:1 qty2Buy:i];
        savings.itemB = [Item theItemWithName:@"B" price:1 minQty:1 unitsPerItem:2 qty2Buy:i];
        STAssertTrue([savings calcSavings] == CalcComplete, @"Qty Test Failed.");
        STAssertEqualObjects([NSNumber numberWithFloat:savings.moneySaved],
                             [NSNumber numberWithFloat:0 * i],
                             [NSString stringWithFormat:@"(%d)", i]);
        
        // A is cheaper
        savings.itemA = [Item theItemWithName:@"A" price:0.5 minQty:1 unitsPerItem:1 qty2Buy:i];
        savings.itemB = [Item theItemWithName:@"B" price:1 minQty:1 unitsPerItem:2 qty2Buy:i];
        STAssertTrue([savings calcSavings] == CalcComplete, @"Qty Test Failed.");
        STAssertEqualObjects(
                             [NSNumber numberWithFloat:savings.moneySaved],
                             [NSNumber numberWithFloat:0 * i],
                             [NSString stringWithFormat:@"(%d)", i]);
        
        // B is cheaper
        savings.itemA = [Item theItemWithName:@"A" price:1 minQty:1 unitsPerItem:1 qty2Buy:i];
        savings.itemB = [Item theItemWithName:@"B" price:0.5 minQty:1 unitsPerItem:2 qty2Buy:i];
        STAssertTrue([savings calcSavings] == CalcComplete, @"Qty Test Failed.");
        STAssertEqualObjects(
                             [NSNumber numberWithFloat:savings.moneySaved],
                             [NSNumber numberWithFloat:0.5 * i],
                             [NSString stringWithFormat:@"(%d)", i]);
    }
}

// test with different unitsPerItems & same qty2Buy for each, determine how much more/less product you get
- (void)test05SavingsClass {
    Savings *savings = [Savings theSavings];
    
    // same price, 2 more units
    savings.itemA = [Item theItemWithName:@"A" price:5 minQty:2 unitsPerItem:1 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:5 minQty:2 unitsPerItem:2 qty2Buy:2];
    STAssertTrue([savings calcSavings] == CalcComplete, @"Qty Test Failed.");
    STAssertEqualObjects(
                         savings.getBest.name,
                         @"B",
                         @"");
    STAssertEqualObjects(
                         [NSNumber numberWithFloat:savings.moneySaved],
                         [NSNumber numberWithFloat:0],
                         @"");
    STAssertEqualObjects(
                         [NSNumber numberWithFloat:savings.sizeDiff],
                         [NSNumber numberWithFloat:2],
                         @"");
    
    // same price, 2 more units
    savings.itemA = [Item theItemWithName:@"A" price:5 minQty:2 unitsPerItem:2 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:5 minQty:2 unitsPerItem:1 qty2Buy:2];
    STAssertTrue([savings calcSavings] == CalcComplete, @"Qty Test Failed.");
    STAssertEqualObjects(
                         savings.getBest.name,
                         @"A",
                         @"");
    STAssertEqualObjects(
                         [NSNumber numberWithFloat:savings.moneySaved],
                         [NSNumber numberWithFloat:0],
                         @"");
    STAssertEqualObjects(
                         [NSNumber numberWithFloat:savings.sizeDiff],
                         [NSNumber numberWithFloat:2],
                         @"");
}

// test with different price, different sizes & same qty2Buy for each, determine how much more/less product you get
- (void)test06SavingsClass {
    Savings *savings = [Savings theSavings];
    
    savings.itemA = [Item theItemWithName:@"A" price:3 minQty:2 unitsPerItem:7.5 qty2Buy:2];
    savings.itemB = [Item theItemWithName:@"B" price:2 minQty:1 unitsPerItem:8.5 qty2Buy:2];
    STAssertTrue([savings calcSavings] == CalcComplete, @"Qty Test Failed.");
    STAssertEqualObjects(
                         savings.getBest.name,
                         @"A",
                         @"");
    STAssertEqualObjects(
                         [NSNumber numberWithFloat:savings.moneySaved],
                         [NSNumber numberWithFloat:1],
                         @"");
    STAssertEqualObjects(
                         [NSNumber numberWithFloat:savings.sizeDiff],
                         [NSNumber numberWithFloat:-2],
                         @"");
    BOOL test = savings.percentFewerUnits < 0;
    STAssertTrue(test, @"");
    test = ABS((savings.moneySaved - savings.adjMoneySaved)) < 0.12;
    STAssertTrue(test, @"");
}

// test requiring qty2Buy, multiple of qty required
- (void)test07SavingsClass {
    Savings *savings = [Savings theSavings];
    
    savings.itemA = [Item theItemWithName:@"A" price:3 minQty:2 unitsPerItem:7.5 qty2Buy:3];
    savings.itemB = [Item theItemWithName:@"B" price:2 minQty:1 unitsPerItem:8.5 qty2Buy:2];
    CalcResult r = [savings calcSavings];
    STAssertTrue(r == NeedQty2Buy, @"Valid Qty2Buy Test Failed.");
    savings.itemB = [Item theItemWithName:@"B" price:2 minQty:2 unitsPerItem:8.5 qty2Buy:3];
    r = [savings calcSavings];
    STAssertTrue(r == NeedValidQty2Buy, @"Valid Qty2Buy Test Failed.");
}

// different price, same qty, different unitsPerItem
- (void)test08SavingsClass {
    Savings *savings = [Savings theSavings];
    
    savings.itemA = [Item theItemWithName:@"A" price:17 minQty:1 unitsPerItem:100 qty2Buy:1];
    savings.itemB = [Item theItemWithName:@"B" price:11 minQty:1 unitsPerItem:50 qty2Buy:1];
    CalcResult r = [savings calcSavings];
    STAssertTrue(r == CalcComplete, @"Valid Qty2Buy Test Failed.");
    NSLog(@"%@", savings.toString);
}

- (void)test09UnitTestSavingsResults {
    SavingsResults *s = [SavingsResults theSavingsResults];
    BOOL ok = s.betterPrice == 0.0 && s.normalizedMinQty == 0.0 && s.totalCost == 0.0 && s.savings == 0.0 && s.amountPurchased == 0.0 && s.percentSavings == 0.0;
    STAssertTrue(ok, @"should all be 0.0");
}

- (void)test10UnitTestItem {
    Item *i = [Item theItem];
    BOOL ok = [i.name isEqual:@"Item"] && i.price == 0.0 && i.minQty == 0.0 && i.unitsPerItem == 0.0 && i.qty2Buy == 0.0 && i.pricePerUnit == 0.0 && i.pricePerItem == 0.0 && i.amountPurchased == 0.0;
    STAssertTrue(ok, @"should all Item & 0.0 for the remainder");

	NSString *name = @"A";
	float price = 1.0, minQty = 1.0, unitsPerItem = 1.0, qty2Buy = 1.0;
	float pricePerItem = price / minQty, amountPurchased = unitsPerItem / qty2Buy, pricePerUnit = pricePerItem / qty2Buy;
    i = [Item theItemWithName:name price:price minQty:minQty unitsPerItem:unitsPerItem qty2Buy:qty2Buy];
    ok = [i.name isEqual:name] && i.price == price && i.minQty == minQty && i.unitsPerItem == unitsPerItem && i.qty2Buy == qty2Buy && i.pricePerItem == pricePerItem && i.amountPurchased == amountPurchased && i.pricePerUnit == pricePerUnit;
    STAssertTrue(ok, @"should all Item & 0.0 for the remainder");
}

@end
