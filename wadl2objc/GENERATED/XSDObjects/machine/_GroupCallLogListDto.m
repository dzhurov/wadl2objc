//
//  _GroupCallLogListDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_GroupCallLogListDto.h"

@implementation _GroupCallLogListDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"groupCallLogList", @"totalCount"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"groupCallLogList"]) return @"GroupCallLogDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
