//
//  _SchoolListDto.h
//
//  Generated by wadl2objc.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "XSDBaseEntity.h"
#import "SchoolDto.h"

@interface _SchoolListDto : XSDBaseEntity

/*![SchoolDto]*/
@property(nonatomic, strong) NSArray *schoolDtoList;
/*! int */
@property(nonatomic, strong) NSNumber *firstResult;
/*! int */
@property(nonatomic, strong) NSNumber *lastResult;
/*! int */
@property(nonatomic, strong) NSNumber *totalCount;
@property(nonatomic, strong) XSDDateTime *lastModified;

@end