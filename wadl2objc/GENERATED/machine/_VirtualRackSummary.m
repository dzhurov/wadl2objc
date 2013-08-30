//
//  ExampleEntity.m
//
//  Generated by wadl2objc 8/27/13.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_VirtualRackSummary.h"

@implementation _VirtualRackSummary

#pragma mark - Mapping

- (void)setDictionaryInfo:(NSDictionary *)dictionaryInfo
{
    [self setDictionaryInfo:dictionaryInfo forKeys: @"firstName", @"garmentSize", @"id", @"lastName", @"orderId", @"priority", nil];
}

- (NSMutableDictionary*)dictionaryInfo
{
    [self dictionaryInfoForKeys: @"firstName", @"garmentSize", @"id", @"lastName", @"orderId", @"priority", nil];
}

- (NSString *)entityNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"status"]) return @"Status";

    return [super entityNameForMappedField:fieldName];
}

- (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end