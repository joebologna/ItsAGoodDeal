//
//  AppDelegate.m
//  IGD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "IGDViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate

@synthesize drawerController;
@synthesize myStoreObserver = _myStoreObserver;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    IGDViewController *center = [[IGDViewController alloc] init];
    LeftViewController *left = [[LeftViewController alloc] init];
    left.cvc = center;

    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:center
                             leftDrawerViewController:left
                             rightDrawerViewController:nil];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
//    CGFloat drawerWidth = w <= 320 ? w * 0.75 : w * 0.25;
    CGFloat drawerWidth = w * 0.75;
    [self.drawerController setMaximumLeftDrawerWidth:drawerWidth];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    left.d = self.drawerController;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.drawerController];

    self.myStoreObserver = [MyStoreObserver myStoreObserver];
#ifdef DEBUG
    NSLog(@"%s, bought: %d", __func__, self.myStoreObserver.bought);
#endif
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self.myStoreObserver];
    [self requestProductData];
    return YES;
}


- (void) closeDrawer {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self.drawerController closeDrawerAnimated:YES completion:^(BOOL x) {}];
}

- (void) requestProductData {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"com.focusedforsuccess.ItsAGoodDeal.removeads"]];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
#ifdef DEBUG
    NSLog(@"%s", __func__);
    NSLog(@"valid: %@", response.products);
    NSLog(@"invalid: %@", response.invalidProductIdentifiers);
#endif
    self.myStoreObserver.myProducts = response.products;
#ifdef DEBUG
    NSLog(@"%s, %@", __func__, self.myStoreObserver.myProducts);
    [self.myStoreObserver showProductInfo];
#endif
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    //UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"In-App Store unavailable" message:@"The In-App Store is currently unavailable, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //[alert show];
    NSLog(@"%s, App store unavailable: %@", __func__, error);
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
