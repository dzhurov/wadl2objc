//
//  _EventDatesDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"

@interface _EventDatesDto : XSDBaseEntity

@property(nonatomic, strong) XSDDate *eventDate;
@property(nonatomic, strong) XSDDate *returnDate;
@property(nonatomic, strong) XSDDate *pickupDate;
@property(nonatomic, strong) XSDDate *fitByDate;
/*! BOOL */
@property(nonatomic, strong) NSNumber *rushFeeAlert;

@end
