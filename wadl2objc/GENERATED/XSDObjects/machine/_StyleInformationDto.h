//
//  _StyleInformationDto.h
//
//  Generated by wadl2objc 2013.11.21 19:10:46.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
#import "StyleSizeDto.h"
#import "XSDEnums.h"

@interface _StyleInformationDto : BaseEntity

@property(nonatomic) StyleItemType itemType;
@property(nonatomic, strong) NSString *styleNumber;
@property(nonatomic, strong) NSString *styleDescription;
@property(nonatomic, strong) NSString *rentalPrice;
@property(nonatomic, strong) NSArray *blockedSizes;

@end
