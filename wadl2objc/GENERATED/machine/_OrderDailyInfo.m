//
//  _OrderDailyInfo.m
//
//  Generated by wadl2objc 2013.08.30 17:01:09.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_OrderDailyInfo.h"

@implementation _OrderDailyInfo

#pragma mark - Mapping

- (void)setDictionaryInfo:(NSDictionary *)dictionaryInfo
{
    [self setDictionaryInfo:dictionaryInfo forKeys: @"firstName", @"lastName", @"minutes", @"orderId", @"orderUniqueId", nil];
}

- (NSMutableDictionary*)dictionaryInfo
{
    [self dictionaryInfoForKeys: @"firstName", @"lastName", @"minutes", @"orderId", @"orderUniqueId", nil];
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
