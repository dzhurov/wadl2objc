//
//  _GiftCardValidateResponseDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_GiftCardValidateResponseDto.h"

@implementation _GiftCardValidateResponseDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = [@[@"valid", @"errorMessages", @"store", @"dateLoaded"] arrayByAddingObjectsFromArray:[super mappedKeys]];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"errorMessages"]) return @"NSString";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
