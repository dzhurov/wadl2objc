//
//  _AlteredGarmentInfo.h
//
//  Generated by wadl2objc 2013.09.03 14:51:56.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
#import "XSDEnums.h"

@interface _AlteredGarmentInfo : BaseEntity

@property(nonatomic, strong) NSString *garmentId;
@property(nonatomic) GarmentType garmentType;
@property(nonatomic, strong) NSNumber *minutes;
@property(nonatomic, strong) NSString *orderId;
@property(nonatomic, strong) NSNumber *orderUniqueId;
@property(nonatomic, strong) NSNumber *priority;

@end
