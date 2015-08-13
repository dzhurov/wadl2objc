//
//  XSDTypes.m
//
//  Created by wadl2objc
//


#import "XSDTypes.h"

@implementation XSDDate
@end

@implementation XSDDateTime
@end

@implementation NSDate (XSDDate)

- (XSDDate*)xsdDate
{
    return (XSDDate*)self;
}

- (XSDDateTime*)xsdDateTime
{
    return (XSDDateTime*)self;
}

@end
