//
//  _UpdateDueDateRequest.m
//
//  Generated by wadl2objc 2013.08.30 17:01:09.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_UpdateDueDateRequest.h"

@implementation _UpdateDueDateRequest

#pragma mark - Mapping

- (void)setDictionaryInfo:(NSDictionary *)dictionaryInfo
{
    [self setDictionaryInfo:dictionaryInfo forKeys: @"dueDate", @"orderId", nil];
}

- (NSMutableDictionary*)dictionaryInfo
{
    [self dictionaryInfoForKeys: @"dueDate", @"orderId", nil];
}

- (NSString *)entityNameForMappedField:(NSString*)fieldName
{

    return [super entityNameForMappedField:fieldName];
}

- (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
