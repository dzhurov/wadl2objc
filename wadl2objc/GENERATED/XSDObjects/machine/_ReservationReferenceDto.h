//
//  _ReservationReferenceDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "StyleInformationDto.h"
#import "XSDEnums.h"

@interface _ReservationReferenceDto : XSDBaseEntity

@property(nonatomic) ReservationReferenceType type;
@property(nonatomic, strong) NSString *reservationNo;
@property(nonatomic) ReservationStatus status;
@property(nonatomic) ReservationSource source;
@property(nonatomic, strong) NSString *shipToStore;
@property(nonatomic, strong) NSString *info;
/*![StyleInformationDto]*/
@property(nonatomic, strong) NSArray *styles;

@end