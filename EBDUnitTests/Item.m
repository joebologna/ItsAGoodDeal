//
//  Item.m
//  EvenBetterDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize toString = _toString;
- (NSString *)toString {
    return [NSString stringWithFormat:@"%@ {.price: %.2f, .qty: %.2f, .size: %.2f, .qty2Buy: %.2f, .unitCost: %.2f}", self.name, self.price, self.qty, self.size, self.qty2Buy, self.unitCost];
}

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"%s", __func__);
        self.name = @"Item";
        self.price = 0;
        self.qty = 0;
        self.size = 0;
        self.unitCost = 0;
    }
    return self;
}

+ (Item *)theItem {
    return [[Item alloc] init];
}

+ (Item *)theItemWithName:(NSString *)name price:(float)price qty:(float)qty size:(float)size qty2Buy:(float)qty2Buy {
    Item *item = [[Item alloc] init];
    item.price = price;
    item.name = name;
    item.qty = qty;
    item.size = size;
    item.qty2Buy = qty2Buy;
    item.unitCost = price / qty / size;
    return item;
}

@end
