//
//  Grid.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/28/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Grid.h"

@implementation Grid

- (id)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        NSLog(@"%s", __func__);
#endif
        _base = nil;
        _spacing = nil;
        _grid = nil;
    }
    return self;
}

+ (Grid *)initWithBase:(CGRect *)b andSpacing:(CGPoint *)s {
    Grid *g = [[Grid alloc] init];
    g.base = b;
    g.spacing = s;
    g.grid = [NSMutableArray array];
    return g;
}

- (void)makeGridRows:(int)nrows andCols:(int)ncols  {
    for (int row = 0; row < nrows; row++) {
        [_grid addObject:[NSMutableArray array]];
        for (int col = 0; col < ncols; col++) {
            [[_grid lastObject] addObject:[NSMutableArray array]];
            CGRect r = CGRectMake(_base->origin.x + _spacing->x * row, _base->origin.y + _spacing->y * col, _base->size.width, _base->size.height);
            [[[_grid lastObject] lastObject] addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:r.origin.x], [NSNumber numberWithFloat:r.origin.y], [NSNumber numberWithFloat:r.size.width], [NSNumber numberWithFloat:r.size.height], nil]];
        }
    }
    [self printGrid];
}

- (void)printGrid {
    for (NSArray *row in _grid) {
        for (NSArray *col in row) {
            CGRect r = CGRectMake([(NSNumber *)col[0] floatValue], [(NSNumber *)col[1] floatValue], [(NSNumber *)col[2] floatValue], [(NSNumber *)col[2] floatValue]);
            [self printRect:r];
        }
    }
}

- (void)printRect:(CGRect)r {
    NSLog(@"%.2f, %.2f, %.2f, %.2f", r.origin.x, r.origin.y, r.size.width, r.size.height);
}

@end
