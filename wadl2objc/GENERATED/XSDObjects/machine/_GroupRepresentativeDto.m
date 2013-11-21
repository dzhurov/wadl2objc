//
//  _GroupRepresentativeDto.m
//
//  Generated by wadl2objc 2013.11.21 19:10:46.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import "_GroupRepresentativeDto.h"

@implementation _GroupRepresentativeDto

#pragma mark - Mapping

+ (NSArray*)mappedKeys
{
    static NSArray *keys = nil;
    if ( !keys ){
        keys = @[@"firstName", @"lastName", @"phone", @"address1", @"city", @"state", @"zip", @"email", @"role", @"gradeLevel", @"phoneExt"];
    }
    return keys;
}

+ (NSString *)enumNameForMappedField:(NSString*)fieldName
{
	if ([fieldName isEqualToString:@"role"]) return @"RepresentativeRole";
	if ([fieldName isEqualToString:@"gradeLevel"]) return @"GradeLevelType";

    return [super enumNameForMappedField:fieldName];
}

+ (NSString *)classNameOfMembersForMappedField:(NSString*)fieldName
{

    return [super classNameOfMembersForMappedField:fieldName];
}

@end
