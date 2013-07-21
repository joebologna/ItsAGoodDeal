//
//  IGDViewController.h
//  IGD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyStoreObserver.h"
#import "Fields.h"
#import "MyButton.h"

@interface IGDViewController : UIViewController <MyStoreObserverDelegate>

- (void)buttonPushed:(MyButton *)sender;

@end