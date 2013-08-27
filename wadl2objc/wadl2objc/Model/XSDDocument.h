//
//  XSDDocument.h
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface XSDDocument : NSObject

@property (nonatomic, strong) NSString *version; 
@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) NSArray *simpleTypes;

- (id)initWithData:(NSData*)data;
- (void)setXSDDictionary: (NSDictionary*)dictionary;


- (void)writeObjectsToPath:(NSString*)path;

@end
