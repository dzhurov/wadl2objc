//
//  _LineItemModifierDto.m
//
//  Generated by wadl2objc 2013.11.21 19:10:46.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_LineItemModifierDto.h"

@implementation _LineItemModifierDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"modifierStatus", @"modifierType", @"modifierValue"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"modifierStatus"]) return @"ModifierStatus";
	if ([fieldName isEqualToString:@"modifierType"]) return @"ModifierType";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
