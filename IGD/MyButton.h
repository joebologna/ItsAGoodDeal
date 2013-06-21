//
//  MyButton.h
//  testColorButton
//
//  Created by Joe Bologna on 9/19/12.
//  Copyright (c) 2012 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton {
    NSArray *backgroundColors; // normal, selected, hold
    NSArray *titles; // normal, selected
    NSArray *titleColors; // normal, selected
}

@property (strong, nonatomic) NSArray *backgroundColors;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *titleColors;

- (void)toggle;

@end
