//
//  _AddFeeRequestDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "LineItemDto.h"
#import "FeeDto.h"
#import "CustomerDto.h"

@interface _AddFeeRequestDto : XSDBaseEntity

@property(nonatomic, strong) LineItemDto *lineItem;
@property(nonatomic, strong) FeeDto *fee;
@property(nonatomic, strong) CustomerDto *customer;

@end