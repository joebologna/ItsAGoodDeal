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
        _origin = nil;
        _spacing = nil;
        _size = nil;
        _grid = nil;
    }
    return self;
}

+ (Grid *)initWithOrigin:(CGPoint *)o andSize:(CGPoint *)sz andSpacing:(CGPoint *)sp {
    NSLog(@"%s", __func__);
    Grid *g = [[Grid alloc] init];
    g.origin = o;
    g.spacing = sp;
    g.size = sz;
    g.grid = [NSMutableArray array];
    return g;
}

- (void)makeGridWithRows:(int)nrows andCols:(int)ncols  {
    NSLog(@"%s", __func__);
    printf("\n");
    for (int row = 0; row < nrows; row++) {
        [_grid addObject:[NSMutableArray array]];
        for (int col = 0; col < ncols; col++) {
            float x = _origin->x + (_size->x + _spacing->x) * col;
            float y = _origin->y + (_size->y + _spacing->y) * row;
            printf("[%d,%d] (%.2f, %.2f, %.2f, %.2f)\n", row, col, x, y, _size->x, _size->y);
            [[_grid lastObject] addObject:[self makeBoxWith:x andY:y andWidth:_size->x andHeight:_size->y]];
        }
        printf("\n");
    }
}

- (NSArray *)makeBoxWith:(float)x andY:(float)y andWidth:(float)w andHeight:(float)h {
    return [NSArray arrayWithObjects:
            [NSNumber numberWithFloat:x],
            [NSNumber numberWithFloat:y],
            [NSNumber numberWithFloat:w],
            [NSNumber numberWithFloat:h],
            nil];
}

- (CGRect)makeRectFromBox:(NSArray *)box {
    return CGRectMake([box[0] floatValue], [box[1] floatValue], [box[2] floatValue], [box[3] floatValue]);
}

- (CGRect)getRectAtX:(int)x andY:(int)y {
    return [self makeRectFromBox:self.grid[x][y]];
}

- (NSString *)rectToString:(CGRect)r {
    return [NSString stringWithFormat:@"%.2f, %.2f, %.2f, %.2f", r.origin.x, r.origin.y, r.size.width, r.size.height];
}

- (void)printGrid {
    NSLog(@"%s", __func__);
    printf("\n");
    int x = 0;
    for (NSArray *row in _grid) {
        int y = 0;
        for (NSArray *col in row) {
            [self printRect:[self makeRectFromBox:col] AtX:x andY:y];
            x++;
        }
        y++;
        printf("\n");
    }
}

- (void)printRect:(CGRect)r AtX:(int)x andY:(int)y {
    printf("[%d, %d] (%.2f, %.2f, %.2f, %.2f)\n", x, y, r.origin.x, r.origin.y, r.size.width, r.size.height);
}

@end
