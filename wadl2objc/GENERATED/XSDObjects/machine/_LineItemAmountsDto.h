//
//  _LineItemAmountsDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"

@interface _LineItemAmountsDto : XSDBaseEntity

/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *rentalAmount;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *damageAndHandlingFees;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *lateFees;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *rushFees;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *changeOrderFees;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *lostFees;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *markdowns;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *discount;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *estimatedTaxes;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *estimatedAmountDue;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *totalRentalPrice;

@end