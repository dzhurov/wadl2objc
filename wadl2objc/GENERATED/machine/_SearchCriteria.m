//
//  _SearchCriteria.m
//
//  Generated by wadl2objc 2013.09.03 14:51:56.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_SearchCriteria.h"

@implementation _SearchCriteria

#pragma mark - Mapping

+ (NSArray*)mappedKays
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"length", @"nameOrNumber", @"offset", @"orderStatuses", @"priority"];
    }
    return keys;
}

+ (NSString *)entityNameForMappedField:(NSString*)fieldName
{

    return [super entityNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"orderStatuses"]) return @"NSString";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
