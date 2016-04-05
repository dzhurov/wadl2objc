//
//  WADLServiceSection.h
//  wadl2objc
//
//  Created by DZhurov on 10/10/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WADLServicePathParameter;
@class WADLService;

@interface WADLServiceSection : NSObject

- (id)initWithDictionary:(NSDictionary*)dictionary parantSection:(WADLServiceSection*)parantSection;

@property (nonatomic,strong) NSString *path;
@property (nonatomic, strong) WADLServiceSection *parantServiceSection;
@property (nonatomic, strong) __GENERICS(NSMutableArray, WADLServiceSection*) *childSections;
@property (nonatomic, strong) __GENERICS(NSMutableArray, WADLServicePathParameter*) *pathParameters;
@property (nonatomic, strong) __GENERICS(NSMutableArray, WADLService*) *services;

- (NSString*)fullPath;
- (NSArray*)urlPathAndMethods; 
- (__GENERICS(NSMutableArray, WADLService*)*)allMethods;
- (__GENERICS(NSArray, NSString*)*)allServicesClasses;
- (NSString*)pathName;
- (NSString*)shortPathName;
- (NSDictionary*)allPathNamesToPaths;
- (NSString*)className;

@end
