//
//  WADLServiceSection.h
//  wadl2objc
//
//  Created by DZhurov on 10/10/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WADLDocument;

@interface WADLServiceSection : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)dictionary wadlDocument:(WADLDocument*)wadlDocument;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary parantSection:(WADLServiceSection*)parantSection;

@property (nonatomic,strong) NSString *path;
@property (nonatomic, weak) WADLDocument *wadlDocument;
@property (nonatomic, weak) WADLServiceSection *parantServiceSection;
/*![WADLServiceSection]*/
@property (nonatomic, strong) NSMutableArray *childSections;
/*![WADLServicePathParameter]*/
@property (nonatomic, strong) NSMutableArray *pathParameters;
/*![WADLServicePathParameter]*/
@property (nonatomic, strong) NSMutableArray *queryParameters;
/*![WADLServicePathParameter]*/
@property (nonatomic, strong) NSMutableArray *headParameters;
/*![WADLService]*/
@property (nonatomic, strong) NSMutableArray *services;

- (NSString*)fullPath;
- (NSArray*)urlPathAndMethods; 
- (NSArray*)allMethods;
- (NSString*)pathName;
- (NSString*)shortPathName;
- (NSDictionary*)allPathNamesToPaths;
- (WADLServiceSection*)rootServiceSection;
@end
