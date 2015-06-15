//
//  XSDObjectRepresentation.h
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSDNamespase.h"

@interface XSDObject : NSObject

@property (nonatomic, strong) XSDNamespase *namespace;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *extension;
@property (nonatomic, strong) NSMutableArray *dependencies;
@property (nonatomic, strong) NSMutableArray *properties;
@property (nonatomic, strong) NSMutableArray *weekRelations;


@end
