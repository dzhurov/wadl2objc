//
//  XSDObjectRepresentation.m
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "XSDObject.h"
#import "Utilities.h"

@implementation XSDObject
synthesizeLazzyProperty(dependencies, NSMutableArray);
synthesizeLazzyProperty(properties, NSMutableArray);
synthesizeLazzyProperty(weekRelations, NSMutableArray);


@end
