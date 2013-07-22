//
//  FieldsClassUnitTests.m
//  ItsAGoodDeal
//
//  Created by Joe Bologna on 7/19/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "FieldsClassUnitTests.h"
#import "Fields.h"
#import "NSObject+Formatter.h"

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
    [f makeFields:(UIViewController *)self];

    NSLog(@"\n\n%@\n\n", f.toString);
    STAssertEquals(f.deviceType, iPhone4, @"Should be whatever the simulator is set to.");
    
    f = [[Fields alloc] init];
    [f makeFields:nil];
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
    f = [Field allocFieldWithRect:CGRectMake(1, 1, 1, 1) andF:20 andValue:@"TestMe" andTag:ItemA andType:LabelField andVC:nil caller:self];
    NSLog(@"\n\n%@\n\n", f.toString);
}

- (void)test03FieldClass {
    NSString *c = self.currencySymbol;
    Field *f = [Field allocFieldWithRect:CGRectMake(1, 1, 1, 1) andF:20 andValue:c andTag:ItemA andType:LabelField andVC:nil caller:self];
    STAssertEquals(f.floatValue, 0.0f, @"should be 0.0");
    NSLog(@"%@", [self fmtPrice:f.floatValue]);

    f.value = @".";
    STAssertEquals(f.floatValue, 0.0f, @"should be 0.0");
    NSLog(@"%@", [self fmtPrice:f.floatValue]);

    f.value = @"1";
    STAssertEquals(f.floatValue, 1.0f, @"should be 1.0");
    NSLog(@"%@", [self fmtPrice:f.floatValue]);
    
    f.value = [c stringByAppendingString:@"1"];
    STAssertEquals(f.floatValue, 1.0f, @"should be 1.0");
    NSLog(@"%@", [self fmtPrice:f.floatValue]);
    
    f.value = [c stringByAppendingString:@".1"];
    STAssertEquals(f.floatValue, 0.1f, @"should be 0.1");
    NSLog(@"%@", [self fmtPrice:f.floatValue]);

    f.value = [c stringByAppendingString:@"."];
    STAssertEquals(f.floatValue, 0.0f, @"should be 0.0");
    NSLog(@"%@", [self fmtPrice:f.floatValue]);
}
@end
