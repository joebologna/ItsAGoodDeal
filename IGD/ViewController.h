//
//  ViewController.h
//  IGD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyStoreObserver.h"
#import "MyButton.h"

@interface ViewController : UIViewController <UITextFieldDelegate, MyStoreObserverDelegate>

- (void)buttonPushed:(MyButton *)sender;

@end
