//
//  _WeddingGroupCallDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "GroupSummaryDto.h"
#import "XSDEnums.h"

@interface _WeddingGroupCallDto : XSDBaseEntity

@property(nonatomic, strong) GroupSummaryDto *groupSummary;
@property(nonatomic) GroupDispositionCode dispositionCode;
@property(nonatomic, strong) NSString *callerNotes;

@end
