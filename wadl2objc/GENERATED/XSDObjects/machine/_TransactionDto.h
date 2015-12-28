//
//  _TransactionDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "TenderDto.h"
#import "SkuDetailDto.h"
#import "CustomerDto.h"
#import "LineItemDto.h"
#import "TaxExemptionDto.h"
#import "MessageDto.h"
#import "XSDEnums.h"

@interface _TransactionDto : XSDBaseEntity

@property(nonatomic, strong) NSString *transactionId;
@property(nonatomic, strong) XSDDateTime *submitDate;
/*![TenderDto]*/
@property(nonatomic, strong) __GENERICS(NSArray, TenderDto*) *authorizedTenders;
/*![SkuDetailDto]*/
@property(nonatomic, strong) __GENERICS(NSArray, SkuDetailDto*) *skuDetails;
@property(nonatomic, strong) CustomerDto *customer;
/*![LineItemDto]*/
@property(nonatomic, strong) __GENERICS(NSArray, LineItemDto*) *lineItems;
@property(nonatomic, strong) TaxExemptionDto *taxExemption;
@property(nonatomic) RestTransactionType transactionType;
@property(nonatomic, strong) NSString *uuid;
/*![MessageDto]*/
@property(nonatomic, strong) __GENERICS(NSArray, MessageDto*) *messages;

@end
