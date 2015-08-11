//
//  _ReservationMeasurementDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"

@interface _ReservationMeasurementDto : XSDBaseEntity

@property(nonatomic, strong) NSString *reservationNo;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *chest;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *overarm;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *coatSleeve;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *waist;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *hip;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *outSeam;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *neck;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *shirtSleeve;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *height;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *weight;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *shoes;
@property(nonatomic, strong) NSString *measuredBy;

@end