//
//  _ReservationDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "ReservationSummaryDto.h"
#import "ReservationStyleListDto.h"

@interface _ReservationDto : XSDBaseEntity

@property(nonatomic, strong) ReservationSummaryDto *summary;
@property(nonatomic, strong) ReservationStyleListDto *styles;

@end