//
//  _OrderDto.m
//
//  Generated by wadl2objc 2013.11.21 19:10:46.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_OrderDto.h"

@implementation _OrderDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"reservationNumber", @"firstName", @"lastName", @"groupName", @"phone", @"zipCode", @"role", @"eventDate", @"eventType", @"bookingStore", @"schoolNum", @"salesperson", @"groupId", @"leadId", @"coRegistrantFirstName", @"coRegistrantLastName", @"coRegistrantPhoneNumber", @"coRegistrantZipCode", @"coRegistrantRole", @"discountCode", @"numReservations", @"numCommitted"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"role"]) return @"RepresentativeRole";
	if ([fieldName isEqualToString:@"eventType"]) return @"EventType";
	if ([fieldName isEqualToString:@"coRegistrantRole"]) return @"RepresentativeRole";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
