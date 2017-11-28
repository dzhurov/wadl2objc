//
//  DataManager.m
//  wadl2objc
//
//  Created by Andrey Durbalo on 8/10/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import "DataManager.h"
#import "SettingsManager.h"

@interface DataManager ()
@end

@implementation DataManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(DataManager);

-(void)writeLoadingDotsInLog:(NSTimer*)sender
{
    printf(".");
}

-(void)downloadDataByURLString:(NSString*)urlString completionHandler:(void (^)(NSData *data, NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            printf("completed with error :( \n");
        } else {
            printf("completed successfully :) \n");
        }
        
        if (completionHandler) {
            completionHandler(data, error);
        }
        
    }];
    [dataTask resume];
}


-(void)prepareWADLDataWithCompletionBlock:(void (^)(NSData *data, NSError *error))completionBlock
{
    if ([[SettingsManager sharedSettingsManager] wadlPath]) {
        NSData *wadlData = [NSData dataWithContentsOfFile:[[SettingsManager sharedSettingsManager] wadlPath]];
        if (completionBlock) {
            completionBlock(wadlData, nil);
        }
    } else {
        printf("Loading WADL file...");
        [self downloadDataByURLString:[[SettingsManager sharedSettingsManager] wadlURL] completionHandler:completionBlock];
    }
}

-(void)prepareXSDDataWithCompletionBlock:(void (^)(NSArray<NSData*> *xsdDataArray, NSError *error))completionBlock
{
    if ([[SettingsManager sharedSettingsManager] xsdPaths]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[[SettingsManager sharedSettingsManager] xsdPaths].count];
        for (NSString *path in [[SettingsManager sharedSettingsManager] xsdPaths]) {
            NSData *xsdData = [NSData dataWithContentsOfFile:path];
            if ( !xsdData ){
                NSLog(@"File: %@ doesn't exist", path);
                exit(EXIT_FAILURE);
            }
            [array addObject:xsdData];
        }
        if (completionBlock) {
            completionBlock(array, nil);
        }
    } else {
        printf("Loading XSD file...");
        [self downloadDataByURLString:[[SettingsManager sharedSettingsManager] xsdPURL] completionHandler:^(NSData *data, NSError *error) {
            completionBlock([NSArray arrayWithObjects:data, nil], error);
        }];
    }
}


-(void)receiveWadlAndXsdDataCompletionBlock:(void (^)(NSData *wadlData, NSArray<NSData*> *xsdDataArray, NSError *error))completionBlock
{
    __weak __typeof(self)weakSelf = self;
    
    [self prepareWADLDataWithCompletionBlock:^(NSData *wadlData, NSError *error) {
        
        if (!error) {
            
            [weakSelf prepareXSDDataWithCompletionBlock:^(NSArray<NSData*> *xsdDataArray, NSError *err) {
                if (completionBlock) {
                    completionBlock(wadlData, xsdDataArray, err);
                }
            }];
        } else if (completionBlock) {
            completionBlock(nil, nil, error);
        }
    }];
}

@end
