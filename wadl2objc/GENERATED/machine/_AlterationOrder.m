//
//  _AlterationOrder.m
//
//  Generated by wadl2objc 2013.08.30 17:01:09.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_AlterationOrder.h"

@implementation _AlterationOrder

#pragma mark - Mapping

- (void)setDictionaryInfo:(NSDictionary *)dictionaryInfo
{
    [self setDictionaryInfo:dictionaryInfo forKeys: @"completeDateTime", @"createdBy", @"createdDateTime", @"customer", @"dueDateTime", @"id", @"note", @"orderId", @"pickupDateTime", @"store", @"totalPrice", @"updatedBy", @"updatedDateTime", @"version", nil];
}

- (NSMutableDictionary*)dictionaryInfo
{
    [self dictionaryInfoForKeys: @"completeDateTime", @"createdBy", @"createdDateTime", @"customer", @"dueDateTime", @"id", @"note", @"orderId", @"pickupDateTime", @"store", @"totalPrice", @"updatedBy", @"updatedDateTime", @"version", nil];
}

- (NSString *)entityNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"orderType"]) return @"OrderType";
	if ([fieldName isEqualToString:@"status"]) return @"Status";

    return [super entityNameForMappedField:fieldName];
}

- (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"garments"]) return @"AlteredGarment";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
