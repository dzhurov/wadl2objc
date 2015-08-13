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
#import "DataManager.h"

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
        
        [[DataManager sharedDataManager] receiveWadlAndXsdDataCompletionBlock:^(NSData *wadlData, NSData *xsdData, NSError *error) {
           
            if (error) {
                NSLog(@"%@", error);
                exit(EXIT_FAILURE);
            }
            
            XSDDocument *xsdDoc = [[XSDDocument alloc] initWithData: xsdData];
            [xsdDoc writeObjectsToPath:[settingMgr.outputPath stringByAppendingPathComponent:@"XSDObjects"]];
            
            WADLDocument *wadlDoc = [[WADLDocument alloc] initWithData:wadlData];
            wadlDoc.xsdDocument = xsdDoc;
            [wadlDoc writeObjectsToPath:settingMgr.outputPath];
            
            printf("\n\nIMPORTANT! \nDon't forget import Xcode7Macros.h to your project. Take a look here https://gist.github.com/smileyborg/d513754bc1cf41678054");
            exit(EXIT_SUCCESS);
        }];
        
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}


void showHelp()
{
    printf("Hello, my dear friend!\n");
    printf("to use this stuff you have to have .wadl and .xsd files\n");
    printf("Run this app with parameters --wadl: <wadl_file_path> --xsd: <xsd_file_path> --output-dir: <output_dir>\n");
    printf("Or with parameters --wadlURL: <url_to_wadl> --xsdURL: <url_to_xsd> --output-dir: <output_dir>\n");
}
