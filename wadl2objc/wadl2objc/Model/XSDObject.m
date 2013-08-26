//
//  XSDObjectRepresentation.m
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#define synthesizeLazzyProperty(propertyName, propertyType) \
- (NSMutableArray *)propertyName \
{ \
    if ( !_##propertyName ){ \
        _##propertyName = [[propertyType alloc] init]; \
    } \
    return _##propertyName; \
} \


#import "XSDObject.h"

@implementation XSDObject
synthesizeLazzyProperty(dependencies, NSMutableArray);
synthesizeLazzyProperty(properties, NSMutableArray);
synthesizeLazzyProperty(weekRelations, NSMutableArray);


@end
