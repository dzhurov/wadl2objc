//
//  WADLServiceSection.h
//  wadl2objc
//
//  Created by DZhurov on 10/10/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WADLServiceSection : NSObject

- (id)initWithDictionary:(NSDictionary*)dictionary parantSection:(WADLServiceSection*)parantSection;

@property (nonatomic,strong) NSString *path;
@property (nonatomic, strong) WADLServiceSection *parantServiceSection;
@property (nonatomic, strong) NSMutableArray/*<WADLServiceSection>*/ *childSections;
@property (nonatomic, strong) NSMutableArray/*<WADLServicePathParameter>*/ *pathParameters;
@property (nonatomic, strong) NSMutableArray/*<WADLServicePathParametes>*/ *queryParameters;
@property (nonatomic, strong) NSMutableArray/*<WADLService>*/ *services;

- (NSString*)fullPath;
- (NSArray*)urlPathAndMethods; 
- (NSArray*)allMethods;
- (NSString*)pathName;
- (NSDictionary*)allPathNamesToPaths;
@end