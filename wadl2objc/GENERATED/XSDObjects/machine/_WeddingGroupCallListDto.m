//
//  _WeddingGroupCallListDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_WeddingGroupCallListDto.h"

@implementation _WeddingGroupCallListDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"weddingGroupCallList", @"dateRangeStart", @"dateRangeEnd", @"eventDate"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"weddingGroupCallList"]) return @"WeddingGroupCallDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end