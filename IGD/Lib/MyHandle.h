//
//  MyHandle.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 8/6/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyHandleDelegate;

@interface MyHandle : UIButton

@property (unsafe_unretained, nonatomic) UIViewController *delegate;

@end

@protocol MyHandleDelegate <NSObject>

- (void)showSettings;

@end