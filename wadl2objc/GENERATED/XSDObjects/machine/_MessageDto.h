//
//  _MessageDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "XSDEnums.h"

@interface _MessageDto : XSDBaseEntity

@property(nonatomic, strong) NSString *message;
@property(nonatomic) MessageLevel level;
@property(nonatomic) MessageType messageType;
@property(nonatomic) MessageTarget messageTarget;
@property(nonatomic, strong) NSString *messageTargetName;

@end
