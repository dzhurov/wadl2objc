//
//  _DiscountInfoDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "XSDEnums.h"

@interface _DiscountInfoDto : XSDBaseEntity

@property(nonatomic, strong) NSString *discountCode;
@property(nonatomic, strong) NSString *discountDescription;
/*![StyleItemType]*/
@property(nonatomic, strong) NSArray *requiredItems;
/*![EventType]*/
@property(nonatomic, strong) NSArray *eventTypes;
@property(nonatomic, strong) XSDDate *startDate;
@property(nonatomic, strong) XSDDate *endDate;

@end
