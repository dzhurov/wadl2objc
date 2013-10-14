//
//  WADLDocument.m
//  wadl2objc
//
//  Created by Dmitry on 9/29/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "WADLDocument.h"
#import "TBXML+NSDictionary.h"
#import "XMLDictionary.h"
#import "WADLServiceSection.h"
#import "WADLService.h"
#import "WADLServicePathParameter.h"

#define kPragmaGeneratedPartMarker @"#pragma mark - Generated Services"
#define kPragmaEndGeneratedPartMarker @"#pragma mark -"

@interface WADLDocument()

@property (nonatomic, strong) NSMutableDictionary *pathToService;

@end

@implementation WADLDocument

synthesizeLazzyProperty(pathToService, NSMutableDictionary);
synthesizeLazzyProperty(wadlServiceSections, NSMutableArray);

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if ( self ){
        NSDictionary *xmlDicti = [NSDictionary dictionaryWithXMLData:data];
        NSLog(@"\n\nWADL: \n%@",xmlDicti);
        
        [self setWADLDictionary:xmlDicti];
    }
    return self;
}

- (void)setWADLDictionary:(NSDictionary *)dictionary
{
    NSArray *parantServiceSectionsDicts = [dictionary valueForKeyPath:@"resources.resource"];
    for (NSDictionary *sectionDict in parantServiceSectionsDicts) {
        WADLServiceSection *section = [[WADLServiceSection alloc] initWithDictionary:sectionDict parantSection:nil];
        [self.wadlServiceSections addObject:section];
    }
}

#pragma mark - Generationg files



- (void)writeObjectsToPath:(NSString *)path
{
    //APIConsts.h
    static NSString *const kApiConstsFile = @"APIConsts.h";
    NSString *apiConstsFilePath = [path stringByAppendingPathComponent:kApiConstsFile];
    [self copyFileFromResourses:kApiConstsFile toPath:path];
    [self writeAPIConstToPath:apiConstsFilePath];

    //ServerInteractionManager.h
    static NSString *const kSIMHeader = @"ServerInteractionManager.h";
    NSString *simHeaderFilePath = [path stringByAppendingPathComponent:kSIMHeader];
    [self copyFileFromResourses:kSIMHeader toPath:path];
    [self writeServerInteractionManagerHeaderFileToPath:simHeaderFilePath];
    
    //ServerInteractionManager.m
    static NSString *const kSIMMethod = @"ServerInteractionManager.m";
    NSString *simMethodFilePath = [path stringByAppendingPathComponent:kSIMMethod];
    [self copyFileFromResourses:kSIMMethod toPath:path];
    [self writeServerInteractionManagerMethodFileToPath:simMethodFilePath];
}

- (void)fillPathToService
{
    for (WADLServiceSection *section in _wadlServiceSections) {
        NSArray *urlsToServices = [section urlPathAndMethods];
        for (NSDictionary *pathToServiceDict in urlsToServices) {
            [self.pathToService addEntriesFromDictionary:pathToServiceDict];
        }
    }
}

- (void)writeServerInteractionManagerHeaderFileToPath:(NSString*)path
{
    NSMutableString * methodsDeclaration = [NSMutableString stringWithCapacity:1024 * 4];
    for (WADLServiceSection *rootSection in _wadlServiceSections) {
        [methodsDeclaration appendFormat:@"\n// %@\n\n", rootSection.pathName];
        NSArray *services = [rootSection allMethods];
        for (WADLService *oneService in services) {
            NSString *oneMethodDeclaration = [[oneService objcMethodName] stringByAppendingFormat:@";\n"];
            [methodsDeclaration appendString: oneMethodDeclaration];
        }
    }
    [self replaceGeneratedContentOfFile:path withString:methodsDeclaration];
}

- (void)writeServerInteractionManagerMethodFileToPath:(NSString*)path
{
    NSMutableString *methodsImplementation = [NSMutableString stringWithCapacity:1024 * 16];
    for (WADLServiceSection *rootSection in _wadlServiceSections) {
        [methodsImplementation appendFormat:@"\n#pragma mark %@\n", rootSection.pathName];
        NSArray *services = [rootSection allMethods];
        for (WADLService *oneService in services) {
            NSMutableString *oneMethodImplementation =[[oneService objcMethodName] mutableCopy];
            
            // need use token
            BOOL needToUseToken = YES;
            NSArray *loginMethodPossibleNames =  @[@"authenticate", @"login"];
            for (NSString *possibleLoginMethodName in loginMethodPossibleNames) {
                NSRange range = [oneMethodImplementation rangeOfString:possibleLoginMethodName options:NSCaseInsensitiveSearch];
                if ( range.location != NSNotFound ){
                    needToUseToken = NO;
                    break;
                }
            }
           
            // path parameters
            NSString *pathConstName = [NSString stringWithFormat:@"kWADLService%@URLPath", [oneService.parantServiceSection pathName]];
            [oneMethodImplementation appendFormat:@"\n{\n\tNSString *thePath = [NSString stringWithFormat: %@", pathConstName];
            NSArray *pathParameters = oneService.allPathParameters;
            for (WADLServicePathParameter *parameter in pathParameters) {
                [oneMethodImplementation appendFormat:@", %@", parameter.name];
            }
            [oneMethodImplementation appendFormat:@"];\n"];
            
            // query/input parameters
            NSArray *queryParametes = oneService.allQueryParameters;
            if ( queryParametes.count ){
                [oneMethodImplementation appendFormat:@"\tNSMutableDictionary *inputParameters = [NSMutableDictionary dictionaryWithCapacity:%lu];\n", (unsigned long)queryParametes.count];
                for (WADLServicePathParameter *parameter in queryParametes) {
                    [oneMethodImplementation appendFormat:@"\t[inputParameters setObject:%@ forKey:@\"%@\"];\n", parameter.name, parameter.name];
                }
            }
            else if (oneService.requestObjectClass){
                [oneMethodImplementation appendFormat:@"\tNSDictionary *inputParameters = [%@ dictionaryInfo];\n", [oneService.requestObjectClass lowercaseFirstCharacterString]];
            }
            else{
                [oneMethodImplementation appendFormat:@"\tNSDictionary *inputParameters = nil;\n"];
            }

            //requestMethod
            NSString *outputClass = oneService.responseObjectClass;
            if (outputClass){
                outputClass = [NSString stringWithFormat:@"[%@ class]", outputClass];
            }
            else{
                outputClass = @"Nil";
            }
            [oneMethodImplementation appendFormat:@"\treturn [self make%@RequestForURLPath:thePath useToken:%@ inputParameters:inputParameters outputClass:%@ responseBlock:responseBlock];\n}\n\n", oneService.method, (needToUseToken?@"YES":@"NO"), outputClass];
            [methodsImplementation appendString:oneMethodImplementation];
        }
    }
    [self replaceGeneratedContentOfFile:path withString:methodsImplementation];

}

- (void)writeAPIConstToPath: (NSString*)path
{
    NSMutableString *definesPaths = [NSMutableString string];
    for (WADLServiceSection *section in _wadlServiceSections) {
        [definesPaths appendFormat:@"\n// %@\n", section.pathName];
        NSDictionary * pathNamesToPaths = [section allPathNamesToPaths];
        for (NSString *onePathName in [pathNamesToPaths allKeys]) {
            [definesPaths appendFormat:@"#define kWADLService%@URLPath @\"%@\"\n", onePathName, pathNamesToPaths[onePathName]];
        }
    }
    [self replaceGeneratedContentOfFile:path withString:definesPaths];
}

- (void)replaceGeneratedContentOfFile:(NSString*)filePath withString:(NSString*)string
{
    string = [NSString stringWithFormat:@"\n%@\n", string];
    
    NSMutableString *contentOfFile = [[NSMutableString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSRange startMarker = [contentOfFile rangeOfString:kPragmaGeneratedPartMarker];
    NSAssert(startMarker.location != NSNotFound, @"\"%@\" marker not found in file: %@", kPragmaGeneratedPartMarker, filePath);
    NSRange searchEndRange = NSMakeRange(startMarker.length + startMarker.location, contentOfFile.length - (startMarker.length + startMarker.location));
    NSRange endMarker = [contentOfFile rangeOfString:kPragmaEndGeneratedPartMarker options:NSCaseInsensitiveSearch range:searchEndRange];
    NSAssert(endMarker.location != NSNotFound, @"\"%@\" marker not found in file: %@", kPragmaEndGeneratedPartMarker, filePath);
    [contentOfFile replaceCharactersInRange:NSMakeRange(startMarker.length + startMarker.location, endMarker.location - (startMarker.length + startMarker.location)) withString:string];
    NSError *error = nil;
    [contentOfFile writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error)
        NSLog(@"ERROR: %@",error);
    
    NSLog(@"generated: %@", filePath);
}

- (void)copyFileFromResourses:(NSString*)fileName toPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *simFilePath = [path stringByAppendingPathComponent:fileName];
    if ( ![fileManager fileExistsAtPath:simFilePath]) {
        NSString *simTemplateFilePath = [@"./Resources" stringByAppendingPathComponent:fileName];
        NSError *error = nil;
        [fileManager copyItemAtPath:simTemplateFilePath toPath:simFilePath error:&error];
        if (error){
            NSLog(@"ERROR: %@", error);
            return;
        }
    }
}

@end
