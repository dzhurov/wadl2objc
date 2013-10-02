//
//  _AlteredGarment.h
//
//  Generated by wadl2objc 2013.09.03 14:51:56.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
#import "User.h"
#import "DivisionColor.h"
#import "ProductItem.h"
#import "OrderedAlteration.h"
#import "XSDEnums.h"

@interface _AlteredGarment : BaseEntity

@property(nonatomic, strong) User *assignedTo;
@property(nonatomic, strong) NSNumber *childSize;
@property(nonatomic, strong) DivisionColor *color;
@property(nonatomic, strong) NSNumber *formal;
@property(nonatomic, strong) NSString *garmentId;
@property(nonatomic) GarmentType garmentType;
@property(nonatomic, strong) NSString *groupId;
@property(nonatomic, strong) NSNumber *id;
@property(nonatomic, strong) ProductItem *item;
@property(nonatomic, strong) NSString *itemCode;
@property(nonatomic, strong) NSNumber *new;
@property(nonatomic, strong) NSString *note;
@property(nonatomic, strong) NSNumber *orderId;
@property(nonatomic, strong) NSArray *orderedAlterations;
@property(nonatomic, strong) NSNumber *parentGarmentId;
@property(nonatomic, strong) NSNumber *purchasedAtTMW;
@property(nonatomic, strong) NSNumber *rfaRelated;
@property(nonatomic, strong) NSDate *scheduledDateTime;
@property(nonatomic) Status status;

@end
