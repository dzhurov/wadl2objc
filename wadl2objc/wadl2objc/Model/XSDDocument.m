//
//  XSDDocument.m
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "XSDDocument.h"
#import "TBXML+NSDictionary.h"
#import "XSDObject.h"
#import "XSDObjectProperty.h"
#import "XSDSimpleType.h"
#import "XSDTypes.h"

#define kDefaultMachineFolderName   @"machine"
#define kDefaultSimpleTypesFileName @"XSDSimpleTypes"
#define kDefaultEnumManagerClassname @"XSDEnums"

#define kRootElementKey             @"xs:schema"
#define kObjectsDescriptionKey      @"xs:complexType"
#define kSimpleTypesKey             @"xs:simpleType"
#define kSimpleTypeRestrictionKey   @"xs:restriction"
#define kObjectSummaryKey           @"xs:element"

#define kEnumFormat @"typedef NS_ENUM(NSUInteger, %@) { \n\t%@ = 1, \n%@ \n};"
#define kCheckForTextFieldFormat @"\tif ([fieldName isEqualToString:@\"%@\"]) return @\"%@\";\n"

@interface XSDDocument ()

@property (strong) NSString *currentFormattedDate;

@end

@implementation XSDDocument

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if ( self ){
        NSError *error = nil;
        NSDictionary *xsdDictionary = [TBXML dictionaryWithXMLData:data error: &error];
        NSLog(@"\n\nXSD: \n%@", xsdDictionary);
        
        [self setXSDDictionary:xsdDictionary];
    }
    return self;
}

- (void)setXSDDictionary: (NSDictionary*)dictionary
{
    NSDictionary *dict = dictionary[kRootElementKey];
    self.version = dict[@"version"];
    
    // Simple Types (enums)
    NSArray *simpleTypes = dict[kSimpleTypesKey];
    NSMutableDictionary *xsdSimpleTypes = [NSMutableDictionary dictionaryWithCapacity:simpleTypes.count];
    for (NSDictionary *oneSimpleType in simpleTypes) {
        XSDSimpleType *xsdSimple = [XSDSimpleType new];
        NSString *name = oneSimpleType[@"name"];
        xsdSimple.name = formattedType(name);
        NSDictionary *restriction = oneSimpleType[kSimpleTypeRestrictionKey];
        xsdSimple.baseType = classNameForXSDType(restriction[@"base"]);
        xsdSimple.options = [restriction valueForKeyPath:@"xs:enumeration.value"];
        [xsdSimpleTypes setObject:xsdSimple forKey:name];
    }
    
    //Complex types summary (Objects)
    NSArray *complexTypes = dict[kObjectsDescriptionKey];
    NSMutableDictionary *xsdObjects = [NSMutableDictionary dictionaryWithCapacity:complexTypes.count];
    for (NSDictionary *oneComplexType in complexTypes) {
        NSString *name = oneComplexType[@"name"];
        XSDObject *xsdObj = [XSDObject new];
        xsdObj.name = formattedType(name);
        [xsdObjects setObject:xsdObj forKey:name];
    }
    
    // Complex types details
    complexTypes = dict[kObjectsDescriptionKey];
    for (NSDictionary *oneComplexType in complexTypes) {
        NSString *name = oneComplexType[@"name"];
        XSDObject *xsdObj = xsdObjects[name];
        NSArray *properties = [oneComplexType valueForKeyPath:@"xs:sequence.xs:element"];
        if ( [properties isKindOfClass:[NSDictionary class]] ){
            properties = @[properties]; //singularity of TBXML+NSDictionary
        }
        for (NSDictionary *oneProperty in properties) {
            XSDObjectProperty *xsdProperty = [XSDObjectProperty new];
            NSString *propName = oneProperty[@"name"];
            xsdProperty.name = propName;
            if ( oneProperty[@"maxOccurs"] ){ // is an array
                xsdProperty.isCollection = YES;
            }
            
            NSString *typeString = oneProperty[@"type"];
            if (!typeString){
                NSString *refString = oneProperty[@"ref"];
                XSDObject *refObject = xsdObjects[refString];
                if (refObject){
                    [xsdObj.dependencies addObject:refObject];
                    xsdProperty.type = refObject.name;
                    xsdProperty.name = refString;
                }
                else{
                    NSLog(@"unexpected reference '%@' of object '%@'", refString, name);
                }
            }
            else if ([typeString hasPrefix:@"xs:"]){
                xsdProperty.type = classNameForXSDType(typeString);
            }
            else{
                XSDSimpleType *simpleType = xsdSimpleTypes[typeString];
                if (simpleType){
                    [xsdObj.dependencies addObject:simpleType];
                    xsdProperty.type = simpleType.name;
                    xsdProperty.simpleType = simpleType;
                }
                else{
                    XSDObject *refObject = xsdObjects[typeString];
                    if (refObject){
                        [xsdObj.dependencies addObject:refObject];
                        xsdProperty.type = refObject.name ;
                    }
                    else
                        NSLog(@"unexpected property '%@' of object '%@'", typeString, name);
                }
            }
            [xsdObj.properties addObject:xsdProperty];
        }
    }
    
    self.objects = [xsdObjects allValues];
    self.simpleTypes = [xsdSimpleTypes allValues];
}

#pragma mark - Generationg files

- (void)writeObjectsToPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // machine files
    NSString *machineFilesPath = [path stringByAppendingPathComponent:kDefaultMachineFolderName];
    NSError *error = nil;
    if ( ![fileManager fileExistsAtPath:machineFilesPath] ){
        [fileManager createDirectoryAtPath:machineFilesPath withIntermediateDirectories:YES attributes:nil error: &error];
        if ( error ){
            NSLog(@"Error: %@",error);
            return;
        }
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    self.currentFormattedDate = [dateFormatter stringFromDate:[NSDate date]];
    
    for (XSDObject *object in _objects) {
        [self writeMachineHFileObject:object toPath:machineFilesPath];
        [self writeMachineMFileObject:object toPath:machineFilesPath];
        [self writeHumanFilesForObject:object toPath:path];
        [self writeSimpleTypes:_simpleTypes toPath:path];
    }
}

// TODO: Implement simple types parser + translators

#pragma mark Machine files

- (void)writeMachineHFileObject:(XSDObject*)object toPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL needForSimpleTypes = NO;
    NSString *className = [@"_" stringByAppendingString:object.name];
    NSString *fileName = [NSString stringWithFormat:@"%@.h", className];
    NSString *filePath = [path  stringByAppendingPathComponent:fileName];
    if ( [fileManager fileExistsAtPath:filePath] ){
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error: &error];
        if (error){
            NSLog(@"Error: %@",error);
            return;
        }
    }
    NSMutableString *includes = [NSMutableString string];
    for (NSObject *dependency in object.dependencies) {
        if ( [dependency isKindOfClass: [XSDObject class]] ){
            [includes appendFormat:@"#import \"%@.h\"\n", ((XSDObject*)dependency).name];
        }
        else if ( [dependency isKindOfClass:[XSDSimpleType class]] )
        {
            needForSimpleTypes = YES;
        }
    }
    if ( needForSimpleTypes )
        [includes appendFormat:@"#import \"%@.h\"\n", kDefaultSimpleTypesFileName];
    // Properties list
    NSMutableString *propertiesList = [NSMutableString string];
    for (XSDObjectProperty *property in object.properties) {
        NSString *typeString = nil;
        if (property.isCollection)
            typeString = property.isCollection ? @"NSArray *" : property.type;
        else if (property.simpleType)
            typeString = [property.type stringByAppendingString:@" "];
        else
            typeString = [property.type stringByAppendingString:@" *"];
        
        [propertiesList appendFormat:@"\n@property(nonatomic, strong) %@%@", typeString, property.name];
    }
    
    //Write To File
    NSString *_hFilePath = [@"./Resources" stringByAppendingPathComponent:@"_TemplateEntity_h"];
    NSError *error = nil;
    NSString *_hFileFormat = [NSString stringWithContentsOfFile:_hFilePath encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
    }
    NSString *contentString = [NSString stringWithFormat:_hFileFormat, className, _currentFormattedDate, self.version, includes, className, propertiesList];
    [contentString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
    }
    else{
        NSLog(@"generated: %@", filePath);
    }
}

- (void)writeMachineMFileObject:(XSDObject*)object toPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *className = [@"_" stringByAppendingString:object.name];
    NSString *fileName = [NSString stringWithFormat:@"%@.m", className];
    NSString *filePath = [path  stringByAppendingPathComponent:fileName];
    if ( [fileManager fileExistsAtPath:filePath] ){
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error: &error];
        if (error){
            NSLog(@"Error: %@",error);
            return;
        }
    }
    
    // Mapped properties
        // Complex types
    NSArray *fieldsNamesKindOfObjects = [object.properties valueForKey:@"name"];
    NSMutableString *fieldsNamesStringKindOfObjects = [NSMutableString string];
    for (NSString *field in fieldsNamesKindOfObjects) {
        [fieldsNamesStringKindOfObjects appendFormat:@"@\"%@\", ", field];
    }
    if (fieldsNamesStringKindOfObjects.length > 2) // remove last ", "
        [fieldsNamesStringKindOfObjects deleteCharactersInRange:NSMakeRange(fieldsNamesStringKindOfObjects.length - 2, 2)];
        // Simple types
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"simpleType != NIL"];
    NSArray *simpleTypes = [object.properties filteredArrayUsingPredicate:predicate];
    NSMutableString *enumsConditionsList = [NSMutableString string];
    for (XSDObjectProperty *oneSimpleTypeProperty in simpleTypes) {
        [enumsConditionsList appendFormat:kCheckForTextFieldFormat, oneSimpleTypeProperty.name, oneSimpleTypeProperty.type];
    }
        // Arrays
    predicate = [NSPredicate predicateWithFormat:@"isCollection == YES"];
    NSArray *collectionTypes = [object.properties filteredArrayUsingPredicate:predicate];
    NSMutableString *collectionsConditionsList = [NSMutableString string];
    for (XSDObjectProperty *property in collectionTypes) {
        [collectionsConditionsList appendFormat:kCheckForTextFieldFormat, property.name, property.type];
    }
    
    //Write To File
    NSString *_mFilePath = [@"./Resources" stringByAppendingPathComponent:@"_TemplateEntity_m"];
    NSError *error = nil;
    NSString *_mFileFormat = [NSString stringWithContentsOfFile:_mFilePath encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
    }
    NSString *contentString = [NSString stringWithFormat:_mFileFormat, className, _currentFormattedDate, self.version, className, className,fieldsNamesStringKindOfObjects, enumsConditionsList, collectionsConditionsList];
    [contentString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
    }
    else{
        NSLog(@"generated: %@", filePath);
    }
}

#pragma mark Human files

- (void)writeHumanFilesForObject:(XSDObject*)object toPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *hFileName = [NSString stringWithFormat:@"%@.h", object.name];
    NSString *hFilePath = [path  stringByAppendingPathComponent:hFileName];
    NSString *mFileName = [NSString stringWithFormat:@"%@.m", object.name];
    NSString *mFilePath = [path  stringByAppendingPathComponent:mFileName];
    // .h file
    if ( ![fileManager fileExistsAtPath:hFilePath] ){
        NSString *hTemplateFilePath = [@"./Resources" stringByAppendingPathComponent:@"TemplateEntity_h"];
        NSError *error = nil;
        NSString *hFileFormat = [NSString stringWithContentsOfFile:hTemplateFilePath encoding:NSUTF8StringEncoding error: &error];
        if (error){
            NSLog(@"ERROR: %@", error);
        }
        NSString *contentString = [NSString stringWithFormat: hFileFormat, object.name, _currentFormattedDate, _version, object.name, object.name, object.name];
        [contentString writeToFile:hFilePath atomically:YES encoding:NSUTF8StringEncoding error: &error];
        if (error){
            NSLog(@"ERROR: %@", error);
        }
        else{
            NSLog(@"generated: %@", hFilePath);
        }
    }
    // .m file
    if ( ![fileManager fileExistsAtPath:mFileName] ){
        NSString *mTemplateFilePath = [@"./Resources" stringByAppendingPathComponent:@"TemplateEntity_m"];
        NSError *error = nil;
        NSString *mFileFormat = [NSString stringWithContentsOfFile:mTemplateFilePath encoding:NSUTF8StringEncoding error: &error];
        if (error){
            NSLog(@"ERROR: %@", error);
        }
        NSString *contentString = [NSString stringWithFormat: mFileFormat, object.name, _currentFormattedDate, _version, object.name, object.name, object.name];
        [contentString writeToFile:mFilePath atomically:YES encoding:NSUTF8StringEncoding error: &error];
        if (error){
            NSLog(@"ERROR: %@", error);
        }
        else{
            NSLog(@"generated: %@", mFilePath);
        }
    }
}

#pragma mark Enums

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
    NSString *hContentString = [NSString stringWithFormat:hTemplateFormat, _currentFormattedDate, _version, enumsDeclarationString];
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
    NSString *mContentString = [NSString stringWithFormat:mTemplateFormat, _currentFormattedDate, _version, enumsDictProperties, enumsDictionaries];
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
