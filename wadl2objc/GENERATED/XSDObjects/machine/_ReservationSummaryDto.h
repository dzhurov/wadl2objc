//
//  _ReservationSummaryDto.h
//
//  Generated by wadl2objc 2013.11.21 19:10:46.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
#import "PromDetailDto.h"
#import "XSDEnums.h"

@interface _ReservationSummaryDto : BaseEntity

@property(nonatomic, strong) NSString *reservationNo;
/*! long */
@property(nonatomic, strong) NSNumber *groupId;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic) ReservationRole role;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *custEmail;
@property(nonatomic, strong) NSString *groupComment;
@property(nonatomic, strong) NSString *storeComment;
@property(nonatomic) ReservationStatus status;
@property(nonatomic, strong) NSString *auditedBy;
@property(nonatomic, strong) NSString *groupName;
@property(nonatomic) EventType eventType;
@property(nonatomic, strong) XSDDate *eventDate;
@property(nonatomic, strong) NSString *salesPerson;
@property(nonatomic, strong) NSString *shipToStore;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *source;
@property(nonatomic, strong) NSString *posStatus;
/*! float */
@property(nonatomic, strong) NSNumber *amountDue;
@property(nonatomic, strong) NSString *storeNo;
/*! long */
@property(nonatomic, strong) NSNumber *schoolNo;
@property(nonatomic, strong) NSString *payorPhone;
@property(nonatomic, strong) NSString *payorFName;
@property(nonatomic, strong) NSString *payorLName;
@property(nonatomic, strong) NSString *payorEmail;
@property(nonatomic, strong) PromDetailDto *promDetail;

@end
