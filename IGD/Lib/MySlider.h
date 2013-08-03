//
//  Slider.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 8/3/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MySliderDelegate;

@interface MySlider : UISlider

@property (unsafe_unretained, nonatomic) id caller;

@end

@protocol MySliderDelegate <NSObject>

- (void)newValue:(float)v;

@end