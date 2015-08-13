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
#import "XSDObject.h"
#import "NSError+Terminate.h"

#define kPragmaGeneratedPartMarker      @"#pragma mark - Generated Services"
#define kPragmaEndGeneratedPartMarker   @"#pragma mark -"
#define kResourcesFolderPath            @"./Resources"

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
        [self setWADLDictionary:xmlDicti];
    }
    return self;
}

- (void)setWADLDictionary:(NSDictionary *)dictionary
{
    self.baseURLPath = [dictionary valueForKeyPath:@"resources._base"];
    NSArray *parantServiceSectionsDicts = [dictionary valueForKeyPath:@"resources.resource"];
    for (NSDictionary *sectionDict in parantServiceSectionsDicts) {
        WADLServiceSection *section = [[WADLServiceSection alloc] initWithDictionary:sectionDict parantSection:nil];
        [self.wadlServiceSections addObject:section];
    }
}

#pragma mark - Generationg files



- (void)writeObjectsToPath:(NSString *)path
{
    printf("\nGenerate WADL files:\n");
    
    //APIConsts.h
    static NSString *const kApiConstsFile = @"APIConsts.h";
    
    // Copy resources
    NSArray *fileNames = @[kApiConstsFile, @"XSDBaseEntity.h", @"XSDBaseEntity.m", @"XSDTypes.h", @"XSDTypes.m", @"WADLRequestTask.h", @"Xcode7Macros.h"];
    
    for (NSString *fName in fileNames) {
        [self copyFileFromResourses:fName toPath:path];
    }
    
    NSString *apiConstsFilePath = [path stringByAppendingPathComponent:kApiConstsFile];
    [self writeAPIConstToPath:apiConstsFilePath];
    
    // WADLServiceResource inheritors
    for (WADLServiceSection *rootSection in _wadlServiceSections) {
        [self writeServiceSection:rootSection toPath:path];
    }
    // WADLAbstractServerAPI.h & WADLAbstractServerAPI.m
    [self writeAbstractServerAPIToPath:path];

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
        [methodsDeclaration appendFormat:@"\n// %@\n\n", [rootSection shortPathName]];
        NSArray *services = [rootSection allMethods];
        for (WADLService *oneService in services) {
            NSString *oneMethodDeclaration = [[oneService objcMethodName] stringByAppendingFormat:@";\n"];
            [methodsDeclaration appendString: oneMethodDeclaration];
        }
    }
    [self replaceGeneratedContentOfFile:path withString:methodsDeclaration];
    NSError *error = nil;
    NSString *contentOfFile = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error){
        NSLog(@"ERROR: %@", error);
        return;
    }
    NSRange lastImportRange = [contentOfFile rangeOfString:@"#import" options:NSBackwardsSearch];
    NSRange endOfImports = [contentOfFile rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:0 range:NSMakeRange(lastImportRange.location, contentOfFile.length - lastImportRange.location)];
    NSRange allImportsRange = NSMakeRange(0, endOfImports.length + endOfImports.location);
    NSMutableString *importsNeedToAppend = [NSMutableString stringWithCapacity:1024];
    for (XSDObject *object in _xsdDocument.objects) {
        NSString *importObjectString = [NSString stringWithFormat:@"#import \"%@.h\"", object.name];
        if ( [contentOfFile rangeOfString:importObjectString options:0 range:allImportsRange].location == NSNotFound ){
            [importsNeedToAppend appendFormat:@"%@\n", importObjectString];
        }
    }
    contentOfFile = [contentOfFile stringByReplacingCharactersInRange:NSMakeRange(allImportsRange.location + allImportsRange.length, 0) withString:importsNeedToAppend];
    [contentOfFile writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error)
        NSLog(@"ERROR: %@", error);
}

- (void)writeServerInteractionManagerMethodFileToPath:(NSString*)path
{
    NSMutableString *methodsImplementation = [NSMutableString stringWithCapacity:1024 * 16];
    for (WADLServiceSection *rootSection in _wadlServiceSections) {
        [methodsImplementation appendFormat:@"\n#pragma mark %@\n", [rootSection shortPathName]];
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
            NSString *pathConstName = [NSString stringWithFormat:@"kWADLService%@URLPath", [oneService.parentServiceSection pathName]];
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
                    [oneMethodImplementation appendFormat:@"\t[inputParameters setValue:%@ forKey:@\"%@\"];\n", parameter.name, parameter.name];
                }
            }
            else if (oneService.requestObjectClass){
                [oneMethodImplementation appendFormat:@"\tNSDictionary *inputParameters = [%@ dictionaryInfo];\n", [oneService.requestObjectClass lowercaseFirstCharacterString]];
            }
            else{
                [oneMethodImplementation appendFormat:@"\tNSDictionary *inputParameters = nil;\n"];
            }
            
            // head parameters
            NSArray *headParametes = oneService.allHeadParameters;
            if ( headParametes.count ){
                [oneMethodImplementation appendFormat:@"\tNSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithCapacity:%lu];\n", (unsigned long)headParametes.count];
                for (WADLServicePathParameter *parameter in headParametes) {
                    NSString *fixedName = [[parameter.name lowercaseFirstCharacterString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    [oneMethodImplementation appendFormat:@"\t[headParameters setValue:%@ forKey:@\"%@\"];\n", fixedName, parameter.name];
                }
            }
            else {
                [oneMethodImplementation appendFormat:@"\tNSDictionary *headParameters = nil;\n"];
            }
            
            //requestMethod
            NSString *outputClass = oneService.responseObjectClass;
            if (outputClass){
                outputClass = [NSString stringWithFormat:@"[%@ class]", outputClass];
            }
            else{
                outputClass = @"Nil";
            }
            [oneMethodImplementation appendFormat:@"\treturn [self make%@RequestForURLPath:thePath useToken:%@ inputParameters:inputParameters HTTPHeaderParameters:headParameters outputClass:%@ responseBlock:responseBlock];\n}\n\n", oneService.method, (needToUseToken?@"YES":@"NO"), outputClass];
            [methodsImplementation appendString:oneMethodImplementation];
        }
    }
    [self replaceGeneratedContentOfFile:path withString:methodsImplementation];

}

- (void)writeServiceSection:(WADLServiceSection*)serviceSection toPath:(NSString *)path
{
    NSString *className = serviceSection.className;
    NSString *fullPathHPath = [[path stringByAppendingPathComponent:className] stringByAppendingString:@".h"];
    NSString *fullPathMPath = [[path stringByAppendingPathComponent:className] stringByAppendingString:@".m"];
    
// .h file (Header)
    NSMutableString *hContentOfFile = [[NSMutableString alloc] initWithContentsOfFile:[kResourcesFolderPath stringByAppendingPathComponent:@"WADLServiceTemplate.h"]
                                                                      encoding:NSUTF8StringEncoding
                                                                         error:nil];
    // Class name
    [hContentOfFile replaceOccurrencesOfString:@"<service_class_name>" withString:className options:0 range:NSMakeRange(0, hContentOfFile.length)];
    
    ///Declaraction
    NSMutableString * methodsDeclaration = [NSMutableString stringWithCapacity:1024 * 4];
    for (WADLService *oneService in serviceSection.allMethods) {
        NSString *oneMethodDeclaration = [[oneService objcMethodName] stringByAppendingFormat:@";\n"];
        [methodsDeclaration appendString: oneMethodDeclaration];
    }
    [hContentOfFile replaceOccurrencesOfString:@"<methods_declaration>" withString:methodsDeclaration options:0 range:NSMakeRange(0, hContentOfFile.length)];
    
    NSError *error = nil;
    [hContentOfFile writeToFile:fullPathHPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) [error terminate];
    NSLog(@"%@.h generated",className);
    
// .m file
    NSMutableString *mContentOfFile = [[NSMutableString alloc] initWithContentsOfFile:[kResourcesFolderPath stringByAppendingPathComponent:@"WADLServiceTemplate.m"]
                                                                             encoding:NSUTF8StringEncoding
                                                                                error:nil];
    
    // Class name
    [mContentOfFile replaceOccurrencesOfString:@"<service_class_name>" withString:className options:0 range:NSMakeRange(0, mContentOfFile.length)];
    
    // Implementation
    
    NSMutableString *methodsImplementation = [NSMutableString stringWithCapacity:1024 * 16];
    for (WADLService *oneService in serviceSection.allMethods) {
        NSMutableString *oneMethodImplementation =[[oneService objcMethodName] mutableCopy];
        
        // path parameters
        NSString *pathConstName = [NSString stringWithFormat:@"kWADLService%@URLPath", [oneService.parentServiceSection pathName]];
        [oneMethodImplementation appendFormat:@"\n{\n\tNSString *thePath = [NSString stringWithFormat: %@", pathConstName];
        NSArray *pathParameters = oneService.allPathParameters;
        for (WADLServicePathParameter *parameter in pathParameters) {
            [oneMethodImplementation appendFormat:@", %@", parameter.name];
        }
        [oneMethodImplementation appendFormat:@"];\n"];
        
        // query parameters
        NSArray *queryParametes = oneService.allQueryParameters;
        if ( queryParametes.count ){
            [oneMethodImplementation appendFormat:@"\tNSMutableDictionary *queryParmeters = [NSMutableDictionary dictionaryWithCapacity:%lu];\n", (unsigned long)queryParametes.count];
            for (WADLServicePathParameter *parameter in queryParametes) {
                [oneMethodImplementation appendFormat:@"\t[inputParameters setValue:%@ forKey:@\"%@\"];\n", parameter.name, parameter.name];
            }
        }
        else{
            [oneMethodImplementation appendFormat:@"\tNSDictionary *queryParmeters = nil;\n"];
        }
        // Body
        if (oneService.requestObjectClass){
            [oneMethodImplementation appendFormat:@"\tNSDictionary *bodyObject = [%@ dictionaryInfo];\n", [oneService.requestObjectClass lowercaseFirstCharacterString]];
        }
        else{
            [oneMethodImplementation appendFormat:@"\tNSDictionary *bodyObject = nil;\n"];
        }
        
        // head parameters
        NSArray *headParametes = oneService.allHeadParameters;
        if ( headParametes.count ){
            [oneMethodImplementation appendFormat:@"\tNSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithCapacity:%lu];\n", (unsigned long)headParametes.count];
            for (WADLServicePathParameter *parameter in headParametes) {
                NSString *fixedName = [[parameter.name lowercaseFirstCharacterString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                [oneMethodImplementation appendFormat:@"\t[headParameters setValue:%@ forKey:@\"%@\"];\n", fixedName, parameter.name];
            }
        }
        else {
            [oneMethodImplementation appendFormat:@"\tNSDictionary *headParameters = nil;\n"];
        }
        
        //requestMethod
        NSString *outputClass = oneService.responseObjectClass;
        if (outputClass){
            outputClass = [NSString stringWithFormat:@"[%@ class]", outputClass];
        }
        else{
            outputClass = @"Nil";
        }
        
        [oneMethodImplementation appendFormat:@"\treturn [self.serverAPI makeRequest:WADLRequestMethod%@ resource:self forURLPath:thePath queryParameters:queryParmeters bodyObject:bodyObject HTTPHeaderParameters:headParameters outputClass:%@ isInvoked:NO responseBlock:responseBlock];\n}\n\n", oneService.method, outputClass];
        
        [methodsImplementation appendString:oneMethodImplementation];
    }
    [mContentOfFile replaceOccurrencesOfString:@"<methods_implementation>" withString:methodsImplementation options:0 range:NSMakeRange(0, mContentOfFile.length)];
    
    [mContentOfFile writeToFile:fullPathMPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) [error terminate];
    NSLog(@"%@.m generated",className);
}

- (void)writeAbstractServerAPIToPath:(NSString*)path
{
    NSString *const kAbstractAPIClassName = @"WADLAbstractServerAPI";
    NSString *fullHPath = [[path stringByAppendingPathComponent:kAbstractAPIClassName] stringByAppendingString:@".h"];
    NSString *fullMPath = [[path stringByAppendingPathComponent:kAbstractAPIClassName] stringByAppendingString:@".m"];
// .h file
    NSMutableString *hContentOfFile = [[NSMutableString alloc] initWithContentsOfFile:[kResourcesFolderPath stringByAppendingPathComponent:@"WADLAbstractServerAPI.h"]
                                                                             encoding:NSUTF8StringEncoding
                                                                                error:nil];
    
    // Services (ivars, gettes, static accessors)
    NSMutableString *servicesClassesDeclaration = [NSMutableString new];
    NSMutableString *ivarsDeclaration = [NSMutableString new];
    NSMutableString *servicesProperties = [NSMutableString new];
    
    for (WADLServiceSection *rootSection in _wadlServiceSections) {
        [servicesClassesDeclaration appendFormat:@"@class %@;\n", rootSection.className];
        [ivarsDeclaration appendFormat:@"\t%@ *_%@;\n", rootSection.className, [rootSection.shortPathName lowercaseFirstCharacterString]];
        [servicesProperties appendFormat:@"@property (nonatomic, readonly) %@ *%@;\n+ (%@*) %@;\n\n",
          rootSection.className,
          [rootSection.shortPathName lowercaseFirstCharacterString],
          rootSection.className,
          [rootSection.shortPathName lowercaseFirstCharacterString]
        ];
    }
    
    [hContentOfFile replaceOccurrencesOfString:@"<services_classes_declaration>"
                                    withString:servicesClassesDeclaration
                                       options:0
                                         range:NSMakeRange(0, hContentOfFile.length)];
    [hContentOfFile replaceOccurrencesOfString:@"<services_ivars>"
                                    withString:ivarsDeclaration
                                       options:0
                                         range:NSMakeRange(0, hContentOfFile.length)];
    [hContentOfFile replaceOccurrencesOfString:@"<services_definition>"
                                    withString:servicesProperties
                                       options:0
                                         range:NSMakeRange(0, hContentOfFile.length)];
    
    NSError *error = nil;
    [hContentOfFile writeToFile:fullHPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) [error terminate];
    NSLog(@"%@.h generated",kAbstractAPIClassName);
    
// .m file
    NSMutableString *mContentOfFile = [[NSMutableString alloc] initWithContentsOfFile:[kResourcesFolderPath stringByAppendingPathComponent:@"WADLAbstractServerAPI.m"]
                                                                             encoding:NSUTF8StringEncoding
                                                                                error:nil];
    
    NSMutableString *accessorsImplementations = [NSMutableString new];
    for (WADLServiceSection *rootSection in _wadlServiceSections) {
        NSString *propertyName = [rootSection.shortPathName lowercaseFirstCharacterString];
        NSString *propertyClass = rootSection.className;
        // getter
        [accessorsImplementations appendFormat:@"- (%@ *)%@\n{\n\tif ( !_%@) _%@ = [%@ new];\n\treturn _%@;\n}\n\n", propertyClass, propertyName, propertyName, propertyName, propertyClass, propertyName];
        // Static accessor
        [accessorsImplementations appendFormat:@"+ (%@ *)%@ \n{\n\t return [[self sharedServerAPI] %@]; \n}\n\n", propertyClass, propertyName, propertyName];
    }
    
    [mContentOfFile replaceOccurrencesOfString:@"<services_getters>"
                                    withString:accessorsImplementations
                                       options:0 range:NSMakeRange(0, mContentOfFile.length)];
    
    [mContentOfFile writeToFile:fullMPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) [error terminate];
    NSLog(@"%@.m generated",kAbstractAPIClassName);
}

- (void)writeAPIConstToPath: (NSString*)path
{
    NSMutableString *definesPaths = [NSMutableString string];
    for (WADLServiceSection *section in _wadlServiceSections) {
        NSString *pathName = [section pathName];
        [definesPaths appendFormat:@"\n// %@\n", pathName];
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
    else
        printf("%s; ", [[filePath lastPathComponent] UTF8String]);
}

- (void)copyFileFromResourses:(NSString*)fileName toPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *simFilePath = [path stringByAppendingPathComponent:fileName];
    if ( ![fileManager fileExistsAtPath:simFilePath]) {
        NSString *simTemplateFilePath = [kResourcesFolderPath stringByAppendingPathComponent:fileName];
        NSError *error = nil;
        [fileManager copyItemAtPath:simTemplateFilePath toPath:simFilePath error:&error];
        if (error){
            [error terminate];
            return;
        }
    }
}

@end
