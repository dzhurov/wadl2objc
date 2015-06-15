//
//  XSDSimpleTypes.h
//  wadl2objc
//
//  Created by DZhurov on 6/15/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSDSimpleTypes : NSObject

/*! [XSDSimpleType]*/
@property (nonatomic, strong) NSArray *simpleTypes;

- (instancetype)initWithXSDDocuments:(NSArray*)xsdDocuments;
- (void)writeObjectsToPath:(NSString*)path;


@end
