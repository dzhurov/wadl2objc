//
//  _AuthResponseDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "XSDEnums.h"

@interface _AuthResponseDto : XSDBaseEntity

@property(nonatomic) AuthResponseType authResult;
@property(nonatomic, strong) NSString *referralAuthCode;
@property(nonatomic, strong) NSString *statusCode;
/*! xs:decimal */
@property(nonatomic, strong) NSDecimalNumber *authAmount;
@property(nonatomic) AuthResponseType referralResult;
@property(nonatomic, strong) NSString *responseMessage;

@end
