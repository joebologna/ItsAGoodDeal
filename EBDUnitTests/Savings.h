//
//  Savings.h
//  EvenBetterDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface Savings : NSObject <Logging>

@property (strong, nonatomic) Item *itemA, *itemB;
@property (unsafe_unretained, nonatomic) float moneySaved;
@property (unsafe_unretained, nonatomic) float sizeDiff;
@property (unsafe_unretained, nonatomic) float percentFewerUnits;
@property (unsafe_unretained, nonatomic) float adjMoneySaved;

@property (strong, nonatomic) NSString *toString;
@property (readonly, nonatomic) NSArray *dictionaryFormat;

+ (Savings *)theSavings;
+ (Savings *)theSavingsWithItemA:(Item *)itemA itemB:(Item *)itemB;
- (Item *)getBest;
- (Item *)getWorst;
- (void)calcSavings;

@end
