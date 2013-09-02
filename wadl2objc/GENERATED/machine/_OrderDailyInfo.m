//
//  _OrderDailyInfo.m
//
//  Generated by wadl2objc 2013.09.02 11:52:45.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_OrderDailyInfo.h"

@implementation _OrderDailyInfo

#pragma mark - Mapping

+ (NSArray*)mappedKays
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"firstName", @"lastName", @"minutes", @"orderId", @"orderType", @"orderUniqueId", @"status"];
    }
    return keys;
}

+ (NSString *)entityNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"orderType"]) return @"OrderType";
	if ([fieldName isEqualToString:@"status"]) return @"Status";

    return [super entityNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
