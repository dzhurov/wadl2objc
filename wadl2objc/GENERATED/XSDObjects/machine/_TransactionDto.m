//
//  _TransactionDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_TransactionDto.h"

@implementation _TransactionDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = [@[@"transactionId", @"submitDate", @"authorizedTenders", @"customer", @"lineItems", @"taxExemption", @"transactionType", @"uuid"] arrayByAddingObjectsFromArray:[super mappedKeys]];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"transactionType"]) return @"RestTransactionType";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"authorizedTenders"]) return @"TenderDto";
	if ([fieldName isEqualToString:@"lineItems"]) return @"LineItemDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
