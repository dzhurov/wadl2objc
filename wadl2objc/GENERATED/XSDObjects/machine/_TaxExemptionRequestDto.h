//
//  _TaxExemptionRequestDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "TransactionDto.h"
#import "TaxExemptionDto.h"

@interface _TaxExemptionRequestDto : XSDBaseEntity

@property(nonatomic, strong) TransactionDto *transaction;
@property(nonatomic, strong) TaxExemptionDto *taxExemptionDto;

@end