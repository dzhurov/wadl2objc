//
//  _TailorInfo.m
//
//  Generated by wadl2objc 2013.09.02 11:52:45.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_TailorInfo.h"

@implementation _TailorInfo

#pragma mark - Mapping

+ (NSArray*)mappedKays
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"bookedTime", @"firstName", @"id", @"lastName", @"totalMinutes", @"uniqueId"];
    }
    return keys;
}

+ (NSString *)entityNameForMappedField:(NSString*)fieldName
{

    return [super entityNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
