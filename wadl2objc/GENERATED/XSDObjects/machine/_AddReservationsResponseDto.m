//
//  _AddReservationsResponseDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_AddReservationsResponseDto.h"

@implementation _AddReservationsResponseDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"reservations", @"numReservations", @"numCommitted"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"reservations"]) return @"ReservationSummaryDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end