//
//  _ReservationLogisticDto.m
//
//  Generated by wadl2objc 2013.10.10 14:26:15.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ReservationLogisticDto.h"

@implementation _ReservationLogisticDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"reservationNo", @"eventDate", @"expectedPickupDate", @"actualPickupDate"];
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
