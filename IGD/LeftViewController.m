//
//  LeftViewController.m
//  iOSCoders
//
//  Created by Joe Bologna on 9/8/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "MyStoreObserver.h"

typedef enum {
    Help,
    RemoveAds,
    RestorePurchases
} Selection;

@interface LeftViewController() {
    NSArray *theList;
}

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = HIGHLIGHTCOLOR;
        self.title = @"Settings View";
        [self setRestorationIdentifier:@"MMExampleLeftSideDrawerController"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    theList = [NSArray arrayWithObjects:@"Help", @"Remove Ads", @"Restore Purchases", nil];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // not bought, show Help, Remove Ads
    // bought, show Help, Restore Purchases
    // no store, show Help, Try Later
    return 2;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"List";
//}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    if (MyStoreObserver.myStoreObserver.myProducts.count == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = theList[Help];
        } else if(indexPath.row == 1) {
            cell.textLabel.text = theList[RestorePurchases];
        }
    } else {
        if (indexPath.row == 1) {
            cell.textLabel.text = MyStoreObserver.myStoreObserver.bought ? theList[RestorePurchases] : theList[RemoveAds];
        }
    }
    cell.backgroundColor = self.view.backgroundColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.d closeDrawerAnimated:YES completion:^(BOOL done) {}];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:theList[Help]]) {
        [self.cvc showSettings];
    } else if ([cell.textLabel.text isEqualToString:theList[RemoveAds]]) {
        [self.cvc removeAds];
    } else if ([cell.textLabel.text isEqualToString:theList[RestorePurchases]]) {
        [self.cvc restorePurchase];
    } else {
        NSLog(@"dunno");
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
