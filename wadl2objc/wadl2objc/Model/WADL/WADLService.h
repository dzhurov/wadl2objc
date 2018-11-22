//
//  WADLService.h
//  wadl2objc
//
//  Created by DZhurov on 10/10/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WADLServiceSection, WADLServicePathParameter;
@interface WADLService : NSObject

- (id)initWithDictionary:(NSDictionary*)dictionary parentSection:(WADLServiceSection*)parantSection;

@property (nonatomic, strong) WADLServiceSection *parentServiceSection;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *method; // GET, PUT, POST, DELETE
@property (nonatomic, strong) NSString *requestObjectClass;
@property (nonatomic, strong) NSString *responseObjectClass;

@property (nonatomic, strong) NSString *overridenName;

@property (nonatomic, strong) NSMutableArray<WADLServicePathParameter*> *queryParameters;
@property (nonatomic, strong) NSMutableArray<WADLServicePathParameter*> *headParameters;

- (NSArray *)allPathParameters;
- (NSString*)fullPath;

//! Depends on overridenMethodName
- (NSString*)objcMethodName;
- (NSString *)objcSelector;

@end
