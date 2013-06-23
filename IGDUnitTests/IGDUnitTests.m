//
//  IGDUnitTests.m
//  IGDUnitTests
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "IGDUnitTests.h"
#import "NewSavings.h"

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
    i.price = 3.0;
    ok = [i.name isEqualToString:@"Item"] && TCE(i.price, i.price) && i.minQty == INFINITY && i.unitsPerItem == INFINITY && ![i allOutputsValid] && i.qty2Purchase == INFINITY;
	STAssertTrue(ok, @"Setting price failed");

    // set minQty
    i.minQty = 2.0;
    ok = [i.name isEqualToString:@"Item"] && TCE(i.price, i.price) && TCE(i.minQty, i.minQty) && i.unitsPerItem == INFINITY && ![i allOutputsValid] && i.qty2Purchase == INFINITY;
	STAssertTrue(ok, @"Setting minQty failed");

    // set unitsPerItem
    i.unitsPerItem = 1.56;
    ok = [i.name isEqualToString:@"Item"] &&  TCE(i.price, i.price) &&  TCE(i.minQty, i.minQty) &&  TCE(i.unitsPerItem, i.unitsPerItem) &&  TCE(i.pricePerUnit, (i.pricePerItem / i.unitsPerItem)) &&  TCE(i.pricePerItem, (i.price / i.minQty)) &&  i.qty2Purchase == INFINITY &&  i.amountPurchased == INFINITY;
	STAssertTrue(ok, @"Setting unitsPerItem failed");

    // set qty2Purchase
	i.qty2Purchase = 4.0;
	ok = [i.name isEqualToString:@"Item"] && TCE(i.price, i.price) && TCE(i.minQty, i.minQty) && TCE(i.unitsPerItem, i.unitsPerItem) && TCE(i.pricePerUnit, (i.pricePerItem / i.unitsPerItem)) && TCE(i.pricePerItem, (i.price / i.minQty)) && TCE(i.qty2Purchase, i.qty2Purchase) && TCE(i.amountPurchased, (i.unitsPerItem * i.qty2Purchase));
	STAssertTrue(ok, @"Setting qty2Purchase failed");
    
    // check initializer
    i = [Item theItemWithName:@"Name" price:1.0 minQty:2.0 unitsPerItem:3.0];
    ok = [i.name isEqualToString:@"Name"]  && TCE(i.price, 1.0)  && TCE(i.minQty, 2.0)  && TCE(i.unitsPerItem, 3.0)  && TCE(i.pricePerUnit, (1.0 / 3.0))  && TCE(i.pricePerItem, (1.0 / 2.0))  && i.qty2Purchase == INFINITY  && i.amountPurchased == INFINITY;
	STAssertTrue(ok, @"Item defaults are incorrect");
}

- (void)test02NewSavingsClass {
    NewSavings *s = [NewSavings theNewSavings];
    STAssertTrue(!s.isReady, @"Should be notReady");
    
    Item *itemA = [Item theItemWithName:@"A" price:3.0 minQty:2.0 unitsPerItem:1.56];
    Item *itemB = [Item theItemWithName:@"B" price:2.0 minQty:1.0 unitsPerItem:1.98];
    s = [NewSavings theNewSavingsWithItemA:itemA withItemB:itemB];
    STAssertTrue(s.calcState == NeedQty2Purchase, @"!!");
    
    s.qty2Purchase = 4.0;
    STAssertTrue(s.isReady, @"Should be ready");
    STAssertTrue(s.calcState == CalcComplete, @"!!");
    STAssertTrue(TCE(s.qty2Purchase, 4.0), @"!!");
    STAssertTrue(TCE(s.betterPrice, 0.96), @"!!");
    STAssertTrue(TCE(s.normalizedMinQty, 2.0), @"!!");
    STAssertTrue(TCE(s.totalCost, 6.0), @"!!");
    STAssertTrue(TCE(s.totalCostA, 6.0), @"!!");
    STAssertTrue(TCE(s.totalCostB, 8.0), @"!!");
    STAssertTrue(TCE(s.savings, 2.0), @"!!");
    STAssertTrue(TCE(s.savingsA, 2.0), @"!!");
    STAssertTrue(TCE(s.savingsB, 0.0), @"!!");
    STAssertTrue(TCE(s.amountPurchased, 6.24), @"!!");
    STAssertTrue(TCE(s.amountPurchasedA, 6.24), @"!!");
    STAssertTrue(TCE(s.amountPurchasedB, 7.92), @"!!");
    STAssertTrue(TCE(s.percentSavings, 0.25), @"!!");
    STAssertTrue(TCE(s.percentSavingsA, 0.25), @"!!");
    STAssertTrue(TCE(s.percentSavingsB, 0.0), @"!!");
    STAssertTrue(TCE(s.percentMoreA, -0.5), @"!!");
    STAssertTrue(TCE(s.percentMoreB, 0.0), @"!!");
}
@end
