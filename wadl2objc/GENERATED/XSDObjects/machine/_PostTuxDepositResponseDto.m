//
//  _PostTuxDepositResponseDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_PostTuxDepositResponseDto.h"

@implementation _PostTuxDepositResponseDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = [@[@"lineItemReceipts", @"paymentReceipts", @"hasCoupons", @"transactionId", @"submitDate"] arrayByAddingObjectsFromArray:[super mappedKeys]];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"lineItemReceipts"]) return @"LineItemReceiptDto";
	if ([fieldName isEqualToString:@"paymentReceipts"]) return @"PaymentReceiptDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
