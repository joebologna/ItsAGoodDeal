//
//  IGDViewController.h
//  IGD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Globals.h"

#import "MyStoreObserver.h"
#import "Fields.h"
#import "MyButton.h"
#import "HelpView.h"

@interface IGDViewController : UIViewController <MyStoreObserverDelegate, TraverseViewDelegate,SettingsViewDelegate>

@property (strong, nonatomic) Fields *fields;

- (void)buttonPushed:(id)sender;
- (void)showSettings;

@end
