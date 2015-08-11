//
//  _ReservationCommitDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "SignatureDto.h"

@interface _ReservationCommitDto : XSDBaseEntity

/*! BOOL */
@property(nonatomic, strong) NSNumber *overrideDiscount;
@property(nonatomic, strong) SignatureDto *reservationSignature;
@property(nonatomic, strong) NSString *reservationNo;
@property(nonatomic, strong) NSString *payorEmail;
@property(nonatomic, strong) NSString *payorPhone;
@property(nonatomic, strong) NSString *payorFName;
@property(nonatomic, strong) NSString *payorLName;

@end