//
//  _EmailInfo.m
//
//  Generated by wadl2objc 2013.08.30 17:01:09.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_EmailInfo.h"

@implementation _EmailInfo

#pragma mark - Mapping

- (void)setDictionaryInfo:(NSDictionary *)dictionaryInfo
{
    [self setDictionaryInfo:dictionaryInfo forKeys: nil];
}

- (NSMutableDictionary*)dictionaryInfo
{
    [self dictionaryInfoForKeys: nil];
}

- (NSString *)entityNameForMappedField:(NSString*)fieldName
{

    return [super entityNameForMappedField:fieldName];
}

- (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"users"]) return @"NSString";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
