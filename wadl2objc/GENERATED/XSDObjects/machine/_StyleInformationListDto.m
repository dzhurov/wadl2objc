//
//  _StyleInformationListDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_StyleInformationListDto.h"

@implementation _StyleInformationListDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = [@[@"styleInformationDtoList"] arrayByAddingObjectsFromArray:[super mappedKeys]];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"styleInformationDtoList"]) return @"StyleInformationDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
