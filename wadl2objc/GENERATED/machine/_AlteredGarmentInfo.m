//
//  ExampleEntity.m
//
//  Generated by wadl2objc 8/27/13.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_AlteredGarmentInfo.h"

@implementation _AlteredGarmentInfo

#pragma mark - Mapping

- (void)setDictionaryInfo:(NSDictionary *)dictionaryInfo
{
    [self setDictionaryInfo:dictionaryInfo forKeys: @"garmentId", @"minutes", @"orderId", @"orderUniqueId", @"priority", nil];
}

- (NSMutableDictionary*)dictionaryInfo
{
    [self dictionaryInfoForKeys: @"garmentId", @"minutes", @"orderId", @"orderUniqueId", @"priority", nil];
}

- (NSString *)entityNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"garmentType"]) return @"GarmentType";

    return [super entityNameForMappedField:fieldName];
}

- (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end