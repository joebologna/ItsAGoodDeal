//
//  MyStoreObserver.h
//  EBD
//
//  Created by Joe Bologna on 6/7/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kBought CFSTR("bought")
#define vNo CFSTR("NO")
#define vYes CFSTR("YES")

@protocol MyStoreObserverDelegate <NSObject>
@required
- (void)processCompleted;
@end

@interface MyStoreObserver : NSObject <SKPaymentTransactionObserver> {
    BOOL bought;
    NSArray *myProducts;
    id <MyStoreObserverDelegate> delegate;
}

+ (MyStoreObserver *)myStoreObserver;

@property (unsafe_unretained, nonatomic) BOOL bought;
@property (nonatomic, strong) NSArray *myProducts;
@property (nonatomic, strong) id <MyStoreObserverDelegate> delegate;

@end
