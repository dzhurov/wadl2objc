//
//  _ReservationMeasurementDto.m
//
//  Generated by wadl2objc 2013.10.13 15:30:39.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ReservationMeasurementDto.h"

@implementation _ReservationMeasurementDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"reservationNo", @"height", @"weight", @"measuredBy"];
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
