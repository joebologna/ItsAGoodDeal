//
//  LeftViewController.h
//  iOSCoders
//
//  Created by Joe Bologna on 9/8/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMDrawerController.h>
#import "IGDViewController.h"

@interface LeftViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property IGDViewController *cvc;
@property MMDrawerController *d;

@end