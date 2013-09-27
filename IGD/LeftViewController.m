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

typedef enum {
    StoreNotAvailable,
    Paid,
    NotPaid
} PaymentStates;


typedef enum {
    ShowHelp,
    HandlePayment,
    HandleRestore
} Actions;

@interface LeftViewController() {
    NSArray *theList;
    PaymentStates paymentState;
}

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = HIGHLIGHTCOLOR;
        self.title = @"Settings View";
        [self setRestorationIdentifier:@"MMExampleLeftSideDrawerController"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    theList = [NSArray arrayWithObjects:
               [NSArray arrayWithObjects:@"Help", @"App Store Not Available", @"Try Again Later", nil],      // StoreNotAvailable
               [NSArray arrayWithObjects:@"Help", @"App is Ad Free!", @"Thank you!", nil], // Paid
               [NSArray arrayWithObjects:@"Help", @"Remove Ads", @"Restore Purchases", nil],                 // NotPaid
               nil];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(20, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (MyStoreObserver.myStoreObserver.myProducts.count == 0) {
        paymentState = StoreNotAvailable;
    } else {
        paymentState = MyStoreObserver.myStoreObserver.bought ? Paid : NotPaid;
    }
    [[self tableView] reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [theList[paymentState] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Control Panel";
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    cell.textLabel.text = theList[paymentState][indexPath.row];
    cell.tag = (Actions)indexPath.row;
    cell.backgroundColor = self.view.backgroundColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.d closeDrawerAnimated:YES completion:^(BOOL done) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        switch ((Actions)cell.tag) {
            case ShowHelp:
                [self.cvc showSettings];
                break;
                
            case HandlePayment:
                if (paymentState != StoreNotAvailable && !MyStoreObserver.myStoreObserver.bought) [self.cvc removeAds];
                break;
                
            case HandleRestore:
                if (paymentState != StoreNotAvailable && !MyStoreObserver.myStoreObserver.bought) [self.cvc restorePurchase];
                break;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
