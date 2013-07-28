//
//  Grid.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/28/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Grid : NSObject

@property (unsafe_unretained, nonatomic) CGPoint *spacing;
@property (unsafe_unretained, nonatomic) CGRect *base;
@property (strong, nonatomic) NSMutableArray *grid;

+ (Grid *)initWithBase:(CGRect *)b andSpacing:(CGPoint *)s;
- (void)makeGridRows:(int)nrows andCols:(int)ncols;

- (void)printGrid;
- (void)printRect:(CGRect)r;
@end
