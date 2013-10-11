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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //APIConsts
    static NSString *const kApiConstsFile = @"APIConsts.h";
   
    NSString *apiConstsFilePath = [path stringByAppendingPathComponent:kApiConstsFile];
    if ( ![fileManager fileExistsAtPath:apiConstsFilePath] ){
        NSString *apiConstsTemplateFilePath = [@"./Resources" stringByAppendingPathComponent:kApiConstsFile];
        NSError *error = nil;
        [fileManager copyItemAtPath:apiConstsTemplateFilePath toPath:apiConstsFilePath error:&error];
        if (error){
            NSLog(@"ERROR: %@", error);
            return;
        }
    }
    [self writeAPIConstToPath:apiConstsFilePath];
    
    static NSString *const kSIMHeader = @"ServerInteractionManager.h";
    NSString *simFilePath = [path stringByAppendingPathComponent:kSIMHeader];
    if ( ![fileManager fileExistsAtPath:simFilePath]) {
        NSString *simTemplateFilePath = [@"./Resources" stringByAppendingPathComponent:kSIMHeader];
        NSError *error = nil;
        [fileManager copyItemAtPath:simTemplateFilePath toPath:simFilePath error:&error];
        if (error){
            NSLog(@"ERROR: %@", error);
            return;
        }
    }
    [self writeServerInteractionManagerHeaderToPath:simFilePath];
    
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

- (void)writeServerInteractionManagerHeaderToPath:(NSString*)path
{
    NSMutableString * methodsDeclaration = [NSMutableString stringWithCapacity:1024];
    for (WADLServiceSection *rootSection in _wadlServiceSections) {
        [methodsDeclaration appendFormat:@"\n// %@\n", rootSection.pathName];
        NSArray *services = [rootSection allMethods];
        for (WADLService *oneService in services) {
            NSMutableString *oneMethodDeclaration = [NSMutableString stringWithFormat:@"- (NSOperation*)%@%@",rootSection.pathName, oneService.name];
            if ( oneService.requestObjectClass ){
                [oneMethodDeclaration appendFormat:@":(%@*)%@ ",oneService.requestObjectClass, [oneService.requestObjectClass lowercaseString]];
            }
            else{
                [oneMethodDeclaration appendString:@"With"];
            }
            for (WADLServicePathParameter *pathParam in [oneService allPathParameters]) {
                [oneMethodDeclaration appendFormat:@"%@:(%@*)%@ ", pathParam.name, pathParam.type, pathParam.name];
            }
            for (WADLServicePathParameter *pathParam in [oneService allQueryParameters]) {
                [oneMethodDeclaration appendFormat:@"%@:(%@*)%@ ", pathParam.name, pathParam.type, pathParam.name];
            }
            NSString *responseObject = oneService.responseObjectClass ? [oneService.responseObjectClass stringByAppendingString:@" *"] : @"NSObject";

            [oneMethodDeclaration appendFormat:@"responseBlock:(void(^)(%@ *response, NSError *error))responseBlock;\n", responseObject];
            
            [methodsDeclaration appendString: oneMethodDeclaration];
        }
    }
    [self replaceGeneratedContentOfFile:path withString:methodsDeclaration];
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
}

@end
