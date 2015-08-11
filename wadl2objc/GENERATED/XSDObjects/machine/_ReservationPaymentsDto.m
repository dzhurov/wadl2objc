//
//  _ReservationPaymentsDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ReservationPaymentsDto.h"

@implementation _ReservationPaymentsDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"reservationNo", @"payments", @"totalAmount"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"payments"]) return @"PaymentInfoDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end