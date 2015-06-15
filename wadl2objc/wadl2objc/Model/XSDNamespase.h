//
//  XSDNamespase.h
//  wadl2objc
//
//  Created by DZhurov on 6/12/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSDNamespase : NSObject

@property (nonatomic, strong) NSString *xsdPrefix;
@property (nonatomic, strong) NSString *objcPrefix;
@property (nonatomic, strong) NSString *objcSuffix;
@property (nonatomic, strong) NSString *namespaceId;
@property (nonatomic, strong) NSString *name;

- (NSString *)classNameForXSDType:(NSString *)xsdType;

@end
