//
//  _ReservationSummaryDto.m
//
//  Generated by wadl2objc 2013.10.11 17:34:28.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ReservationSummaryDto.h"

@implementation _ReservationSummaryDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"reservationNo", @"groupId", @"eventDate"];
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
