//
//  _Role.m
//
//  Generated by wadl2objc 2013.08.30 17:01:09.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_Role.h"

@implementation _Role

#pragma mark - Mapping

- (void)setDictionaryInfo:(NSDictionary *)dictionaryInfo
{
    [self setDictionaryInfo:dictionaryInfo forKeys: @"id", @"roleName", nil];
}

- (NSMutableDictionary*)dictionaryInfo
{
    [self dictionaryInfoForKeys: @"id", @"roleName", nil];
}

- (NSString *)entityNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"type"]) return @"RoleType";

    return [super entityNameForMappedField:fieldName];
}

- (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
