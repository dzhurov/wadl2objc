//
//  _ChangeItemsLostFeeRequestDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "LineItemDto.h"
#import "CustomerDto.h"

@interface _ChangeItemsLostFeeRequestDto : XSDBaseEntity

@property(nonatomic, strong) LineItemDto *lineItemDto;
@property(nonatomic, strong) CustomerDto *customerDto;

@end