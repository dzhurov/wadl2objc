//
//  _Alteration.h
//
//  Generated by wadl2objc 2013.08.30 17:01:09.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
#import "AlterationItemPrice.h"
#import "XSDSimpleTypes.h"

@interface _Alteration : BaseEntity

@property(nonatomic, strong) GarmentType garmentType
@property(nonatomic, strong) NSNumber *id
@property(nonatomic, strong) NSNumber *inwards
@property(nonatomic, strong) AlterationItemPrice *item
@property(nonatomic, strong) NSNumber *maxQuantity
@property(nonatomic, strong) NSString *name
@property(nonatomic, strong) NSNumber *rank

@end
