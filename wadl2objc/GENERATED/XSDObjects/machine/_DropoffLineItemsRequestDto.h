//
//  _DropoffLineItemsRequestDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "ReservationPosGarmentsDto.h"
#import "TransactionDto.h"

@interface _DropoffLineItemsRequestDto : XSDBaseEntity

/*![ReservationPosGarmentsDto]*/
@property(nonatomic, strong) NSArray *garmentsDtoList;
@property(nonatomic, strong) TransactionDto *transactionDto;

@end