//
//  _GroupDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "GroupSummaryDto.h"
#import "GroupLogisticDto.h"
#import "GroupOffersDto.h"
#import "GroupReservationsDto.h"
#import "GroupCallLogListDto.h"

@interface _GroupDto : XSDBaseEntity

@property(nonatomic, strong) GroupSummaryDto *groupSummary;
@property(nonatomic, strong) GroupLogisticDto *groupLogistic;
@property(nonatomic, strong) GroupOffersDto *groupOffers;
@property(nonatomic, strong) GroupReservationsDto *groupReservations;
@property(nonatomic, strong) GroupCallLogListDto *callLogShortList;

@end
