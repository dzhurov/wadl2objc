//
//  _DiagnosticResultDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "MessageDto.h"

@interface _DiagnosticResultDto : XSDBaseEntity

@property(nonatomic, strong) MessageDto *errorMessage;
/*! BOOL */
@property(nonatomic, strong) NSNumber *isSuccessful;
@property(nonatomic, strong) NSString *contactList;
@property(nonatomic, strong) NSString *resultText;

@end
