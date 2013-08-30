//
//  ExampleEntity.m
//
//  Generated by wadl2objc 8/27/13.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_DailyLoad.h"

@implementation _DailyLoad

#pragma mark - Mapping

- (void)setDictionaryInfo:(NSDictionary *)dictionaryInfo
{
    [self setDictionaryInfo:dictionaryInfo forKeys: @"assignedMinutes", @"availableMinutes", nil];
}

- (NSMutableDictionary*)dictionaryInfo
{
    [self dictionaryInfoForKeys: @"assignedMinutes", @"availableMinutes", nil];
}

- (NSString *)entityNameForMappedField:(NSString*)fieldName
{

    return [super entityNameForMappedField:fieldName];
}

- (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"dailyInfo"]) return @"OrderDailyInfo";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
