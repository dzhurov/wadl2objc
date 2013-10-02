//
//  _ProductItem.m
//
//  Generated by wadl2objc 2013.09.03 14:51:56.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ProductItem.h"

@implementation _ProductItem

#pragma mark - Mapping

+ (NSArray*)mappedKays
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"defaultQuantity", @"division", @"garmentTypes", @"id", @"itemDescription", @"itemId", @"retailPrice"];
    }
    return keys;
}

+ (NSString *)entityNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"garmentTypes"]) return @"GarmentType";

    return [super entityNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"garmentTypes"]) return @"GarmentType";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
