//
//  _ReservationAddItemsRequestDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ReservationAddItemsRequestDto.h"

@implementation _ReservationAddItemsRequestDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"addItemList", @"shipToStore", @"pickComment1", @"pickComment2", @"measurementDto", @"changedBy"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"addItemList"]) return @"AddItemDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
