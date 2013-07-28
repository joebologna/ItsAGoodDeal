//
//  NSObject+Utils.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    iPhone4, iPhone5, iPad, UnknownDeviceType
} DeviceType;

@interface NSObject (Utils)

- (void)log:(NSString *)s;
- (void)logSelf:(id)obj;
- (NSString *)expandPrefix:(NSString *)prefix ntimes:(NSUInteger)n;
- (NSString *)prefix;
- (NSString *)fmtPrice:(float)price;
- (NSString *)currencySymbol;
- (DeviceType)getDeviceType;
- (NSString *)getDeviceTypeString;
- (BOOL)isPhone;

@end

@protocol Logging

- (NSString *)toString;

@end
