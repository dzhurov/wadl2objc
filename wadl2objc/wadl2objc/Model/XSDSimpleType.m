//
//  XSDSimpleType.m
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "XSDSimpleType.h"

@implementation XSDSimpleType

- (NSString *)nameOfInverseMappingMethod
{
    NSString *result = [NSString stringWithFormat:@"%@to%@", _name, _baseType];
    return result;
}

- (NSString *)nameOfMappingMethod
{
    NSString *result = [NSString stringWithFormat:@"%@to%@", _baseType, _name];
    return result;
}

- (BOOL)isEqual:(XSDSimpleType*)object
{
    if ([object isKindOfClass:[XSDSimpleType class]]){
        return [self.name isEqualToString:object.name];
    }
    return NO;
}

@end
