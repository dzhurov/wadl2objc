//
//  XSDSimpleType.h
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>


// Representation of enum in xsd
@interface XSDSimpleType : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *enumType;
@property (nonatomic, strong) NSString *baseType;
@property (nonatomic, strong) NSMutableArray *options;

- (NSString *)nameOfMappingMethod;          //fromString
- (NSString *)nameOfInverseMappingMethod;   //toStrong

@end
