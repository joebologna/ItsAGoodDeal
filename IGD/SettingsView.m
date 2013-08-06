//
//  SettingsView.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 8/5/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "SettingsView.h"
#import "MyButton.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HIGHLIGHTCOLOR UIColorFromRGB(0xd2fde8)

@interface SettingsView ()

@end

@implementation SettingsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = HIGHLIGHTCOLOR;
    MyButton *b = [[MyButton alloc] initWithFrame:CGRectMake(110, 10, 100, 20)];
    b.bothTitles = @"Back";
    [b addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}
                                                                                                                                                       
- (void)goBack:(id)sender {
    [self.delegate dismissSettingsView:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
