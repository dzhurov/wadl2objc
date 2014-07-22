//
//  WADLService.h
//  wadl2objc
//
//  Created by DZhurov on 10/10/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WADLServiceSection;
@interface WADLService : NSObject

- (id)initWithDictionary:(NSDictionary*)dictionary parentSection:(WADLServiceSection*)parantSection;

@property (nonatomic, strong) WADLServiceSection *parentServiceSection;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *method; // GET, PUT, POST, DELETE
@property (nonatomic, strong) NSString *requestObjectClass;
@property (nonatomic, strong) NSString *responseObjectClass;

- (NSArray *)allQueryParameters;
- (NSArray *)allPathParameters;
- (NSArray *)allHeadParameters;
- (NSString*)fullPath;
- (NSString*)objcMethodName;

@end
