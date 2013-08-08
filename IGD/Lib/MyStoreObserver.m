//
//  MyStoreObserver.m
//  IGD
//
//  Created by Joe Bologna on 6/7/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

// po [NSUserDefaults resetStandardUserDefaults] to reset prefs.
//
// http://www.tutorialspoint.com/ios/ios_delegates.htm

#import "MyStoreObserver.h"

@implementation MyStoreObserver

static MyStoreObserver *theSharedObject = nil;

@synthesize myProducts = _myProducts;
@synthesize delegate = _delegate;
@synthesize bought = _bought;

- (void)setBought:(BOOL)newValue {
    
    [[NSUserDefaults standardUserDefaults] setBool:newValue forKey:kBought];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _bought = [[NSUserDefaults standardUserDefaults] boolForKey:kBought];
    if (_bought != newValue) {
        abort();
    }
}

- (BOOL)bought {
    _bought = [[NSUserDefaults standardUserDefaults] boolForKey:kBought];
    return _bought;
}

+ (MyStoreObserver *)myStoreObserver {
    if (theSharedObject == nil) {
        theSharedObject = [[super allocWithZone:NULL] init];
        theSharedObject.myProducts = [NSArray array];
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
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
#ifdef DEBUG
                NSLog(@"%s, purchase succeeded", __func__);
#endif
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
#ifdef DEBUG
                NSLog(@"%s, payment failed", __func__);
#endif
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
#ifdef DEBUG
                NSLog(@"%s, purchase restored", __func__);
#endif
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
#ifdef DEBUG
                NSLog(@"%s, purchase in progress", __func__);
#endif
                break;
            default:
                break;
        }
    }
}

- (void) completeTransaction:(SKPaymentTransaction *)transaction {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    // Your application should implement these two methods.
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void) restoreTransaction:(SKPaymentTransaction *)transaction {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if (transaction.transactionState == SKPaymentTransactionStateRestored) {
        [self recordTransaction:transaction];
        [self provideContent:transaction.originalTransaction.payment.productIdentifier];
        @try {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
        @catch (NSException *exception) {
            NSLog(@"%s:Ignoring %@", __func__, exception);
        }
    }
}

- (void) failedTransaction:(SKPaymentTransaction *)transaction {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Optionally, display an error here.
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void) recordTransaction:(SKPaymentTransaction *)transaction {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    self.bought = YES;
}

- (void) provideContent:(NSString *)productIdentifier {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self.delegate processCompleted];
}

- (void)showProductInfo {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//    NSString *c = [numberFormatter currencySymbol];

    for (int i = 0; i < self.myProducts.count; i++) {
        NSLog(@"[%d]: localedDescription: %@", i, ((SKProduct *)self.myProducts[i]).localizedDescription);
        NSLog(@"[%d]: localizedTitle: %@", i, ((SKProduct *)self.myProducts[i]).localizedTitle);
        NSString *s = [NSNumberFormatter localizedStringFromNumber:((SKProduct *)self.myProducts[i]).price numberStyle:NSNumberFormatterCurrencyStyle];
        NSLog(@"[%d]: price: %@; %@", i, ((SKProduct *)self.myProducts[i]).price, s);
        NSLog(@"[%d]: priceLocale: %@", i, ((SKProduct *)self.myProducts[i]).priceLocale);
        NSLog(@"[%d]: localizedTitle: %@", i, ((SKProduct *)self.myProducts[i]).localizedTitle);
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self restoreTransaction:nil];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"%s:%@", __func__, error);
#endif
}
@end
