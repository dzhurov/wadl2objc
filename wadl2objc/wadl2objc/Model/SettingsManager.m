//
//  SettingsManager.m
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import "SettingsManager.h"

@implementation SettingsManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(SettingsManager);

- (NSString *)argsArray:(NSMutableArray*)argsArray popArgumentForKey:(NSString*)argumentKey
{
    NSUInteger index = [argsArray indexOfObject:argumentKey];
    if (index == NSNotFound){
        NSLog(@"Missing parameter: %@ ", argumentKey);
        return nil;
    }
    NSString *result = argsArray[index + 1];
    [argsArray removeObjectAtIndex:index];
    [argsArray removeObjectAtIndex:index];
    return result;
}

- (BOOL)setLaunchArguments:(NSArray *)args
{
    NSMutableArray *argsArray = [NSMutableArray arrayWithArray:args];
    
    self.applicationPath = argsArray[0];
    [argsArray removeObjectAtIndex:0];
    self.wadlPath = [self argsArray:argsArray popArgumentForKey:kWADLPathArgumentKey];
    self.xsdPath = [self argsArray:argsArray popArgumentForKey:kXSDPathArgumentKey];
    self.outputPath = [self argsArray:argsArray popArgumentForKey:kOutputPathArgumentKey];
    
    // Mapping
    self.mappingPlistPath = [self argsArray:argsArray popArgumentForKey:kMappingPlistPathArgumentKey];
    if (self.mappingPlistPath){
        NSError *plistError;
        NSPropertyListFormat format;
        NSData *plistData = [NSData dataWithContentsOfFile: self.mappingPlistPath];
        if (plistData){
            self.mapping = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&format error:&plistError];
            if (plistError){
                NSLog(@"ERROR: %@", plistError);
            }
        }
        else{
            NSLog(@"WARNING: --mapping-plist: %@ - No such file", self.mappingPlistPath);
        }
    }
    
    if ( argsArray.count ){
        NSLog(@"Unexpected parameters: %@", argsArray);
        return NO;
    }
    
    if (_wadlPath && _xsdPath && _outputPath){
        return YES;
    }
    
    return NO;
}

- (NSString *)classNameForObjectType:(NSString *)objectType fromNamespace:(NSString *)namespace
{
    NSDictionary *namespaceDescription = self.mapping[namespace];
    if (namespaceDescription){
        NSString *className = [NSString stringWithFormat:@"%@%@%@", safeString(namespaceDescription[@"prefix"]), objectType, safeString(namespaceDescription[@"suffix"]) ];
        return className;
    }
    else{
        NSLog(@"WARNING: There is no description for targetNamespace: %@. Please, provide name and prefix or suffix for current namespace in %@", namespace, self.mappingPlistPath);
        NSMutableDictionary *newMapping = [self.mapping mutableCopy];
        newMapping[namespace] = @{@"prefix" : @"",
                                  @"suffix" : @"",
                                  @"name"   : @""};
        NSString *errorDescription = nil;
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:newMapping
                                                                       format:NSPropertyListXMLFormat_v1_0
                                                             errorDescription:&errorDescription];
        if (errorDescription){
            NSLog(@"ERROR: Cannot add namespase to mapping.plist\nDescription: %@", errorDescription);
        }
        else{
            NSError *error = nil;
            if ([plistData writeToFile:self.mappingPlistPath options:0 error:&error]){
                self.mapping = newMapping;
            }
            else{
                NSLog(@"ERROR: %@", error);
            }
        }
    }
    return objectType;
}

@end
