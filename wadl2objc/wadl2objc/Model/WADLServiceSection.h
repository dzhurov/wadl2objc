//
//  WADLServiceSection.h
//  wadl2objc
//
//  Created by DZhurov on 10/10/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WADLDocument;
@class WADLServicePathParameter;
@class WADLService;

@interface WADLServiceSection : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)dictionary wadlDocument:(WADLDocument*)wadlDocument;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary parantSection:(WADLServiceSection*)parantSection;

@property (nonatomic,strong) NSString *path;
@property (nonatomic, weak) WADLDocument *wadlDocument;
@property (nonatomic, strong) WADLServiceSection *parantServiceSection;
@property (nonatomic, strong) __GENERICS(NSMutableArray, WADLServiceSection*) *childSections;
@property (nonatomic, strong) __GENERICS(NSMutableArray, WADLServicePathParameter*) *pathParameters;
@property (nonatomic, strong) __GENERICS(NSMutableArray, WADLServicePathParameter*) *queryParameters;
@property (nonatomic, strong) __GENERICS(NSMutableArray, WADLServicePathParameter*) *headParameters;
@property (nonatomic, strong) __GENERICS(NSMutableArray, WADLService*) *services;

- (NSString*)fullPath;
- (NSArray*)urlPathAndMethods; 
- (__GENERICS(NSMutableArray, WADLService*)*)allMethods;
- (__GENERICS(NSArray, NSString*)*)allServicesClasses;
- (NSString*)pathName;
- (NSString*)shortPathName;
- (NSDictionary*)allPathNamesToPaths;
- (WADLServiceSection*)rootServiceSection;
- (NSString*)className;

@end
