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

- (BOOL)checkItemClassDefaults:(Item *)i {
    // check defaults
    BOOL ok = [i.name isEqualToString:@"Item"] && ![i allInputsValid] && ![i allOutputsValid] &&  i.qty2Purchase == INFINITY;
	return ok;
}

- (void)test01ItemClass {
    Item *i = [Item theItem];
    BOOL ok = [self checkItemClassDefaults:i];
    STAssertTrue(ok, @"Item defaults are incorrect");
    
    // set price
    i.price = 1.0;
    ok = [i.name isEqualToString:@"Item"] && i.price == 1.0 && i.minQty == INFINITY && i.unitsPerItem == INFINITY && ![i allOutputsValid] && i.qty2Purchase == INFINITY;
	STAssertTrue(ok, @"Setting price failed");

    // set minQty
    i.minQty = 1.0;
    ok = [i.name isEqualToString:@"Item"] && i.price == 1.0 && i.minQty == 1.0 && i.unitsPerItem == INFINITY && ![i allOutputsValid] && i.qty2Purchase == INFINITY;
	STAssertTrue(ok, @"Setting minQty failed");

    // set unitsPerItem
    i.unitsPerItem = 1.0;
    ok = [i.name isEqualToString:@"Item"] && i.price == 1.0 && i.minQty == 1.0 && i.unitsPerItem == 1.0 && i.pricePerUnit == 1.0 && i.pricePerItem == 1.0 && i.qty2Purchase == INFINITY && i.amountPurchased == INFINITY;
	STAssertTrue(ok, @"Setting unitsPerItem failed");

    // set qty2Purchase
    i.qty2Purchase = 1.0;
    ok = [i.name isEqualToString:@"Item"] && i.price == 1.0 && i.minQty == 1.0 && i.unitsPerItem == 1.0 && i.pricePerUnit == 1.0 && i.pricePerItem == 1.0 && i.qty2Purchase == 1.0 && i.amountPurchased == 1.0;
	STAssertTrue(ok, @"Setting qty2Purchase failed");
    
    // check initializer
    i = [Item theItemWithName:@"Name" price:1.0 minQty:2.0 unitsPerItem:3.0];
    ok = [i.name isEqualToString:@"Name"] && i.price == 1.0 && i.minQty == 2.0 && i.unitsPerItem == 3.0 && TCE(i.pricePerUnit, (1.0 / 3.0), 0.001) && i.pricePerItem == (1.0 / 2.0) && i.qty2Purchase == INFINITY && i.amountPurchased == INFINITY;
	STAssertTrue(ok, @"Item defaults are incorrect");
    
    // set price
    i.price = 4.0;
    ok = [i.name isEqualToString:@"Name"] && i.price == 4.0 && i.minQty == 2.0 && i.unitsPerItem == 3.0 && TCE(i.pricePerUnit, (4.0 / 3.0), 0.001) && i.pricePerItem == (4.0 / 2.0) && i.qty2Purchase == INFINITY && i.amountPurchased == INFINITY;
	STAssertTrue(ok, @"Setting price failed");
    
    // set minQty
    i.minQty = 5.0;
    ok = [i.name isEqualToString:@"Name"] && i.price == 4.0 && i.minQty == 5.0 && i.unitsPerItem == 3.0 && TCE(i.pricePerUnit, (4.0 / 3.0), 0.001) && TCE(i.pricePerItem, (4.0 / 5.0), 0.001) && i.qty2Purchase == INFINITY && i.amountPurchased == INFINITY;
	STAssertTrue(ok, @"Setting minQty failed");
    
    // set unitsPerItem
    i.unitsPerItem = 6.0;
    ok = [i.name isEqualToString:@"Name"] && i.price == 4.0 && i.minQty == 5.0 && i.unitsPerItem == 6.0 && TCE(i.pricePerUnit, (4.0 / 3.0), 0.001) && TCE(i.pricePerItem, (4.0 / 5.0), 0.001) && i.qty2Purchase == INFINITY && i.amountPurchased == INFINITY;
	STAssertTrue(ok, @"Setting unitsPerItem failed");
    
    // set qty2Purchase
    i.qty2Purchase = 7.0;
    ok = [i.name isEqualToString:@"Name"] && i.price == 4.0 && i.minQty == 5.0 && i.unitsPerItem == 6.0 && TCE(i.pricePerUnit, (4.0 / 3.0), 0.001) && TCE(i.pricePerItem, (4.0 / 5.0), 0.001) && i.qty2Purchase == 7.0 && TCE(i.amountPurchased, (6.0 / 7.0), 0.001);
	STAssertTrue(ok, @"Setting qty2Purchase failed");
    
}

- (void)test02SavingsClass {
    Savings *savings = [Savings theSavings];
    BOOL ok = [savings.itemA.name isEqualToString:@"A"] && ![savings.itemA allInputsValid] && ![savings.itemA allOutputsValid] &&  savings.itemA.qty2Purchase == INFINITY;
    STAssertTrue(ok, @"itemA defaults are wrong");
    ok = [savings.itemB.name isEqualToString:@"B"] && ![savings.itemB allInputsValid] && ![savings.itemB allOutputsValid] &&  savings.itemB.qty2Purchase == INFINITY;
    STAssertTrue(ok, @"itemB defaults are wrong");
    
    savings.itemA = [Item theItemWithName:@"A" price:17 minQty:1 unitsPerItem:100];
    savings.itemB = [Item theItemWithName:@"B" price:11 minQty:1 unitsPerItem:50];
    savings.itemA.qty2Purchase = MAX(savings.itemA.minQty, savings.itemB.minQty);
    CalcResult r = [savings calcSavings];
    STAssertTrue(r == CalcComplete, @"Valid Qty2Buy Test Failed.");
    NSLog(@"%@", savings.toString);
}

/*
- (void)test03SavingsResultsClass {
    SavingsResults *s = [SavingsResults theSavingsResults];
    BOOL ok = s.betterPrice == 0.0 && s.normalizedMinQty == 0.0 && s.totalCost == 0.0 && s.savings == 0.0 && s.amountPurchased == 0.0 && s.percentSavings == 0.0;
    STAssertTrue(ok, @"should all be 0.0");
}

- (void)test04ItemClass {
    Item *i = [Item theItem];
    BOOL ok = [i.name isEqual:@"Item"] && i.price == 0.0 && i.minQty == 0.0 && i.unitsPerItem == 0.0 && i.qty2Purchase == 0.0 && i.pricePerUnit == 0.0 && i.pricePerItem == 0.0 && i.amountPurchased == 0.0;
    STAssertTrue(ok, @"should all Item & 0.0 for the remainder");

	NSString *name = @"A";
	float price = 1.0, minQty = 1.0, unitsPerItem = 1.0, qty2Purchase = 1.0;
	float pricePerItem = price / minQty, amountPurchased = unitsPerItem / qty2Purchase, pricePerUnit = pricePerItem / qty2Purchase;
    i = [Item theItemWithName:name price:price minQty:minQty unitsPerItem:unitsPerItem];
    ok = [i.name isEqual:name] && i.price == price && i.minQty == minQty && i.unitsPerItem == unitsPerItem && i.qty2Purchase == qty2Purchase && i.pricePerItem == pricePerItem && i.amountPurchased == amountPurchased && i.pricePerUnit == pricePerUnit;
    STAssertTrue(ok, @"should all Item & 0.0 for the remainder");
}

 */

@end
