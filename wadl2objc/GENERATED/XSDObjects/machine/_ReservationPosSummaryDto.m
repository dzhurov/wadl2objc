//
//  _ReservationPosSummaryDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ReservationPosSummaryDto.h"

@implementation _ReservationPosSummaryDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = [@[@"reservationNo", @"groupId", @"firstName", @"lastName", @"customerPhone", @"pickupStatus", @"status", @"posStatus", @"dropOffStatus", @"amountDueCents", @"amountDueCentsFreeTuxPayment", @"eventDate", @"bookingDate", @"bookingStore", @"pickupStore", @"pickupExpectedDate", @"pickupActualDate", @"returnStore", @"returnExpectedDate"] arrayByAddingObjectsFromArray:[super mappedKeys]];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"pickupStatus"]) return @"ReservationPickupStatus";
	if ([fieldName isEqualToString:@"status"]) return @"ReservationStatus";
	if ([fieldName isEqualToString:@"posStatus"]) return @"ReservationPosStatus";
	if ([fieldName isEqualToString:@"dropOffStatus"]) return @"ReservationDropOffStatus";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
