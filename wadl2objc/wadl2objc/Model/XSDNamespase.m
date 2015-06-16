//
//  XSDNamespase.m
//  wadl2objc
//
//  Created by DZhurov on 6/12/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import "XSDNamespase.h"
#import "XSDTypes.h"

@implementation XSDNamespase

- (NSString *)classNameForXSDType:(NSString *)objectType
{
    NSString *className = [NSString stringWithFormat:@"%@%@%@", safeString(self.objcPrefix), formattedType([objectType stringBySplittingXMLPrefix:nil]), safeString(self.objcSuffix) ];
    return className;
}

- (BOOL)isEqual:(XSDNamespase*)object
{
    if ([object isKindOfClass:[self class]]){
        return [self.namespaceId isEqualToString:object.namespaceId];
    }
    return NO;
}

- (NSUInteger)hash
{
    return self.namespaceId.hash;
}

@end
