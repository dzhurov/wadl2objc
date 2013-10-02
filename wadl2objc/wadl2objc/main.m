//
//  main.m
//  wadl2objc
//
//  Created by Dmitry on 8/25/13.
//  Copyright (c) 2013 zimCo. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "SettingsManager.h"
#import "XSDDocument.h"
#import "WADLDocument.h"

void showHelp();

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
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
        
//        NSData *xsdData = [NSData dataWithContentsOfFile:settingMgr.xsdPath];
//        XSDDocument *xsdDoc = [[XSDDocument alloc] initWithData: xsdData];
//        [xsdDoc writeObjectsToPath:settingMgr.outputPath];
        
        NSData *wadlData = [NSData dataWithContentsOfFile:settingMgr.wadlPath];
        WADLDocument *wadlDoc = [[WADLDocument alloc] initWithData:wadlData];
    }
    return 0;
}


void showHelp()
{
    printf("Hello, my dear friend!\n");
    printf("to use this stuff you have to have .wadl and .xsd files\n");
    printf("Run this app with parameters --wadl: <wadl_file_path> --xsd: <xsd_file_path> --output-dir: <output_dir>\n");
}
