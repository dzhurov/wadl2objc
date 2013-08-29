//
//  main.m
//  wadl2objc
//
//  Created by Dmitry on 8/25/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsManager.h"
#import "XSDDocument.h"

void showHelp();

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        if ( argc <= 1 ){
            showHelp();
            return EXIT_SUCCESS;
        }
        NSMutableArray *args = [NSMutableArray arrayWithCapacity:argc];
        for (int i = 0; i < argc; i++) {
            NSString *argument = [NSString stringWithUTF8String:argv[i]];
            [args addObject:argument];
        }
        SettingsManager *settingMgr = [SettingsManager sharedSettingsManager];
        
        if ( ![settingMgr setLaunchArguments:args] ){
            return EXIT_FAILURE;
        }
        
        NSData *xsdData = [NSData dataWithContentsOfFile:settingMgr.xsdPath];
        XSDDocument *xsdDoc = [[XSDDocument alloc] initWithData: xsdData];
        [xsdDoc writeObjectsToPath:settingMgr.outputPath];
        
    }
    return 0;
}


void showHelp()
{
    NSLog(@"Hello, my dear friend!");
    NSLog(@"to use this stuff you have to have .wadl and .xsd files");
    NSLog(@"Run this app with parameters --wadl: <wadl_file_path> --xsd: <xsd_file_path> --output-dir: <output_dir>");
}
