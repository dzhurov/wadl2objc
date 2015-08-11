//
//  _ReceiptResponseListDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ReceiptResponseListDto.h"

@implementation _ReceiptResponseListDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"responses", @"messages"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"responses"]) return @"ReceiptResponseDto";
	if ([fieldName isEqualToString:@"messages"]) return @"MessageDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
