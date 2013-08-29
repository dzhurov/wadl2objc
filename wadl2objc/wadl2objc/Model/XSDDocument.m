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

#define kEnumFormat @"typedef NS_ENUM(NSUInteger, %@) { \n\t  %@ = 1, \n\t  %@ \n};"
#define kCheckForTextFieldFormat @"\tif ([fieldName isEqualToString:@\"%@\"]) return @\"%@\";\n"

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
                    xsdProperty.type = [refObject.name stringByAppendingString:@" *"];
                    xsdProperty.name = refString;
                }
                else{
                    NSLog(@"unexpected reference '%@' of object '%@'", refString, name);
                }
            }
            else if ([typeString hasPrefix:@"xs:"]){
                xsdProperty.type = [classNameForXSDType(typeString) stringByAppendingString:@" *"];
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
                        xsdProperty.type = [refObject.name stringByAppendingString:@" *"];
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
    
    for (XSDObject *object in _objects) {
        [self writeMachineHFileObject:object toPath:path];
        [self writeMachineMFileObject:object toPath:path];
    }
}

// TODO: Implement simple types parser + translators

- (void)writeMachineHFileObject:(XSDObject*)object toPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL needForSimpleTypes = NO;
    NSString *className = [@"_" stringByAppendingString:object.name];
    NSString *fileName = [NSString stringWithFormat:@"%@.h", className];
    NSString *filePath = [[path stringByAppendingPathComponent:kDefaultMachineFolderName] stringByAppendingPathComponent:fileName];
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
        NSString *typeString = property.isCollection ? @"NSArray" : property.type;
        [propertiesList appendFormat:@"\n@property(nonatomic, strong) %@ %@", typeString, property.name];
    }
    
    //Write To File
    NSString *_hFilePath = [@"./Resources" stringByAppendingPathComponent:@"_ExampleEntity_h"];
    NSError *error = nil;
    NSString *_hFileFormat = [NSString stringWithContentsOfFile:_hFilePath encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
    }
    NSString *contentString = [NSString stringWithFormat:_hFileFormat, self.version, includes, className, propertiesList];
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
    NSString *filePath = [[path stringByAppendingPathComponent:kDefaultMachineFolderName] stringByAppendingPathComponent:fileName];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"simpleType == nil AND isCollection == NO", [XSDObjectProperty class]];
    NSArray *fieldsKindOfObjects = [object.properties filteredArrayUsingPredicate:predicate];
    NSArray *fieldsNamesKindOfObjects = [fieldsKindOfObjects valueForKey:@"name"];
    NSMutableString *fieldsNamesStringKindOfObjects = [NSMutableString string];
    for (NSString *field in fieldsNamesKindOfObjects) {
        [fieldsNamesStringKindOfObjects appendFormat:@"@\"%@\", ", field];
    }
        // Simple types
    predicate = [NSPredicate predicateWithFormat:@"simpleType != NIL"];
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
    NSString *_mFilePath = [@"./Resources" stringByAppendingPathComponent:@"_ExampleEntity_m"];
    NSError *error = nil;
    NSString *_mFileFormat = [NSString stringWithContentsOfFile:_mFilePath encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
    }
    NSString *contentString = [NSString stringWithFormat:_mFileFormat, self.version, className, className,fieldsNamesStringKindOfObjects, fieldsNamesStringKindOfObjects, enumsConditionsList, collectionsConditionsList];
    [contentString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
    }
    else{
        NSLog(@"generated: %@", filePath);
    }
    
}


@end
