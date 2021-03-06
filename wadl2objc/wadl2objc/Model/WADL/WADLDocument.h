//
//  WADLDocument.h
//  wadl2objc
//
//  Created by Dmitry on 9/29/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSDDocument.h"

@interface WADLDocument : NSObject

- (id)initWithData:(NSData*)data;
- (void)setWADLDictionary: (NSDictionary*)dictionary;
- (void)writeObjectsToPath:(NSString *)path;

@property (nonatomic, strong) NSMutableArray *wadlServiceSections;
@property (nonatomic, strong) XSDDocument *xsdDocument;
@property (nonatomic, strong) NSString *baseURLPath;

@end
