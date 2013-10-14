//
//  WADLService.m
//  wadl2objc
//
//  Created by DZhurov on 10/10/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "WADLService.h"
#import "WADLServiceSection.h"
#import "WADLServicePathParameter.h"

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

- (NSString *)objcMethodName
{
    WADLServiceSection *parantSection = self.parantServiceSection;
    
    BOOL needCapitalize = NO;
    NSMutableString *methodDeclaration = [NSMutableString stringWithFormat:@"- (NSOperation*)%@%@",[parantSection.pathName lowercaseFirstCharacterString], [self.name uppercaseFirstCharacterString]];
    if ( self.requestObjectClass ){
        NSString *parameterName = self.requestObjectClass;
        parameterName = [parameterName lowercaseFirstCharacterString];
        [methodDeclaration appendFormat:@":(%@*)%@ ",self.requestObjectClass, parameterName];
    }
    else{
        [methodDeclaration appendString:@"With"];
        needCapitalize = YES;
    }
    for (NSArray *parameters in @[ [self allPathParameters], [self allQueryParameters] ]) {
        for (WADLServicePathParameter *pathParam in parameters) {
            NSString *methodPart = needCapitalize ? [pathParam.name uppercaseFirstCharacterString] : pathParam.name;
            [methodDeclaration appendFormat:@"%@:(%@*)%@ ", methodPart, pathParam.type, pathParam.name];
            needCapitalize = NO;
        }
    }
    NSString *responseObject = self.responseObjectClass ? [self.responseObjectClass stringByAppendingString:@" *"] : @"id ";
    if (needCapitalize)
        [methodDeclaration appendFormat:@"ResponseBlock:(void(^)(%@response, NSError *error))responseBlock", responseObject];
    else
        [methodDeclaration appendFormat:@"responseBlock:(void(^)(%@response, NSError *error))responseBlock", responseObject];
    
    return methodDeclaration;
}


@end
