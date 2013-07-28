//
//  gridTest.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/28/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "gridTests.h"
#import "Grid.h"

@implementation gridTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)printRect:(CGRect)r {
    NSLog(@"%.2f, %.2f, %.2f, %.2f", r.origin.x, r.origin.y, r.size.width, r.size.height);
}

- (void)testGrid {
    CGPoint spacing = CGPointMake(2, 2);
    CGRect base = CGRectMake(200, 200, 100, 50);
    int nrows = 4;
    for (int row = 0; row < nrows; row++) {
        CGRect r = CGRectMake(base.origin.x + spacing.x * row, base.origin.y + spacing.y * row, base.size.width, base.size.height);
        [self printRect:r];
    }
}

- (void)testGridObject {
    CGPoint spacing = CGPointMake(2, 2);
    CGRect base = CGRectMake(200, 200, 100, 50);
    Grid *grid = [Grid initWithBase:&base andSpacing:&spacing];
    [grid makeGridRows:4 andCols:4];
    [grid printGrid];
}

@end
