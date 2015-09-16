//
//  _ErrorDto.m
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_ErrorDto.h"

@implementation _ErrorDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = [@[@"errorDescription", @"code", @"incidentId", @"type", @"errorDetails", @"needRefreshReservation", @"needRefreshReservationNo"] arrayByAddingObjectsFromArray:[super mappedKeys]];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"code"]) return @"ErrorCode";
	if ([fieldName isEqualToString:@"type"]) return @"ErrorType";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
