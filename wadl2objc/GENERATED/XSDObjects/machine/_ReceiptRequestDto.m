//
//  _ReceiptRequestDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ReceiptRequestDto.h"

@implementation _ReceiptRequestDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"receiptType", @"receiptTargetType", @"receiptTargetName", @"receiptSource", @"receiptTime", @"numberOfCopies"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"receiptType"]) return @"ReceiptType";
	if ([fieldName isEqualToString:@"receiptTargetType"]) return @"ReceiptTargetType";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end