//
//  AppDelegate.m
//  IGD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize myStoreObserver = _myStoreObserver;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.myStoreObserver = [MyStoreObserver myStoreObserver];
#ifdef DEBUG
    NSLog(@"bought: %d", self.myStoreObserver.bought);
#endif
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self.myStoreObserver];
    [self requestProductData];
    return YES;
}

- (void) requestProductData {
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"com.focusedforsuccess.ItsAGoodDeal.removeads"]];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
#ifdef DEBUG
    NSLog(@"valid: %@", response.products);
    NSLog(@"invalid: %@", response.invalidProductIdentifiers);
#endif
    self.myStoreObserver.myProducts = response.products;
#ifdef DEBUG
    NSLog(@"%s, %@", __func__, self.myStoreObserver.myProducts);
    [self.myStoreObserver showProductInfo];
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}
@end
