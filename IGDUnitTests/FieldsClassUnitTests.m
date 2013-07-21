//
//  FieldsClassUnitTests.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "FieldsClassUnitTests.h"
#import "Fields.h"

@interface FieldsClassUnitTests() {
};
@end

@implementation FieldsClassUnitTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test01FieldsClass {
    Fields *f = [[Fields alloc] init];
    NSLog(@"\n\n%@\n\n", f.toString);
    STAssertEquals(f.deviceType, UnknownDeviceType, @"Should be UnknownDeviceType");
    
    f = [Fields allocFields];
    NSLog(@"\n\n%@\n\n", f.toString);
}

- (void)test02FieldClass {
    Field *f = [[Field alloc] init];
    NSLog(@"\n\n%@\n\n", f.toString);
    STAssertEquals(f.rect.origin.x, 0.0f, @"Should be Zero");
    STAssertEquals(f.rect.origin.y, 0.0f, @"Should be Zero");
    STAssertEquals(f.rect.size.width, 0.0f, @"Should be Zero");
    STAssertEquals(f.rect.size.height, 0.0f, @"Should be Zero");
    STAssertEquals(f.f, [UIFont systemFontSize], @"Should be systemFontSize");
    STAssertTrue(f.value.length == 0, @"Should be 0");
    f = [Field allocFieldWithRect:CGRectMake(1, 1, 1, 1) andF:20 andValue:@"TestMe" andTag:ItemA andType:ButtonField andVC:nil];
    NSLog(@"\n\n%@\n\n", f.toString);
}

@end
