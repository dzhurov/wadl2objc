//
//  _ChangeRequestDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ChangeRequestDto.h"

@implementation _ChangeRequestDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"addItemsRequestDto", @"removeItemsRequestDto", @"reorderRequestDto", @"addHatPackageRequestDto", @"reorderStatus", @"dontAddChangeFee", @"removeHatPackage"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"reorderStatus"]) return @"ReservationReorderStatus";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end