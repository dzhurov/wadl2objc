//
//  ExampleEntity.m
//
//  Generated by wadl2objc 8/27/13.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_AlterationOrderSummary.h"

@implementation _AlterationOrderSummary

#pragma mark - Mapping

- (void)setDictionaryInfo:(NSDictionary *)dictionaryInfo
{
    [self setDictionaryInfo:dictionaryInfo forKeys: @"dueDateTime", @"firstName", @"id", @"itemsRemain", @"itemsSize", @"lastName", @"orderId", @"totalPrice", nil];
}

- (NSMutableDictionary*)dictionaryInfo
{
    [self dictionaryInfoForKeys: @"dueDateTime", @"firstName", @"id", @"itemsRemain", @"itemsSize", @"lastName", @"orderId", @"totalPrice", nil];
}

- (NSString *)entityNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"orderType"]) return @"OrderType";
	if ([fieldName isEqualToString:@"status"]) return @"Status";

    return [super entityNameForMappedField:fieldName];
}

- (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end