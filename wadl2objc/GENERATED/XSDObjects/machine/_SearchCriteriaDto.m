//
//  _SearchCriteriaDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_SearchCriteriaDto.h"

@implementation _SearchCriteriaDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"id", @"firstName", @"lastName", @"phoneNumber", @"bookingStore", @"schoolNo", @"salesperson", @"eventDate", @"eventType", @"groupName", @"groupType", @"coRegistrantFirstName", @"coRegistrantLastName", @"coRegistrantPhoneNumber", @"coRegistrantZipCode", @"coRegistrantEmail", @"commitMin", @"commitMax", @"email", @"brideCity", @"groomCity", @"bridePostalCode", @"groomPostalCode", @"groomState", @"brideState", @"fromDate", @"toDate", @"firstResultNumber", @"maxResultNumber"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"eventType"]) return @"EventType";
	if ([fieldName isEqualToString:@"groupType"]) return @"GroupType";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end