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

#define kRootElementKey             @"xs:schema"
#define kObjectsDescriptionKey      @"xs:complexType"
#define kSimpleTypesKey             @"xs:simpleType"
#define kSimpleTypeRestrictionKey   @"xs:restriction"
#define kObjectSummaryKey           @"xs:element"

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
                }
                else{
                    XSDObject *refObject = xsdObjects[typeString];
                    if (refObject)
                        [xsdObj.dependencies addObject:refObject];
                    else
                        NSLog(@"unexpected property '%@' of object '%@'", typeString, name);
                }
            }
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
        NSString *fileName = [NSString stringWithFormat:@"_%@.h", object];
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        
        [self writeMachineHFileObject:object toPath:filePath];
    }
}

- (void)writeMachineHFileObject:(XSDObject*)object toPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL needForSimpleTypes = NO;
    NSString *className = [@"_" stringByAppendingString:object.name];
    NSString *filePath = path;
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
            [includes appendFormat:@"#include \"%@.h\"\n", ((XSDObject*)dependency).name];
        }
        else if ( [dependency isKindOfClass:[XSDSimpleType class]] )
        {
            needForSimpleTypes = YES;
        }
    }
    if ( needForSimpleTypes )
        [includes appendFormat:@"\n#import \"%@.h\"", kDefaultSimpleTypesFileName];
    // Properties list
    NSMutableString *propertiesList = [NSMutableString string];
    for (XSDObjectProperty *property in object.properties) {
        NSString *typeString = property.isCollection ? @"NSArray" : property.type;
        [propertiesList appendFormat:@"\n@property(nonatomic, strong) %@ *%@", typeString, property.name];
    }
    
    //Write To File
    NSString *_hFilePath = [@"/Users/dzhurov/Development/wadl2objc/wadl2objc/wadl2objc/Resources" stringByAppendingPathComponent:@"_ExampleEntity_h"];
    NSError *error = nil;
    NSString *_hFileFormat = [NSString stringWithContentsOfFile:_hFilePath encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
    }
    NSString *contentString = [NSString stringWithFormat:_hFileFormat, self.version, includes, className, propertiesList];
    [contentString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error: &error];
    if (error){
        NSLog(@"ERROR: %@", error);
    }
}

@end
