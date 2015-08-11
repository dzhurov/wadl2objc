//
//  _AuthManagerDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_AuthManagerDto.h"

@implementation _AuthManagerDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"managerId", @"managerPassword", @"permissions"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"permissions"]) return @"UserPermissions";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"permissions"]) return @"UserPermissions";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end