//
//  SettingsView.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 8/5/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewDelegate;

@interface HelpView : UIViewController <UITextViewDelegate>

@property (unsafe_unretained, nonatomic) id delegate;

@end

@protocol SettingsViewDelegate <NSObject>

- (void)dismissSettingsView:(HelpView *)vc;
- (void)removeAds;
- (void)restorePurchase;
- (void)fillWithExample;

@end