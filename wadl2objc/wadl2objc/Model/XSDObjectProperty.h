//
//  XSDObjectField.h
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSDObjectProperty : NSObject

@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSString *type;
@property (nonatomic) BOOL isCollection;
@property (nonatomic, strong) NSDictionary *methadata; // used for arrays;

@end
