//
//  _SearchResultDto.h
//
//  Generated by wadl2objc 2013.11.21 19:10:46.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
#import "OrderDto.h"

@interface _SearchResultDto : BaseEntity

@property(nonatomic, strong) NSArray *orders;
/*! int */
@property(nonatomic, strong) NSNumber *firstResultNumber;
/*! int */
@property(nonatomic, strong) NSNumber *resultsNumber;

@end
