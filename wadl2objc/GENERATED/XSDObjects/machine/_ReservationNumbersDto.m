//
//  _ReservationNumbersDto.m
//
//  Generated by wadl2objc 2013.11.21 19:10:46.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ReservationNumbersDto.h"

@implementation _ReservationNumbersDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"reservationsNumbers"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"reservationsNumbers"]) return @"NSString";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
