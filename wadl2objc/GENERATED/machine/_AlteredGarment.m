//
//  _AlteredGarment.m
//
//  Generated by wadl2objc 2013.09.02 11:52:45.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_AlteredGarment.h"

@implementation _AlteredGarment

#pragma mark - Mapping

+ (NSArray*)mappedKays
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"assignedTo", @"childSize", @"color", @"formal", @"garmentId", @"garmentType", @"groupId", @"id", @"item", @"itemCode", @"new", @"note", @"orderId", @"orderedAlterations", @"parentGarmentId", @"purchasedAtTMW", @"rfaRelated", @"scheduledDateTime", @"status"];
    }
    return keys;
}

+ (NSString *)entityNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"garmentType"]) return @"GarmentType";
	if ([fieldName isEqualToString:@"status"]) return @"Status";

    return [super entityNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"orderedAlterations"]) return @"OrderedAlteration";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
