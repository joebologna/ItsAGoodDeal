//
//  AppDelegate.h
//  IGD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Features.h"

#import "MyStoreObserver.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SKProductsRequestDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MyStoreObserver *myStoreObserver;

@end
