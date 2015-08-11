//
//  _LineItemStateDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "FeeDto.h"
#import "MarkdownDto.h"
#import "MarkdownDto.h"
#import "TaxExemptionDto.h"

@interface _LineItemStateDto : XSDBaseEntity

/*![FeeDto]*/
@property(nonatomic, strong) NSArray *additionalFees;
/*! BOOL */
@property(nonatomic, strong) NSNumber *couponDiscountApplied;
@property(nonatomic, strong) NSString *discountCoupon;
/*![MarkdownDto]*/
@property(nonatomic, strong) NSArray *markdowns;
/*! BOOL */
@property(nonatomic, strong) NSNumber *pfDiscountApplied;
/*![MarkdownDto]*/
@property(nonatomic, strong) NSArray *removedMarkdowns;
@property(nonatomic, strong) TaxExemptionDto *taxExemptionDto;

@end
