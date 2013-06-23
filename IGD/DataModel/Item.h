//
//  Item.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Lib/NSObject+Formatter.h"

#define NO_QTY -1
// thats close enough
#define TCE(A, B) ((truncf(A) * (100)) == (truncf(B) * (100)))

@interface Item : NSObject <Logging>


@property (copy, nonatomic) NSString *name;
@property (unsafe_unretained, nonatomic) float price, minQty, unitsPerItem;
@property (unsafe_unretained, nonatomic) float qty2Purchase;
@property (unsafe_unretained, nonatomic, readonly) float pricePerUnit, pricePerItem, amountPurchased;

@property (strong, nonatomic) NSString *toString;

+ (Item *)theItem;
+ (Item *)theItemWithName:(NSString *)name price:(float)price minQty:(float)minQty unitsPerItem:(float)unitsPerItem;

- (BOOL)allInputsValid;
- (BOOL)allOutputsValid;
- (BOOL)qty2PurchaseValid;
- (BOOL)isValid;

@end
