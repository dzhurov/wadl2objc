//
//  _ReservationOffersDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "MessageDto.h"
#import "XSDEnums.h"

@interface _ReservationOffersDto : XSDBaseEntity

@property(nonatomic, strong) NSString *reservationNo;
@property(nonatomic, strong) NSString *discountCode;
@property(nonatomic, strong) NSString *discountDescription;
/*![StyleItemType]*/
@property(nonatomic, strong) __GENERICS(NSArray, NSNumber*) *requiredItems;
@property(nonatomic, strong) NSString *promotionCode;
/*! BOOL */
@property(nonatomic, strong) NSNumber *freeTux;
/*! BOOL */
@property(nonatomic, strong) NSNumber *freeSuit;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *discountFactor1;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *discountFactor2;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *discountFactor3;
/*![MessageDto]*/
@property(nonatomic, strong) __GENERICS(NSArray, MessageDto*) *messages;

@end
