//
//  _GroupOffersDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_GroupOffersDto.h"

@implementation _GroupOffersDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"groupId", @"discountCode", @"discountDescription", @"requiredItems", @"promotionCode", @"eligibleNumberFreeTux", @"eligibleNumberFreeSuit", @"assignedFreeTux", @"assignedFreeSuit", @"eligibleReservationForFreeTux", @"eligibleReservationForFreeSuit", @"messages"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"requiredItems"]) return @"StyleItemType";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"requiredItems"]) return @"StyleItemType";
	if ([fieldName isEqualToString:@"messages"]) return @"MessageDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end