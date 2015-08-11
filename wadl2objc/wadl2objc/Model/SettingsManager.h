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
#define kWADLURLArgumentKey    @"--wadlURL:"
#define kXSDURLArgumentKey     @"--xsdURL:"
#define kOutputPathArgumentKey  @"--output-dir:"

@interface SettingsManager : NSObject
@property (nonatomic, strong) NSString *wadlPath;
@property (nonatomic, strong) NSString *xsdPath;
@property (nonatomic, strong) NSString *wadlURL;
@property (nonatomic, strong) NSString *xsdPURL;
@property (nonatomic, strong) NSString *outputPath;
@property (nonatomic, strong) NSString *applicationPath;

CWL_DECLARE_SINGLETON_FOR_CLASS(SettingsManager);

- (BOOL)setLaunchArguments:(NSArray*)args;

@end
