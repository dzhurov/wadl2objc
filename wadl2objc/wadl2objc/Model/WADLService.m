//
//  WADLService.m
//  wadl2objc
//
//  Created by DZhurov on 10/10/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "WADLService.h"
#import "WADLServiceSection.h"

@implementation WADLService

- (id)initWithDictionary:(NSDictionary*)dictionary parantSection:(WADLServiceSection*)parantSection
{
    self = [super init];
    if (self){
        self.parantServiceSection = parantSection;
        [self setDictionary:dictionary];
    }
    return self;
}

- (void)setDictionary:(NSDictionary*)dictionary
{
    self.name = dictionary[@"_id"];
    self.method = dictionary[@"_name"];
    NSDictionary *responseDict = dictionary[@"response"];
    NSDictionary *responseRepDict = responseDict[@"representation"];
    if ( !responseRepDict ){
        responseRepDict = responseDict[@"ns2:representation"];
    }
    if ( [responseRepDict isKindOfClass:[NSArray class]] ){
        NSArray *repArray = (NSArray*)responseRepDict;
        responseRepDict = repArray.count ? repArray[0] : nil;
    }
    NSString *responseElement = responseRepDict[@"_element"];
    
    self.responseObjectClass = responseElement;
    NSString *requestElement = [dictionary valueForKeyPath:@"request.ns2:representation._element"];
    self.requestObjectClass = requestElement;
}

- (NSArray *)allQueryParameters
{
    NSMutableArray *queryParams = [NSMutableArray array];
    WADLServiceSection *section = self.parantServiceSection;
    while (section) {
        NSArray *nextParameters = section.queryParameters;
        [queryParams insertObjects:nextParameters atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, nextParameters.count)]];
        section = section.parantServiceSection;
    }
    return queryParams;
}

- (NSArray *)allPathParameters
{
    NSMutableArray *pathParams = [NSMutableArray array];
    WADLServiceSection *section = self.parantServiceSection;
    while (section) {
        NSArray *nextParameters = section.pathParameters;
        [pathParams insertObjects:nextParameters atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, nextParameters.count)]];
        section = section.parantServiceSection;
    }
    return pathParams;
}

- (NSString *)fullPath
{
    NSString *fullPath = self.parantServiceSection.fullPath;
    
    return fullPath;
}

@end
