//
//  _Customer.h
//
//  Generated by wadl2objc 2013.09.03 14:51:56.
//  XSD v.1.0

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
#import "XSDEnums.h"

@interface _Customer : BaseEntity

@property(nonatomic) ContactPreferences contactPreferences;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic) Gender gender;
@property(nonatomic, strong) NSNumber *id;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSString *phoneNumber;
@property(nonatomic, strong) NSNumber *regularWearer;

@end
