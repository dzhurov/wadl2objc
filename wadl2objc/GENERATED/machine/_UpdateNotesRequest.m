//
//  _UpdateNotesRequest.m
//
//  Generated by wadl2objc 2013.09.02 11:52:45.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_UpdateNotesRequest.h"

@implementation _UpdateNotesRequest

#pragma mark - Mapping

+ (NSArray*)mappedKays
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"garmentId", @"notes"];
    }
    return keys;
}

+ (NSString *)entityNameForMappedField:(NSString*)fieldName
{

    return [super entityNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
