//
//  NSObject+Formatter.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "NSObject+Utils.h"

@implementation NSObject (Utils)

- (void)log:(NSString *)s {
    const char *ts = [[NSString stringWithFormat:@"%@\n", s] UTF8String];
    write(2, ts, strlen(ts));
}

- (void)logSelf:(id)obj {
    [self log:(NSString *)[obj toString]];
}

- (NSString *)expandPrefix:(NSString *)prefix ntimes:(NSUInteger)n {
    NSString *s = @"";
    for (NSUInteger i = 0; i < n; i++) {
        s = [s stringByAppendingString:prefix];
    }
    return s;
}

- (NSString *)prefix {
    return @"\t";
}

- (NSString *)fmtPrice:(float)price d:(int)d {
    if (d == 2) {
        return [NSString stringWithFormat:@"%@%.2f", self.currencySymbol, price];
    }
    return [NSString stringWithFormat:@"%@%.3f", self.currencySymbol, price];
}

- (NSString *)currencySymbol {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [numberFormatter currencySymbol];
}

- (DeviceType)getDeviceType {
    // iPhone 4 = 480, iPhone 5 = 568, iPad > 568
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height <= 480) {
        return iPhone4;
    }
    if (height > 480 && height <= 568) {
        return iPhone5;
    }
    return iPad;
}

- (NSString *)getDeviceTypeString {
    switch(self.getDeviceType) {
        case iPhone4: return @"iPhone4";
        case iPhone5: return @"iPhone5";
        case iPad: return @"iPad";
        case UnknownDeviceType: return @"UnknownDeviceType";
        default: return @"Ooops!";
    }
}

- (BOOL)isPhone {
    DeviceType d = [self getDeviceType];
    return (d == iPhone4 || d == iPhone5);
}
@end
