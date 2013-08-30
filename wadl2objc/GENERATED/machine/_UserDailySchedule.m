//
//  ExampleEntity.m
//
//  Generated by wadl2objc 8/27/13.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_UserDailySchedule.h"

@implementation _UserDailySchedule

#pragma mark - Mapping

- (void)setDictionaryInfo:(NSDictionary *)dictionaryInfo
{
    [self setDictionaryInfo:dictionaryInfo forKeys: @"firstName", @"id", @"lastName", nil];
}

- (NSMutableDictionary*)dictionaryInfo
{
    [self dictionaryInfoForKeys: @"firstName", @"id", @"lastName", nil];
}

- (NSString *)entityNameForMappedField:(NSString*)fieldName
{

    return [super entityNameForMappedField:fieldName];
}

- (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"orders"]) return @"AlterationOrder";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end