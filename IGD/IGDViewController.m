//
//  IGDViewController.m
//  IGD
//
//  Created by Joe Bologna on 6/4/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "IGDViewController.h"
#import "MyButton.h"
#import "MyStoreObserver.h"

#import <iAd/iAd.h>
#import <StoreKit/StoreKit.h>

#pragma mark -
#pragma mark Convenience Macros

#pragma mark -
#pragma mark Tags and Fields Tables

#pragma mark -
#pragma mark Debug Variables

typedef enum { AisBigger, AisBetter, BisBetter, Same, NotTesting } Test;

#if DEBUG==1
//static BOOL debug = YES;
//static Test testToRun = AisBigger;
#else
//static BOOL debug = NO;
//static Test testToRun = NotTesting;
#endif

#pragma mark -
#pragma mark Instance Properties

@interface IGDViewController () <ADBannerViewDelegate, UIAlertViewDelegate> {
    MyStoreObserver *myStoreObserver;
    ADBannerView *bannerView;
}

@end

#pragma mark -
#pragma mark View Delegate

@implementation IGDViewController

- (void)viewDidLoad {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [super viewDidLoad];

    myStoreObserver = [MyStoreObserver myStoreObserver];
    myStoreObserver.delegate = self;

    ADBannerView *adView = (ADBannerView *)[self.view viewWithTag:Ad];
    adView.delegate = self;
    
    //self.view.backgroundColor = UIColorFromRGB(0x53e99e);
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    self.fields = [[Fields alloc] init];
    [self.fields makeFields:(UIViewController *)self];
    [self setAdButtonState];
    [self.fields populateScreen];
    [self initGUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Handle Screen

- (void)initGUI {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self setAdButtonState];
}

#pragma mark -
#pragma mark Handle Input

- (MyButton *)mapKeyToButton:(NSString *)sender {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    for (Field *key in self.fields.keys) {
        if ((sender.length == 0 && key.tag == Del) || [sender isEqualToString:key.value]) {
            return (MyButton *)key.control;
        }
    }
    return nil;
}

- (void)buttonPushed:(id)sender {
#ifdef DEBUG
    if ([sender isKindOfClass:[UIButton class]]) {
        NSLog(@"%s:%d:%@", __func__, ((UIButton *)sender).tag, ((UIButton *)sender).titleLabel.text);
    } else if ([sender isKindOfClass:[UISlider class]]) {
        NSLog(@"%s:%d:%.2f", __func__, ((UISlider *)sender).tag, ((UISlider *)sender).value);
    } else {
        NSLog(@"%s:%@", __func__, sender);
    }
#endif
    
    MyButton *button = (MyButton *)sender;
    
    if ([button isKindOfClass:[NSString class]]) {
        button = [self mapKeyToButton:(NSString *)button];
        if (button == nil) return;
    }
    // else .tag can come from a UIBarButtonItem, it will get picked up below
    
    if (button.tag == Next) {
        [self.fields gotoNextField:NO];
        [self.fields calcSavings:NO];
    } else if (button.tag == NextButton) {
        [self.fields gotoNextField:YES];
        [self.fields calcSavings:NO];
    } else if (button.tag == PrevButton) {
        [self.fields gotoPrevField:YES];
        [self.fields calcSavings:NO];
    } else if (button.tag == CalcButton) {
        [self.fields.curField.control resignFirstResponder];
        [self.fields showKeypad:nil];
        [self.fields calcSavings:NO];
    } else if (button.tag <= Period) {
        NSString *s = self.fields.curField.value;
        if (button.tag == Period) {
            NSRange r = [s rangeOfString:@"."];
            if (r.location == NSNotFound) {
                self.fields.curField.value = [s stringByAppendingString:button.titleLabel.text];
            }
#ifdef DEBUG
            else {
                NSLog(@"%s, skipping 2nd '.'", __func__);
            }
#endif
        } else {
            self.fields.curField.value = [s stringByAppendingString:button.titleLabel.text];
        }
    } else if (button.tag == Clr) {
        for (Field *f in self.fields.inputFields) {
            f.value = @"";
            if (f.tag == Slider) {
                ((UISlider *)f.control).value = 1.0;
            }
        }
        self.fields.curField = self.fields.inputFields[0];
        self.fields.curField.value = @"";
    } else if (button.tag == Del) {
        NSString *s = self.fields.curField.value;
        if (s.length > 0) {
            self.fields.curField.value = [s substringToIndex:s.length - 1];
        }
    } else if (button.tag == Store) {
        if (!myStoreObserver.bought) {
            if ([SKPaymentQueue canMakePayments]) {
                [self removeAds];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Payments Disabled" message:@"Use Settings to enable payments" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        } else {
            NSLog(@"handle restore here");
            if ([SKPaymentQueue canMakePayments]) {
                [self restorePurchase];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Payments Disabled" message:@"Use Settings to enable payments" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
    }
}

- (void)sliderMoved:(float)v {
#ifdef DEBUG
    NSLog(@"%s:%.2f", __func__, v);
#endif
}

#pragma mark -
#pragma mark Ads

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (![[alertView title] isEqualToString:@"Payments Disabled"]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
#ifdef DEBUG
            NSLog(@"Buy it here");
#endif
            [self doPayment];
        } else {
            myStoreObserver.bought = NO;
            [self setAdButtonState];
        }
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)setAdButtonState {
#ifdef DEBUG
    NSLog(@"%s, bought: %d", __func__, myStoreObserver.bought);
#endif
    if (myStoreObserver.bought) {
        self.fields.store.value = @RESTORE;
        [bannerView cancelBannerViewAction];
        [bannerView removeFromSuperview];
        bannerView.delegate = nil;
    } else {
        self.fields.store.value = @STORE;
    }
}

#pragma mark -
#pragma mark Banner Delegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    bannerView = banner;
    if (myStoreObserver.bought) {
        [bannerView cancelBannerViewAction];
    } else {
        bannerView.hidden = NO;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    bannerView = banner;
    banner.hidden = YES;
    [bannerView cancelBannerViewAction];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
#ifdef DEBUG
    NSLog(@"%s, Nothing to do", __func__);
#endif
    bannerView = banner;
    banner.hidden = !myStoreObserver.bought;
    return myStoreObserver.bought;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
#ifdef DEBUG
    NSLog(@"%s, Nothing to do", __func__);
#endif
    bannerView = banner;
    if (myStoreObserver.bought) {
        banner.hidden = YES;
        [bannerView cancelBannerViewAction];
    }
}

#pragma mark -
#pragma mark Store

- (void)doPayment {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if (myStoreObserver.myProducts.count > 0) {
        SKProduct *selectedProduct = myStoreObserver.myProducts[0];
        SKPayment *payment = [SKPayment paymentWithProduct:selectedProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
#ifdef DEBUG
        NSLog(@"no products found");
#endif
    }
}

- (void) restorePurchase {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if (myStoreObserver.myProducts.count > 0) {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    } else {
#ifdef DEBUG
        NSLog(@"no products found");
#endif
    }
}

- (void)processCompleted {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self setAdButtonState];
}

- (void)removeAds {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    NSString *s = [NSString stringWithFormat:@"Remove Ads for %@?", [NSNumberFormatter localizedStringFromNumber:((SKProduct *)[MyStoreObserver myStoreObserver].myProducts[0]).price numberStyle:NSNumberFormatterCurrencyStyle]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@STORE message:s delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.delegate = self;
    [alert show];
}

- (void)addControl:(UIView *)control {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self.view addSubview:control];
}

- (void)showSettings {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
#ifdef DEAD
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    CGRect r = self.view.frame;
    if (r.origin.y > 0) {
        r.origin.y -= height * 0.4;
        [self.view setFrame:r];
    } else {
        r.origin.y += height * 0.4;
        [self.view setFrame:r];
    }
#endif
    SettingsView *s = [[SettingsView alloc] init];
    s.delegate = self;
    [self presentViewController:s animated:YES completion:nil];
}

- (void)dismissSettingsView:(SettingsView *)vc {
    [vc dismissViewControllerAnimated:YES completion:nil];
}
@end
