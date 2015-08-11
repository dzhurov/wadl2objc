//
//  _GroupCreationDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_GroupCreationDto.h"

@implementation _GroupCreationDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"groupId", @"groupType", @"eventDate", @"pickupDate", @"returnDate", @"salesPerson", @"promRep", @"repGender", @"leadId", @"representative1", @"representative2", @"schoolNo", @"discountCode", @"promotionCode", @"eventType", @"bookingStore", @"noPickupNotification"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"groupType"]) return @"GroupType";
	if ([fieldName isEqualToString:@"promRep"]) return @"PromRep";
	if ([fieldName isEqualToString:@"repGender"]) return @"GenderType";
	if ([fieldName isEqualToString:@"eventType"]) return @"EventType";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
