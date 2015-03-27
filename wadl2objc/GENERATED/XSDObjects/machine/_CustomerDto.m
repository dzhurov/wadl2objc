//
//  _CustomerDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_CustomerDto.h"

@implementation _CustomerDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"id", @"perfectFitId", @"partyId", @"firstName", @"lastName", @"phoneNumber", @"email", @"address", @"city", @"stateCode", @"zip", @"birthday", @"usageCode", @"doNotContactModes"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"stateCode"]) return @"UsaStateCode";
	if ([fieldName isEqualToString:@"doNotContactModes"]) return @"PreferredContactMode";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"doNotContactModes"]) return @"PreferredContactMode";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
