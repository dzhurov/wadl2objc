//
//  _BridalShowCallListDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_BridalShowCallListDto.h"

@implementation _BridalShowCallListDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"bridalShowCallList", @"totalResults"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"bridalShowCallList"]) return @"BridalShowCallDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end