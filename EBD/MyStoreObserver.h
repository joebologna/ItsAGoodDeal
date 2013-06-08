//
//  MyStoreObserver.h
//  EBD
//
//  Created by Joe Bologna on 6/7/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface MyStoreObserver : NSObject <SKPaymentTransactionObserver> {
    NSArray *myProducts;
}

+ (MyStoreObserver *)myStoreObserver;

@property (nonatomic, strong) NSArray *myProducts;

@end
