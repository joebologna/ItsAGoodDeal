//
//  AppDelegate.h
//  IGD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "MyStoreObserver.h"
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SKProductsRequestDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MyStoreObserver *myStoreObserver;

@end
