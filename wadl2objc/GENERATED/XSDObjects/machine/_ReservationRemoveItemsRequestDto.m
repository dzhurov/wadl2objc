//
//  _ReservationRemoveItemsRequestDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ReservationRemoveItemsRequestDto.h"

@implementation _ReservationRemoveItemsRequestDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"removeItemList", @"changedBy"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"removeItemList"]) return @"RemoveItemDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
