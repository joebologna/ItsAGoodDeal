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

#import <MMDrawerBarButtonItem.h>
#import <UIViewController+MMDrawerController.h>

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

#define PAYMENT_FAILED @"Payment Failed"
#define SUCCESS_TITLE @"Success"
#define FAILURE_TITLE @"Failure"
#define REMOVE_ADS @"Remove Ads"

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
    
    [self setupLeftMenuButton];

    myStoreObserver = [MyStoreObserver myStoreObserver];
    myStoreObserver.delegate = self;

    bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    bannerView.delegate = self;
    CGRect r = bannerView.frame;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    r = CGRectMake(r.origin.x, height - r.size.height, r.size.width, r.size.height);
    bannerView.frame = r;
    bannerView.hidden = YES;
    [self.view addSubview:bannerView];
    
    //self.view.backgroundColor = UIColorFromRGB(0x53e99e);
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    self.fields = [[Fields alloc] init];
    [self.fields makeFields:(UIViewController *)self];
    [self.fields populateScreen];
    [self popDefaults];
}

- (void)viewWillAppear:(BOOL)animated {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [super viewDidAppear:animated];
    NSString *usedOnce = @"usedOnce";
    if ([[NSUserDefaults standardUserDefaults] boolForKey:usedOnce] == NO) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:usedOnce];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSelector:@selector(showSettings) withObject:nil afterDelay:3];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self popDefaults];
    } else if (button.tag == Del) {
        NSString *s = self.fields.curField.value;
        if (s.length > 0) {
            self.fields.curField.value = [s substringToIndex:s.length - 1];
        }
    }
}

- (void)popDefaults {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    for (Field *f in self.fields.inputFields) {
        f.value = @"";
    }
    self.fields.unitsEachA.value = self.fields.unitsEachB.value = @"1";
    self.fields.numItemsA.value = self.fields.numItemsB.value = @"1";
    [self resetSlider];
    [self.fields emphasis:OnNeither];
    self.fields.curField = self.fields.inputFields[0];
    self.fields.curField.value = @"";
}

- (void)resetSlider {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    for (Field *f in self.fields.allFields) {
        if (f.tag == Slider) {
            [f makeSlider];
            break;
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
    NSString *t = [alertView title];
    if ([t isEqualToString:REMOVE_ADS]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
#ifdef DEBUG
            NSLog(@"%s, User authorized payment.", __func__);
#endif
            [self doPayment];
        } else {
            myStoreObserver.bought = NO;
        }
    } else if ([t isEqualToString:SUCCESS_TITLE] || [t isEqualToString:FAILURE_TITLE] || [t isEqualToString:PAYMENT_FAILED]) {
        NSLog(@"%s, nothing to do for '%@'", __func__, t);
    } else {
        NSLog(@"%s, oops, no handler for '%@'", __func__, t);
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark -
#pragma mark Banner Delegate

- (void)bannerViewWillLoadAd:(ADBannerView *)banner {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    bannerView = banner;
    if (myStoreObserver.bought) {
        [bannerView cancelBannerViewAction];
        [bannerView removeFromSuperview];
        bannerView.delegate = nil;
    }
    bannerView.hidden = myStoreObserver.bought;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    bannerView.hidden = YES;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
#ifdef DEBUG
    NSLog(@"%s, Nothing to do", __func__);
#endif
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
#ifdef DEBUG
    NSLog(@"%s, Nothing to do", __func__);
#endif
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
        [[[UIAlertView alloc] initWithTitle:PAYMENT_FAILED message:@"Try logging into Settings/iTunes again." delegate:self cancelButtonTitle:@"DONE" otherButtonTitles:nil] show];
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
        [[[UIAlertView alloc] initWithTitle:PAYMENT_FAILED message:@"Try logging into Settings/iTunes again." delegate:self cancelButtonTitle:@"DONE" otherButtonTitles:nil] show];
    }
}

- (void)processCompleted {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    if (myStoreObserver.bought) {
        [[[UIAlertView alloc] initWithTitle:SUCCESS_TITLE message:@"Thank you for your purchase!" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:FAILURE_TITLE message:@"Purchase failed. Please try again later." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
    }
}

- (void)removeAds {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    NSString *s = [NSString stringWithFormat:@"Remove Ads for %@?", [NSNumberFormatter localizedStringFromNumber:((SKProduct *)myStoreObserver.myProducts[0]).price numberStyle:NSNumberFormatterCurrencyStyle]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:REMOVE_ADS message:s delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.delegate = self;
    [alert show];
}

- (void)addControl:(UIView *)control {
#if DEBUG && DEBUG_VERBOSE
    NSLog(@"%s", __func__);
#endif
    [self.view addSubview:control];
}

- (void)showSettings {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    HelpView *s = [[HelpView alloc] init];
    s.delegate = self;
    [self presentViewController:s animated:YES completion:nil];
}

- (void)fillWithExample {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    for (Field *f in self.fields.inputFields) {
        switch ((FTAG)f.tag) {
            case PriceA:
                f.value = [f fmtPrice:4 d:2];
                break;
                
            case UnitsEachA:
                f.value = @"4.67";
                break;
                
            case NumItemsA:
                f.value = @"3";
                break;
                
            case PriceB:
                f.value = [f fmtPrice:5 d:2];
                break;
                
            case UnitsEachB:
                f.value = @"12";
                break;
                
            case NumItemsB:
                f.value = @"2";
                break;
                
            case Qty:
                f.value = [NSString stringWithFormat:@"%.f", MAX(self.fields.numItemsA.floatValue, self.fields.numItemsB.floatValue)];
                
            default:
                break;
        }
    }
    [self resetSlider];
    [self.fields calcSavings:NO];
}

- (void)dismissSettingsView:(HelpView *)vc {
    [vc dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

@end
