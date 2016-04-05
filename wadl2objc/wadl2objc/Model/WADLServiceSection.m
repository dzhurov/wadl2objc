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

#define kSupportedHTTPMethodsArray @[@"GET", @"POST", @"PUT", @"DELETE", @"HEAD"]

@implementation WADLServiceSection

synthesizeLazzyProperty(childSections, NSMutableArray);
synthesizeLazzyProperty(pathParameters, NSMutableArray);
synthesizeLazzyProperty(services, NSMutableArray);

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
    
    // Params
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
            
            // template parameters handling
            if ([parameterStyle isEqualToString:@"template"]) {
                [self.pathParameters addObject:parameter];
                for (int i = 0; i < pathComponents.count; i++) {
                    NSString *onePathComponent = pathComponents[i];
                    NSRange range = [onePathComponent rangeOfString:[@"{" stringByAppendingString:parameter.name]];
                    if ( range.location != NSNotFound ){
                        NSString *regexSeparator = @": ";
                        if ( onePathComponent.length > parameter.name.length + 2/*breckets*/ ){ //has regex
                            NSRange regexRange = NSMakeRange(range.length + range.location + regexSeparator.length, onePathComponent.length - (range.length + range.location + regexSeparator.length) - 1);
                            NSString *regex = [onePathComponent substringWithRange:regexRange];
                            parameter.regex = regex;
                        }
                        [pathComponents replaceObjectAtIndex:i withObject:@"%@"];
                        break;
                    }
                }
            }
        }
        [self.pathParameters sortUsingComparator:^NSComparisonResult(WADLServicePathParameter *obj1, WADLServicePathParameter *obj2) {
            return [@([path rangeOfString:obj1.name].location) compare:@([path rangeOfString:obj2.name].location)];
        }];
    }
    
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
    if ( [methodsArray isKindOfClass:[NSDictionary class]] ) {
        methodsArray = @[methodsArray];
    }
    for (NSDictionary *methodDict in methodsArray) {
        NSString *httpMethod = methodDict[@"_name"];
        if ( [kSupportedHTTPMethodsArray containsObject:httpMethod] ) {
            WADLService *service = [[WADLService alloc] initWithDictionary:methodDict parentSection:self];
            [self.services addObject:service];
        }
    }
}

- (void)processDuplicatedMethodNames:(__GENERICS(NSMutableArray, WADLService*)*)allMethods
{
    __GENERICS(NSMutableArray, __GENERICS(NSMutableArray, WADLService*)*) *duplicatedNamesServices = [NSMutableArray new];
    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"overridenName" ascending:YES];
    NSArray *sortedServices = [allMethods sortedArrayUsingDescriptors:@[descriptor]];
    
    WADLService *previousService = nil;
    BOOL subarrayAdded = NO;
    
    for (int i =0; i < sortedServices.count; i++) {
        if ([previousService.overridenName isEqualToString:[sortedServices[i] overridenName]]){
            if ( !subarrayAdded ){
                [duplicatedNamesServices addObject:[NSMutableArray new]];
                [[duplicatedNamesServices lastObject] addObject:previousService];
            }
            [[duplicatedNamesServices lastObject] addObject:sortedServices[i]];
        }
        else{
            previousService = sortedServices[i];
            subarrayAdded = NO;
        }
    }
    
    
    for (NSArray *sameNamesServices in duplicatedNamesServices) {
        int backwardPathLevel = 0;
        do {
            for (WADLService *service in sameNamesServices) {
                NSArray *paths = [service.fullPath componentsSeparatedByString:@"/"];
                NSMutableString *pathsPrefix = [NSMutableString stringWithString:@"_"];
                for (int i = 0; i <= backwardPathLevel; i++) {
                    if (backwardPathLevel > paths.count - 1)
                        break;
                    [pathsPrefix insertString:[paths[paths.count - 1 - i] uppercaseFirstCharacterString] atIndex:0];
                }
                service.overridenName = [[pathsPrefix lowercaseFirstCharacterString] stringByAppendingString: service.name];
            }
            backwardPathLevel ++;
            
                  // This is all names                                    // This is all UNIQUE names
        } while ([[allMethods valueForKeyPath:@"overridenName"] count] > [[allMethods valueForKeyPath:@"@distinctUnionOfObjects.overridenName"] count]);
    }
}

- (NSString *)fullPathWithoutFirstComponent
{
    NSString *fullPath = self.fullPath;
    NSMutableArray *components = [[fullPath componentsSeparatedByString:@"/"] mutableCopy];
    if ( !components.count )
        return fullPath;
    [components removeObjectAtIndex:0];
    return [components componentsJoinedByString:@"/"];
}

- (NSString *)fullPath
{
    NSString *fullPath = self.path;
    if ( self.parantServiceSection ){
        fullPath = [[self.parantServiceSection fullPath] stringByAppendingPathComponent:self.path];
    }
    return fullPath;
}

- (__GENERICS(NSMutableArray, WADLService*) *)allMethods
{
    NSMutableArray *allMethods = [NSMutableArray arrayWithArray:_services];
    for (WADLServiceSection *childSection in _childSections) {
        [allMethods addObjectsFromArray:childSection.allMethods];
    }
    [self processDuplicatedMethodNames:allMethods];
    
    return allMethods;
}

- (__GENERICS(NSArray, NSString*)*)allServicesClasses
{
    __GENERICS(NSArray, NSString*) *responseObjects = [self.allMethods valueForKeyPath:@"responseObjectClass"];
    __GENERICS(NSArray, NSString*) *requestObjects = [self.allMethods valueForKeyPath:@"requestObjectClass"];
    NSMutableSet *set = [NSMutableSet setWithArray:responseObjects];
    [set addObjectsFromArray:requestObjects];
    [set removeObject:[NSNull null]];
    return [[set allObjects] sortedArrayUsingSelector:@selector(compare:)];
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
    NSMutableCharacterSet *separateChars = [[[NSCharacterSet alphanumericCharacterSet] invertedSet] mutableCopy];
    [separateChars removeCharactersInString:@"_%@"];
    NSMutableArray *pathComponents = [[[self fullPath] componentsSeparatedByCharactersInSet:separateChars] mutableCopy];
    int changedPathComponentIndex = 0;
    for (int i = 0; i < pathComponents.count; i++) {
        if ( [pathComponents[i] isEqualToString:@"%@"] ){
            WADLServicePathParameter *parameter = _pathParameters[changedPathComponentIndex];
            [pathComponents replaceObjectAtIndex:i withObject:parameter.name];
            changedPathComponentIndex ++;
        }
        NSString *pathComponent = pathComponents[i];
        pathComponent = [pathComponent uppercaseFirstCharacterString];
        [pathComponents replaceObjectAtIndex:i withObject:pathComponent];
    }
    NSString *pathName = [pathComponents componentsJoinedByString:@""];
    return pathName;
}

-(NSString *)shortPathName
{
    NSMutableCharacterSet *separateChars = [[[NSCharacterSet alphanumericCharacterSet] invertedSet] mutableCopy];
    [separateChars removeCharactersInString:@"_%@"];
    NSMutableArray *pathComponents = [[[self fullPath] componentsSeparatedByCharactersInSet:separateChars] mutableCopy];
    for (int i = 0; i < pathComponents.count; i++) {
        if ( [pathComponents[i] isEqualToString:@"%@"] ){
            [pathComponents replaceObjectAtIndex:i withObject:@""];
        }
        NSString *pathComponent = pathComponents[i];
        pathComponent = [pathComponent uppercaseFirstCharacterString];
        [pathComponents replaceObjectAtIndex:i withObject:pathComponent];
    }
    NSString *pathName = [pathComponents componentsJoinedByString:@""];
    return pathName;
}

- (NSDictionary *)allPathNamesToPaths
{
    NSMutableDictionary *pathNamesToPaths = [NSMutableDictionary dictionaryWithObjectsAndKeys: [self fullPath], [self pathName], nil];
    for (WADLServiceSection *child in _childSections) {
        [pathNamesToPaths addEntriesFromDictionary:[child allPathNamesToPaths]];
    }
    return pathNamesToPaths;
}

- (NSString *)className
{
    [super className];
    return [NSString stringWithFormat:@"WADL%@Services", [[self shortPathName] uppercaseFirstCharacterString]];
}

@end
