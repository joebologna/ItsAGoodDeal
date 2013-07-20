//
//  FieldsClassUnitTests.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "FieldsClassUnitTests.h"
#import "Fields.h"
#import "Field.h"

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
    
    f = [Fields allocFieldsWithDeviceType:iPhone4];
    NSLog(@"\n\n%@\n\n", f.toString);
    STAssertEquals(f.deviceType, iPhone4, @"Should be iPhone4");
    
    f = [Fields allocFieldsWithDeviceType:iPhone5];
    NSLog(@"\n\n%@\n\n", f.toString);
    STAssertEquals(f.deviceType, iPhone5, @"Should be iPhone5");
    
    f = [Fields allocFieldsWithDeviceType:iPad];
    NSLog(@"\n\n%@\n\n", f.toString);
    STAssertEquals(f.deviceType, iPad, @"Should be iPad");
}

- (void)test02FieldClass {
    Field *f = [[Field alloc] init];
    NSLog(@"\n\n%@\n\n", f.toString);
    STAssertEquals(f.rect.origin.x, 0.0f, @"Should be Zero");
    STAssertEquals(f.rect.origin.y, 0.0f, @"Should be Zero");
    STAssertEquals(f.rect.size.width, 0.0f, @"Should be Zero");
    STAssertEquals(f.rect.size.height, 0.0f, @"Should be Zero");
    STAssertEquals(f.f, [UIFont systemFontSize], @"Should be systemFontSize");
    STAssertTrue(f.label.length == 0, @"Should be 0");
    f = [Field allocFieldWithRect:CGRectMake(1, 1, 1, 1) andF:20 andLabel:@"TestMe" andTag:ItemA];
    NSLog(@"\n\n%@\n\n", f.toString);
}

@end
