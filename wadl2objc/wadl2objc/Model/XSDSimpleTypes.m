//
//  XSDSimpleTypes.m
//  wadl2objc
//
//  Created by DZhurov on 6/15/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import "XSDSimpleTypes.h"
#import "XSDSimpleType.h"
#import "XSDDocument.h"

#define kEnumFormat @"typedef NS_ENUM(NSUInteger, %@) { \n\t%@ = 1, \n%@ \n};"

@interface XSDSimpleTypes()

@property (nonatomic, strong) NSString *currentFormattedDate;
@property (nonatomic, strong) NSString *xsdVersion;

@end

@implementation XSDSimpleTypes

- (instancetype)initWithXSDDocuments:(NSArray *)xsdDocuments
{
    self = [super init];
    if (self) {
        self.simpleTypes = [xsdDocuments valueForKey:@"simpleTypes.@distinctUnionOfArrays.self"];
        self.xsdVersion = [(XSDDocument*)[xsdDocuments firstObject] version];
    }
    return self;
}

- (void)writeObjectsToPath:(NSString*)path
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    self.currentFormattedDate = [dateFormatter stringFromDate:[NSDate date]];

    [self writeSimpleTypes:self.simpleTypes toPath:path];
}

- (void)writeSimpleTypes:(NSArray*)simpleTypes toPath:(NSString*)path
{
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableArray *enumsDeclaration = [NSMutableArray arrayWithCapacity:simpleTypes.count];
    NSMutableString *enumsDictionaries = [NSMutableString string];
    NSMutableString *enumsDictProperties = [NSMutableString string];
    for (XSDSimpleType *oneSimpleType in simpleTypes) {
        
        NSString *firstEnum = [oneSimpleType.name stringByAppendingString:oneSimpleType.options[0]];
        NSMutableString *nextEnums = [NSMutableString string];
        NSMutableString *keyValueString = [NSMutableString string];
        NSMutableString *constStringsDeclaration = [NSMutableString string];
        [constStringsDeclaration appendFormat:@"static NSString *const k%@EnumName = @\"%@\";\n", oneSimpleType.name, oneSimpleType.name];
        [constStringsDeclaration appendFormat:@"static const NSUInteger k%@Count = %lu;\n", oneSimpleType.name, (unsigned long)oneSimpleType.options.count];
        for (int i = 0; i < oneSimpleType.options.count; i++) {
            NSString *enumOptionName = [oneSimpleType.name stringByAppendingString:oneSimpleType.options[i]];
            NSString *stringConstName = [NSString stringWithFormat:@"k%@String", enumOptionName];
            [constStringsDeclaration appendFormat:@"static NSString *const %@ = @\"%@\";\n", stringConstName, oneSimpleType.options[i]];
            [keyValueString appendFormat:@"@(%@) : %@", enumOptionName, stringConstName];
            if (i < oneSimpleType.options.count - 1){
                [keyValueString appendString:@", "];
            }
            if (i == 0)
                continue;
            [nextEnums appendFormat:@"\t%@,\n", enumOptionName];
        }
        [enumsDictProperties appendFormat:@"@property(nonatomic, strong) NSDictionary *%@Dictionary;\n", oneSimpleType.name];
        [enumsDictionaries appendString:[NSString stringWithFormat:@"\t\t_%@Dictionary = @{ %@ };\n",oneSimpleType.name, keyValueString]];
        NSString * oneEnumDecl = [NSString stringWithFormat:kEnumFormat, oneSimpleType.name, firstEnum, nextEnums];
        [enumsDeclaration addObject:oneEnumDecl];
        [enumsDeclaration addObject:constStringsDeclaration];
    }
    // .h File
    NSString *hFileName = [NSString stringWithFormat:@"%@.h", kDefaultEnumManagerClassname];
    NSString *hFilePath = [path  stringByAppendingPathComponent:hFileName];
    NSString *hTemplateFilePath = [@"./Resources" stringByAppendingPathComponent:@"XSDEnums_h"];
    NSError *error = nil;
    NSString *hTemplateFormat = [NSString stringWithContentsOfFile:hTemplateFilePath encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
        return;
    }
    NSString *enumsDeclarationString = [enumsDeclaration componentsJoinedByString:[NSString stringWithFormat:@"\n"]];
    NSString *hContentString = [NSString stringWithFormat:hTemplateFormat, _currentFormattedDate, _xsdVersion, enumsDeclarationString];
    [hContentString writeToFile:hFilePath atomically:YES encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
        return;
    }
    else{
        NSLog(@"generated: %@", hFilePath);
    }
    
    // .m File
    NSString *mFileName = [NSString stringWithFormat:@"%@.m", kDefaultEnumManagerClassname];
    NSString *mFilePath = [path  stringByAppendingPathComponent:mFileName];
    NSString *mTemplateFilePath = [@"./Resources" stringByAppendingPathComponent:@"XSDEnums_m"];
    NSString *mTemplateFormat = [NSString stringWithContentsOfFile:mTemplateFilePath encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
        return;
    }
    NSString *mContentString = [NSString stringWithFormat:mTemplateFormat, _currentFormattedDate, _xsdVersion, enumsDictProperties, enumsDictionaries];
    [mContentString writeToFile:mFilePath atomically:YES encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
        return;
    }
    else{
        NSLog(@"generated: %@", mFilePath);
    }
}

@end
