//
//  SettingsView.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 8/5/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Globals.h"
#import "Field.h"
#import "HelpView.h"
#import "MyButton.h"
#import "MyStoreObserver.h"
#import "NSObject+Utils.h"
#import <QuartzCore/QuartzCore.h>


@interface HelpView () {
    MyStoreObserver *myStoreObserver;
    MyButton *ra;
    MyButton *r;
    MyButton *b;
    UITextView *msg;
}

@end

@implementation HelpView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
#if DEBUG && DEBUG_VERBOSE
    NSLog(@"%s", __func__);
#endif

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        myStoreObserver = [MyStoreObserver myStoreObserver];
    }
    return self;
}

#define SLOT(n) ((height / slots * n) - (fontSize))

- (void)viewDidLoad {
#if DEBUG && DEBUG_VERBOSE
    NSLog(@"%s", __func__);
#endif
    [super viewDidLoad];
	
    self.view.backgroundColor = HIGHLIGHTCOLOR;
    float height = [[UIScreen mainScreen] bounds].size.height;
    float width = [[UIScreen mainScreen] bounds].size.width;
    float radius = 6;
    float fontSize = [UIFont systemFontSize];
    float bheight = fontSize * 2;
    float toffset = 0;
    float ioffset = bheight * 1;
    if (self.getDeviceType == iPhone5) {
        fontSize *= 1.10;
        bheight = fontSize * 2;
    }
    float bwidth = width - 2 * bheight;
    float tfontSize = fontSize * 0.8;
    float slots = 10;
    float theight = SLOT(8);
    float lheight = bheight * 0.75;
    if (self.getDeviceType == iPhone5) {
        lheight = bheight * 0.8;
    } else if (self.getDeviceType == iPad) {
    }
    if (self.getDeviceType == iPad) {
        radius *= 4;
        fontSize *= 4;
        bheight = fontSize * 1.4;
        bwidth = width - 2 * bheight;
        lheight = bheight * 2;
        tfontSize = fontSize * 0.8 / 2;
        toffset = fontSize;
        theight -= toffset;
        ioffset = bheight * 0.5;
    }
    
    int position = 0;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(bheight, SLOT(position++) + ioffset, width - 2 * bheight, lheight)];
    l.text = @"Using It's a Good Deal";
    l.font = [UIFont systemFontOfSize:fontSize];
    l.backgroundColor = HIGHLIGHTCOLOR;
    [self.view addSubview:l];

    UIWebView *h = [[UIWebView alloc] initWithFrame:CGRectMake(bheight, toffset + SLOT(position++), width - 2 * bheight, theight)];
    h.tag = HelpViewTag;
    NSString *page = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"index.html"];
    [h loadData:[NSData dataWithContentsOfFile:page] MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:[[NSBundle mainBundle] bundleURL]];
    [h.layer setBorderColor:[[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor]];
    [h.layer setBorderWidth:2.0];
    [self.view addSubview:h];
    
    position = 9;
    
    b = [[MyButton alloc] initWithFrame:CGRectMake(bheight, SLOT(position++), bwidth, bheight)];
    b.bothTitles = @"Done";
    b.font = [UIFont systemFontOfSize:fontSize];
    b.radius = radius;
    [b setTitleColors:[NSArray arrayWithObjects:[UIColor blackColor], [UIColor blackColor], nil]];
    [b addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    msg = [[UITextView alloc] initWithFrame:CGRectMake(ra.frame.origin.x, ra.frame.origin.y, ra.frame.size.width, ra.frame.size.height * 2 + fontSize/2)];
    msg.backgroundColor = [UIColor whiteColor];
    msg.hidden = YES;
//    msg.font = r.titleLabel.font;
    msg.font = [UIFont systemFontOfSize:fontSize * (self.isPhone ? 0.8 : 0.6)];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.delegate = self;
    [self.view addSubview:msg];

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
#if DEBUG && DEBUG_VERBOSE
    NSLog(@"%s", __func__);
#endif
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
#if DEBUG && DEBUG_VERBOSE
    NSLog(@"%s", __func__);
#endif
    [super viewWillAppear:animated];
    if (myStoreObserver.myProducts.count > 0) {
        if (myStoreObserver.bought) {
            ra.bothTitles = @"Ad Free!";
            ra.enabled = r.enabled = NO;
            r.bothTitles = @"Restore";
        } else {
            ra.bothTitles = @"Remove Ads";
            ra.enabled = r.enabled = YES;
            r.bothTitles = @"Restore Purchase";
        }
        r.hidden = ra.hidden = NO;
        msg.hidden = YES;
    } else {
        ra.enabled = r.enabled = NO;
        r.hidden = ra.hidden = YES;
        msg.text = @"\nThe App Store is not available, please try to purchase the App later.";
        msg.hidden = NO;
    }
}

- (void)restore:(id)sender {
#if DEBUG && DEBUG_VERBOSE
    NSLog(@"%s", __func__);
#endif
    [self.delegate restorePurchase];
    [self goBack:nil];
}

- (void)removeAds:(id)sender {
#if DEBUG && DEBUG_VERBOSE
    NSLog(@"%s", __func__);
#endif
    [self.delegate removeAds];
    [self goBack:nil];
}

- (void)goBack:(id)sender {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
    [self.delegate fillWithExample];
    [self.delegate dismissSettingsView:self];
}

- (void)didReceiveMemoryWarning {
#if DEBUG && DEBUG_VERBOSE
    NSLog(@"%s", __func__);
#endif
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
