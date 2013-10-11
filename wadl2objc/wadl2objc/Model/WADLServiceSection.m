//
//  WADLServiceSection.m
//  wadl2objc
//
//  Created by DZhurov on 10/10/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "WADLServiceSection.h"
#import "WADLServicePathParameter.h"
#import "XSDTypes.h"
#import "WADLService.h"

#define kSupportedHTTPMethodsArray @[@"GET", @"POST", @"PUT", @"DELTE"]

@implementation WADLServiceSection

synthesizeLazzyProperty(childSections, NSMutableArray);
synthesizeLazzyProperty(pathParameters, NSMutableArray);
synthesizeLazzyProperty(services, NSMutableArray);
synthesizeLazzyProperty(queryParameters, NSMutableArray);

- (id)initWithDictionary:(NSDictionary *)dictionary parantSection:(WADLServiceSection *)parantSection
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
    // Path
    NSString *path = dictionary[@"_path"];
    NSMutableArray *pathComponents = [[path componentsSeparatedByString:@"/"] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.length > 0"];
    [pathComponents filterUsingPredicate:predicate];
    NSArray *params = dictionary[@"param"];
    if ( [params isKindOfClass:[NSDictionary class]] ){
        params = @[params];
    }
    if ( params.count ){
        for (NSDictionary *paramDict in params) {
            WADLServicePathParameter *parameter = [WADLServicePathParameter new];
            parameter.name = paramDict[@"_name"];
            parameter.type = classNameForXSDType( paramDict[@"_type"] );
            NSString *parameterStyle = paramDict[@"_style"];
            if ([parameterStyle isEqualToString:@"query"]){
                [self.queryParameters addObject:parameter];
            }
            else if ([parameterStyle isEqualToString:@"template"]){
                [self.pathParameters addObject:parameter];
                for (int i = 0; i < pathComponents.count; i++) {
                    NSString *onePathComponent = pathComponents[i];
                    NSRange range = [onePathComponent rangeOfString:parameter.name];
                    if ( range.location != NSNotFound ){
                        NSString *regexSeparator = @": ";
                        if ( onePathComponent.length > parameter.name.length + 2/*breckets*/ ){ //has regex
                            NSRange regexRange = NSMakeRange(range.length + range.location + regexSeparator.length, onePathComponent.length - (range.length + range.location + regexSeparator.length) - 1);
                            NSString *regex = [onePathComponent substringWithRange:regexRange];
                            parameter.regex = regex;
                        }
                        [pathComponents replaceObjectAtIndex:i withObject:@"%@"];
                        break;
                    }//if ( range.location != NSNotFound )
                }//for (int i = 0; i < pathComponents.count; i++)
            }
        }//for (NSDictionary *paramDict in params)
    }//else if ([parameterStyle isEqualToString:@"template"])
    self.path = [pathComponents componentsJoinedByString:@"/"];

    // Child sections
    NSArray *subsectionsArray = dictionary[@"resource"];
    if ( [subsectionsArray isKindOfClass:[NSDictionary class]] ){
        subsectionsArray = @[subsectionsArray];
    }
    for (NSDictionary *subsectionDict in subsectionsArray) {
        WADLServiceSection *section = [[WADLServiceSection alloc] initWithDictionary:subsectionDict parantSection:self];
        [self.childSections addObject:section];
    }
    
    // Methods
    NSArray *methodsArray = dictionary[@"method"];
    if ( [methodsArray isKindOfClass:[NSDictionary class]] ){
        methodsArray = @[methodsArray];
    }
    for (NSDictionary *methodDict in methodsArray) {
        NSString *httpMethod = methodDict[@"_name"];
        if ( [kSupportedHTTPMethodsArray containsObject:httpMethod] ){
            WADLService *service = [[WADLService alloc] initWithDictionary:methodDict parantSection:self];
            [self.services addObject:service];
        }
    }
}

- (NSString *)fullPath
{
    NSString *fullPath = self.path;
    if ( self.parantServiceSection ){
        fullPath = [self.parantServiceSection.fullPath stringByAppendingPathComponent:self.path];
    }
    return fullPath;
}

- (NSArray *)allMethods
{
    NSMutableArray *allMethods = [NSMutableArray arrayWithArray:_services];
    for (WADLServiceSection *childSection in _childSections) {
        [allMethods addObjectsFromArray:childSection.allMethods];
    }
    return allMethods;
}

- (NSArray *)urlPathAndMethods
{
    NSMutableArray *allUrlsToMethods = [NSMutableArray array];
    // self methods
    NSDictionary *selfMethods = @{[self fullPath]: _services};
    [allUrlsToMethods addObject:selfMethods];
    for (WADLServiceSection *child in _childSections) {
        NSArray *childUrlsToMethods = [child urlPathAndMethods];
        [allUrlsToMethods addObjectsFromArray:childUrlsToMethods];
    }
    return allUrlsToMethods;
}

-(NSString *)pathName
{
    NSMutableArray *pathComponents = [[_path componentsSeparatedByString:@"/"] mutableCopy];
    int changedPathComponentIndex = 0;
    for (int i = 0; i < pathComponents.count; i++) {
        if ( [pathComponents[i] isEqualToString:@"%@"] ){
            WADLServicePathParameter *parameter = _pathParameters[changedPathComponentIndex];
            [pathComponents replaceObjectAtIndex:i withObject:parameter.name];
        }
        NSString *pathComponent = pathComponents[i];
        pathComponent = [[[pathComponent substringToIndex:1] uppercaseString] stringByAppendingString:[pathComponent substringFromIndex:1]];
        [pathComponents replaceObjectAtIndex:i withObject:pathComponent];
    }
    NSString *pathName = [pathComponents componentsJoinedByString:@""];
    return pathName;
}

- (NSDictionary *)allPathNamesToPaths
{
    NSMutableDictionary *pathNamesToPaths = [NSMutableDictionary dictionaryWithObjectsAndKeys: self.fullPath, self.pathName, nil];
    for (WADLServiceSection *child in _childSections) {
        [pathNamesToPaths addEntriesFromDictionary:[child allPathNamesToPaths]];
    }
    return pathNamesToPaths;
}
@end
