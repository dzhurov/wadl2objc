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

- (id)initWithDictionary:(NSDictionary*)dictionary parentSection:(WADLServiceSection*)parentSection
{
    self = [super init];
    if (self){
        self.parentServiceSection = parentSection;
        [self setDictionary:dictionary];
    }
    return self;
}

- (void)setDictionary:(NSDictionary*)dictionary
{
    self.name = dictionary[@"_id"];
    self.method = dictionary[@"_name"];
    NSDictionary *responseDict = [dictionary dictionaryWithValuesForKeys:@[@"response"]];;
   
    // Handle Multiple response objects depends of
    if (responseDict[@"response"] ){
        self.responseRepresentation = [WADLServiceRepresentation serviceRepresentationWithDictionary:responseDict service:self];
    }
    
    //TODO: replace ns2 with something normal thing
    NSDictionary *requestDict = [dictionary dictionaryWithValuesForKeys:@[@"request"]];
    self.requestRepresentation = [WADLServiceRepresentation serviceRepresentationWithDictionary:requestDict service:self];
}

- (NSArray *)allQueryParameters
{
    NSMutableArray *queryParams = [NSMutableArray array];
    WADLServiceSection *section = self.parentServiceSection;
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
    WADLServiceSection *section = self.parentServiceSection;
    while (section) {
        NSArray *nextParameters = section.pathParameters;
        [pathParams insertObjects:nextParameters atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, nextParameters.count)]];
        section = section.parantServiceSection;
    }
    return pathParams;
}

- (NSArray *)allHeadParameters
{
    NSMutableArray *pathParams = [NSMutableArray array];
    WADLServiceSection *section = self.parentServiceSection;
    while (section) {
        NSArray *nextParameters = section.headParameters;
        [pathParams insertObjects:nextParameters atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, nextParameters.count)]];
        section = section.parantServiceSection;
    }
    return pathParams;
}

- (NSString *)fullPath
{
    NSString *fullPath = [self.parentServiceSection fullPath];
    
    return fullPath;
}

- (NSString *)objcMethodName
{
    WADLServiceSection *parentSection = self.parentServiceSection;
    BOOL needCapitalize = NO;
    NSMutableString *methodDeclaration = [NSMutableString stringWithFormat:@"- (WADLRequestTask)%@",[self.overridenName lowercaseFirstCharacterString]];
    if ( self.requestRepresentation.objcClassName ){
        NSString *parameterName = self.requestRepresentation.xsdType;
        parameterName = [parameterName lowercaseFirstCharacterString];
        [methodDeclaration appendFormat:@":(%@ *)%@ ",self.requestRepresentation.objcClassName, parameterName];
    }
    else{
        [methodDeclaration appendString:@"With"];
        needCapitalize = YES;
    }

    for (NSArray *parameters in @[ [self allPathParameters], [self allQueryParameters], [self allHeadParameters] ]) {
        for (WADLServicePathParameter *pathParam in parameters) {
            NSString *name = [[pathParam.name lowercaseFirstCharacterString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *methodPart = needCapitalize ? [name uppercaseFirstCharacterString] : name;
            [methodDeclaration appendFormat:@"%@:(%@ *)%@ ", methodPart, pathParam.type, name];
            needCapitalize = NO;
        }
    }
    NSString *responseObject = self.responseRepresentation.objcClassName ? [self.responseRepresentation.objcClassName stringByAppendingString:@" *"] : @"id ";
    if (needCapitalize)
        [methodDeclaration appendFormat:@"ResponseBlock:(void(^)(%@response, NSError *error))responseBlock", responseObject];
    else
        [methodDeclaration appendFormat:@"responseBlock:(void(^)(%@response, NSError *error))responseBlock", responseObject];
    
    return methodDeclaration;
}

- (NSString *)overridenName
{
    if ( !_overridenName ){
        _overridenName = self.name;
    }
    return _overridenName;
}

@end
