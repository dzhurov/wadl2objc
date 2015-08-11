//
//  _DropoffDcReceiptRequestDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_DropoffDcReceiptRequestDto.h"

@implementation _DropoffDcReceiptRequestDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"reservationPosGarments", @"receiptTargets"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"receiptTargets"]) return @"ReceiptTargetDto";

    return [super classNameOfMembersForMappedField:fieldName];
}

@end