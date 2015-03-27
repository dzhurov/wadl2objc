//
//  _ReservationReorderRequestDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ReservationReorderRequestDto.h"

@implementation _ReservationReorderRequestDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"reorderItemList", @"shipToStore", @"pickComment1", @"pickComment2", @"measurementDto", @"changedBy"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"reorderItemList"]) return @"ReservationReorderItemDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
