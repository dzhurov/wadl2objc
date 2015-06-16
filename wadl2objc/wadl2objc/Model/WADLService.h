//
//  WADLService.h
//  wadl2objc
//
//  Created by DZhurov on 10/10/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WADLServiceRepresentation.h"

@class WADLServiceSection;
@interface WADLService : NSObject

- (id)initWithDictionary:(NSDictionary*)dictionary parentSection:(WADLServiceSection*)parantSection;

@property (nonatomic, weak) WADLServiceSection *parentServiceSection;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *method; // GET, PUT, POST, DELETE
@property (nonatomic, strong) WADLServiceRepresentation *requestRepresentation;
@property (nonatomic, strong) WADLServiceRepresentation *responseRepresentation;

- (NSArray *)allQueryParameters;
- (NSArray *)allPathParameters;
- (NSArray *)allHeadParameters;
- (NSString*)fullPath;
- (NSString*)objcMethodName;

@end
