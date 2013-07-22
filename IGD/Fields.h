//
//  Fields.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Field.h"

#define STORE "Remove Ads"
#define THANKS "Thank You"
#define CLR "C"
#define NEXT "Next"
#define DEL "Del"

typedef enum {
    iPhone4, iPhone5, iPad, UnknownDeviceType
} DeviceType;

typedef enum {
    ShowPrompt,
    ShowResult
} MessageMode;

@interface Fields : NSObject

- (Fields *)makeFields:(UIViewController *)vc;
- (void)populateScreen;
- (void)fieldWasSelected:(Field *)field;

@property (unsafe_unretained, nonatomic) DeviceType deviceType;
@property (strong, nonatomic, readonly) NSString *toString, *deviceTypeString;
@property (strong, nonatomic) Field *itemA, *itemB, *betterDealA, *betterDealB, *priceA, *priceB, *qtyA, *qtyB, *sizeA, *sizeB, *qty2BuyA, *qty2BuyB, *message, *costField, *savingsField, *moreField, *costLabel, *savingsLabel, *moreLabel, *ad, *one, *two, *three, *clr, *four, *five, *six, *store, *seven, *eight, *nine, *del, *period, *zero, *next;
@property (strong, nonatomic) NSArray *inputFields, *allFields, *keys;
@property (weak, nonatomic) UIViewController *vc;
@property (strong, nonatomic) Field *curField;

@property (unsafe_unretained, nonatomic) MessageMode messageMode;

@end
