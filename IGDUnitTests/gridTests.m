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

- (void)testGridObject {
    CGPoint origin = CGPointMake(200, 200);
    CGPoint size = CGPointMake(100, 50);
    CGPoint spacing = CGPointMake(2, 2);
    Grid *grid = [Grid initWithOrigin:&origin andSize:&size andSpacing:&spacing];
    [grid makeGridWithRows:4 andCols:4];
    [grid printGrid];
    for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
            printf("[%d,%d] (%s)\n", row, col, [[grid rectToString:[grid getRectAtX:row andY:col]] UTF8String]);
        }
    }
}

@end
