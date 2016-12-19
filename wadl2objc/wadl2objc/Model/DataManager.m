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

-(void)downloadDataByURLString:(NSString*)urlString completionHandler:(void (^)(NSData *data, NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            ERROR_LOG(@"completed with error :( \n");
        } else {
            SUCCESS_LOG(@"completed successfully :) \n");
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

-(void)prepareXSDDataWithCompletionBlock:(void (^)(NSData *data, NSError *error))completionBlock
{
    if ([[SettingsManager sharedSettingsManager] xsdPath]) {
        NSData *xsdData = [NSData dataWithContentsOfFile:[[SettingsManager sharedSettingsManager] xsdPath]];
        if (completionBlock) {
            completionBlock(xsdData, nil);
        }
    } else {
        printf("Loading XSD file...");
        [self downloadDataByURLString:[[SettingsManager sharedSettingsManager] xsdPURL] completionHandler:completionBlock];
    }
}


-(void)receiveWadlAndXsdDataCompletionBlock:(void (^)(NSData *wadlData, NSData *xsdData, NSError *error))completionBlock
{
    __weak __typeof(self)weakSelf = self;
    
    [self prepareWADLDataWithCompletionBlock:^(NSData *wadlData, NSError *error) {
        
        if (!error) {
            
            [weakSelf prepareXSDDataWithCompletionBlock:^(NSData *xsdData, NSError *err) {
                
                if (error) {
                    if (completionBlock) {
                        completionBlock(nil, nil, err);
                    }
                } else {
                    if (completionBlock) {
                        completionBlock(wadlData, xsdData, err);
                    }
                }
                
            }];
        } else if (completionBlock) {
            completionBlock(nil, nil, error);
        }
    }];
}

@end
