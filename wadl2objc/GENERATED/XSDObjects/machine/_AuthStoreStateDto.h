//
//  _AuthStoreStateDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "XSDEnums.h"

@interface _AuthStoreStateDto : XSDBaseEntity

@property(nonatomic, strong) NSString *storeNumber;
@property(nonatomic, strong) NSString *registerNumber;
@property(nonatomic, strong) NSString *lastTxNumber;
@property(nonatomic, strong) XSDDateTime *storeProcessDate;
@property(nonatomic, strong) XSDDateTime *lastTxDateTime;
@property(nonatomic, strong) NSString *deviceId;
/*! BOOL */
@property(nonatomic, strong) NSNumber *open;
@property(nonatomic) Company company;

@end