//
//  _QuestionnaireStatusDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "XSDEnums.h"

@interface _QuestionnaireStatusDto : XSDBaseEntity

@property(nonatomic, strong) NSString *reservationNo;
@property(nonatomic, strong) NSString *questionnaireName;
@property(nonatomic) QuestionnaireStatus questionnaireStatus;

@end