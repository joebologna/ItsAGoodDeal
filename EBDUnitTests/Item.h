//
//  Item.h
//  EvenBetterDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Formatter.h"

#define NO_QTY -1

@interface Item : NSObject <Logging>


@property (copy, nonatomic) NSString *name;
@property (unsafe_unretained, nonatomic) float price, qty, size, unitCost, pricePerItem, qty2Buy, sizeBought;

@property (strong, nonatomic) NSString *toString;

+ (Item *)theItem;
+ (Item *)theItemWithName:(NSString *)name price:(float)price qty:(float)qty size:(float)size qty2Buy:(float)qty2Buy;

@end
