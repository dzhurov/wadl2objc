//
//  _ApplyCouponRequestDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "LineItemDto.h"
#import "CustomerDto.h"

@interface _ApplyCouponRequestDto : XSDBaseEntity

@property(nonatomic, strong) LineItemDto *lineItem;
@property(nonatomic, strong) NSString *coupon;
@property(nonatomic, strong) CustomerDto *customer;

@end
