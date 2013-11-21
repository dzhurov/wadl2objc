//
//  _SizeListDto.m
//
//  Generated by wadl2objc 2013.11.21 19:10:46.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_SizeListDto.h"

@implementation _SizeListDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"suggestedSizes", @"allowedSizes"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"suggestedSizes"]) return @"SizeDto";
	if ([fieldName isEqualToString:@"allowedSizes"]) return @"SizeDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
