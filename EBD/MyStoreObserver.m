//
//  MyStoreObserver.m
//  EBD
//
//  Created by Joe Bologna on 6/7/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

// http://www.tutorialspoint.com/ios/ios_delegates.htm

#import "MyStoreObserver.h"

@implementation MyStoreObserver

static MyStoreObserver *theSharedObject = nil;

@synthesize myProducts = _myProducts;
@synthesize delegate = _delegate;

// setters/getters
- (void)setBought:(BOOL)newValue {
    //    NSLog(@"%s, %@", __func__, newValue ? vYes : vNo);
    bought = newValue;
    
    // Set up the preference.
    CFPreferencesSetAppValue(kBought, (newValue ? vYes : vNo), kCFPreferencesCurrentApplication);
    
    // Write out the preference data.
    CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
}

- (BOOL)bought {
    CFStringRef boughtStr;
    
    // Read the preference.
    boughtStr = (CFStringRef)CFPreferencesCopyAppValue(kBought, kCFPreferencesCurrentApplication);
    if (boughtStr == nil) {
        boughtStr = vNo;
    }
    CFComparisonResult r = CFStringCompare(boughtStr, vYes, kCFCompareCaseInsensitive);
    bought = (r == kCFCompareEqualTo);
    
    // When finished with value, you must release it
    // CFRelease(boughtStr);
    //    NSLog(@"%s, bought is: %@", __func__, bought ? vYes : vNo);
    return bought;
}

+ (MyStoreObserver *)myStoreObserver {
    if (theSharedObject == nil) {
        theSharedObject = [[super allocWithZone:NULL] init];
        theSharedObject.myProducts = [NSArray array];
        theSharedObject.bought = NO;
        theSharedObject.delegate = nil;
    }
    return theSharedObject;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self myStoreObserver];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void) completeTransaction:(SKPaymentTransaction *)transaction {
    // Your application should implement these two methods.
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void) restoreTransaction:(SKPaymentTransaction *)transaction {
    [self recordTransaction:transaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void) failedTransaction:(SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Optionally, display an error here.
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void) recordTransaction:(SKPaymentTransaction *)transaction {
    self.bought = YES;
}

- (void) provideContent:(NSString *)productIdentifier {
    NSLog(@"%s", __func__);
    [self.delegate processCompleted];
}

@end
