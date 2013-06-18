//
//  NSObject+Formatter.h
//  EvenBetterDeal
//
//  Created by Joe Bologna on 6/17/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Formatter)

- (void)log:(NSString *)s;
- (void)logSelf:(id)obj;
- (NSString *)expandPrefix:(NSString *)prefix ntimes:(NSUInteger)n;
- (NSString *)prefix;

@end

@protocol Logging

- (NSString *)toString;

@end
