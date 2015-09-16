//
//  _ReceiptResponseDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ReceiptResponseDto.h"

@implementation _ReceiptResponseDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = [@[@"receiptType", @"receiptTargetType", @"receiptTargetName", @"receiptSource", @"status"] arrayByAddingObjectsFromArray:[super mappedKeys]];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"receiptType"]) return @"ReceiptType";
	if ([fieldName isEqualToString:@"receiptTargetType"]) return @"ReceiptTargetType";
	if ([fieldName isEqualToString:@"status"]) return @"ReceiptStatus";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
