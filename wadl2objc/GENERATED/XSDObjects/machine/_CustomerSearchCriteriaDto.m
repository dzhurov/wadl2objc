//
//  _CustomerSearchCriteriaDto.m
//
//  Generated by wadl2objc 2013.11.21 19:10:46.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_CustomerSearchCriteriaDto.h"

@implementation _CustomerSearchCriteriaDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"perfectFitId", @"phoneNumber", @"firstName", @"lastName", @"zip"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
