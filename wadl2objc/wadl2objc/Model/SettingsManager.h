//
//  SettingsManager.h
//  wadl2objc
//
//  Created by Dmitry on 8/26/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

#define kWADLPathArgumentKey    @"--wadl:"
#define kXSDPathArgumentKey     @"--xsd:"
#define kOutputPathArgumentKey  @"--output-dir:"
#define kMappingPlistPathArgumentKey @"--mapping-plist:"

@interface SettingsManager : NSObject
@property (nonatomic, strong) NSString *wadlPath;
@property (nonatomic, strong) NSString *xsdPath;
@property (nonatomic, strong) NSString *outputPath;
@property (nonatomic, strong) NSString *applicationPath;
@property (nonatomic, strong) NSString *mappingPlistPath;
@property (nonatomic, strong) NSDictionary *mapping;

- (NSString*)classNameForObjectType:(NSString*)objectType fromNamespace:(NSString *)namespace;

CWL_DECLARE_SINGLETON_FOR_CLASS(SettingsManager);

- (BOOL)setLaunchArguments:(NSArray*)args;

@end
