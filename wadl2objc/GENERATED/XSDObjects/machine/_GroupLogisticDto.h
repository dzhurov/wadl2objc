//
//  _GroupLogisticDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "MessageDto.h"

@interface _GroupLogisticDto : XSDBaseEntity

/*! long */
@property(nonatomic, strong) NSNumber *groupId;
@property(nonatomic, strong) XSDDate *createDate;
@property(nonatomic, strong) XSDDate *eventDate;
@property(nonatomic, strong) NSString *bookingStore;
@property(nonatomic, strong) XSDDate *fitByDate;
@property(nonatomic, strong) XSDDate *pickupDate;
@property(nonatomic, strong) XSDDate *returnDate;
@property(nonatomic, strong) NSString *salesPerson;
/*![MessageDto]*/
@property(nonatomic, strong) NSArray *messages;
/*! BOOL */
@property(nonatomic, strong) NSNumber *noPickupNotification;

@end
