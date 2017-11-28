//
//  SettingsManager.h
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import "XSDNamespase.h"

#define kWADLPathArgumentKey    @"--wadl:"
#define kXSDPathArgumentKey     @"--xsd:"
#define kWADLURLArgumentKey    @"--wadlURL:"
#define kXSDURLArgumentKey     @"--xsdURL:"
#define kOutputPathArgumentKey  @"--output-dir:"
#define kMappingPlistPathArgumentKey @"--mapping-plist:"

@interface SettingsManager : NSObject
@property (nonatomic, strong) NSString *wadlPath;
@property (nonatomic, strong) NSArray *xsdPaths;
@property (nonatomic, strong) NSString *wadlURL;
@property (nonatomic, strong) NSString *xsdPURL;
@property (nonatomic, strong) NSString *outputPath;
@property (nonatomic, strong) NSString *applicationPath;
@property (nonatomic, strong) NSString *mappingPlistPath;
@property (nonatomic, strong) NSDictionary *mapping;
/*! mapping from xsd fileds to objc fields */
@property (nonatomic, readonly) NSDictionary<NSString*, NSString*> *xsdToObjcFieldsMapping;

- (XSDNamespase*)namespaceForIdentifier:(NSString*)identifier;
- (NSString*)classNameForObjectType:(NSString*)objectType fromNamespace:(NSString *)namespace;

CWL_DECLARE_SINGLETON_FOR_CLASS(SettingsManager);

- (BOOL)setLaunchArguments:(NSArray*)args;

@end
