//
//  _GroupSummaryDto.h
//
//  Generated by wadl2objc 2013.11.21 19:10:46.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
#import "GroupRepresentativeDto.h"
#import "GroupRepresentativeDto.h"
#import "XSDEnums.h"

@interface _GroupSummaryDto : BaseEntity

/*! long */
@property(nonatomic, strong) NSNumber *groupId;
@property(nonatomic, strong) XSDDate *eventDate;
@property(nonatomic) GroupType groupType;
@property(nonatomic) EventType eventType;
/*! long */
@property(nonatomic, strong) NSNumber *schoolNo;
@property(nonatomic, strong) GroupRepresentativeDto *representative1;
@property(nonatomic, strong) GroupRepresentativeDto *representative2;
@property(nonatomic, strong) NSString *groupComment;
@property(nonatomic, strong) XSDDateTime *bookingDate;
@property(nonatomic) GenderType repGender;

@end
