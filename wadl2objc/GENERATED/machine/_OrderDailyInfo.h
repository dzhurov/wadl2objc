//
//  _OrderDailyInfo.h
//
//  Generated by wadl2objc 2013.09.02 11:52:45.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
#import "XSDSimpleTypes.h"

@interface _OrderDailyInfo : BaseEntity

@property(nonatomic, strong) NSString *firstName
@property(nonatomic, strong) NSString *lastName
@property(nonatomic, strong) NSNumber *minutes
@property(nonatomic, strong) NSString *orderId
@property(nonatomic, strong) OrderType orderType
@property(nonatomic, strong) NSNumber *orderUniqueId
@property(nonatomic, strong) Status status

@end
