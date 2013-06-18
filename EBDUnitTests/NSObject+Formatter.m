//
//  NSObject+Formatter.m
//  EvenBetterDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "NSObject+Formatter.h"

@implementation NSObject (Formatter)

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
@end
