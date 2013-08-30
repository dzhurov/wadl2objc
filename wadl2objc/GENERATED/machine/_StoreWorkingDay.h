//
//  ExampleEntity.m
//
//  Generated by wadl2objc 8/27/13.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
#import "Store.h"
#import "XSDSimpleTypes.h"

@interface _StoreWorkingDay : BaseEntity

@property(nonatomic, strong) NSDate *closeHour
@property(nonatomic, strong) DayOfWeek dayOfWeek
@property(nonatomic, strong) NSDate *defaultDueTime
@property(nonatomic, strong) NSNumber *id
@property(nonatomic, strong) NSDate *openHour
@property(nonatomic, strong) Store *store

@end
