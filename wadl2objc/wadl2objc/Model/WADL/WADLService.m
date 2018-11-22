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
#import "XSDTypes.h"

@implementation WADLService

synthesizeLazzyProperty(queryParameters, NSMutableArray);
synthesizeLazzyProperty(headParameters, NSMutableArray);

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

    NSDictionary *request = dictionary[@"request"];
    NSArray *params = request[@"param"];
    if ( [params isKindOfClass:[NSDictionary class]] ) {
        params = @[params];
    }
    if ( params.count ) {
        for (NSDictionary *paramDict in params) {
            WADLServicePathParameter *parameter = [WADLServicePathParameter new];
            parameter.name = paramDict[@"_name"];
            parameter.type = classNameForXSDType( paramDict[@"_type"] );
            NSString *parameterStyle = paramDict[@"_style"];
            
            // query and header parameters handling
            if ([parameterStyle isEqualToString:@"query"]) {
                parameter.type = classNameForXSDType(kXSDString);
                [self.queryParameters addObject:parameter];
            }
            else if ([parameterStyle isEqualToString:@"header"]) {
                [self.headParameters addObject:parameter];
            }
        }
    }
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

- (NSString *)fullPath
{
    NSString *fullPath = [self.parentServiceSection fullPath];
    
    return fullPath;
}

- (NSString *)objcMethodName
{
    BOOL needCapitalize = NO;
    NSMutableString *methodDeclaration = [NSMutableString stringWithFormat:@"- (WADLRequestTask)%@",[self.overridenName lowercaseFirstCharacterString]];
    if ( self.requestObjectClass ){
        NSString *parameterName = self.requestObjectClass;
        parameterName = [parameterName lowercaseFirstCharacterString];
        [methodDeclaration appendFormat:@":(%@ *)%@ ",self.requestObjectClass, parameterName];
    }
    else{
        [methodDeclaration appendString:@"With"];
        needCapitalize = YES;
    }
    for (NSArray *parameters in @[ [self allPathParameters], self.queryParameters, self.headParameters ]) {
        for (WADLServicePathParameter *pathParam in parameters) {
            NSString *name = [[pathParam.name lowercaseFirstCharacterString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *methodPart = needCapitalize ? [name uppercaseFirstCharacterString] : name;
            [methodDeclaration appendFormat:@"%@:(%@ *)%@ ", methodPart, pathParam.type, name];
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

- (NSString *)objcSelector
{
    NSString *methodName = [self objcMethodName];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"[\\da-zA-Z_]+:" options:0 error:nil];
    NSMutableString *resultString = [NSMutableString new];
    [regex enumerateMatchesInString:methodName options:0 range:NSMakeRange(0, methodName.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [resultString appendString:[methodName substringWithRange:result.range]];
    }];
    return [resultString copy];
}

- (NSString *)overridenName
{
    if ( !_overridenName ){
        _overridenName = self.name;
    }
    return _overridenName;
}

@end
