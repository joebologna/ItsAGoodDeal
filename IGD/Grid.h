//
//  Grid.h
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/28/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Grid : NSObject

@property (unsafe_unretained, nonatomic) CGPoint *origin;
@property (unsafe_unretained, nonatomic) CGPoint *spacing;
@property (unsafe_unretained, nonatomic) CGPoint *size;
@property (strong, nonatomic) NSMutableArray *grid;

+ (Grid *)initWithOrigin:(CGPoint *)o andSize:(CGPoint *)sz andSpacing:(CGPoint *)sp;
- (void)makeGridWithRows:(int)nrows andCols:(int)ncols;

- (void)printGrid;
- (CGRect)getRectAtX:(int)x andY:(int)y;
- (NSString *)rectToString:(CGRect)r;
- (void)printRect:(CGRect)r AtX:(int)x andY:(int)y;

@end
