//
//  WADLServerAPI.h
//  wadl2objc
//
//  Created by Sergey Konovorotskiy on 8/4/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import "WADLAbstractServerAPI.h"

@protocol WADLServerAPITokenProvider;


@interface WADLServerAPI : WADLAbstractServerAPI <WADLServerAPIInheritor, WADLServerAPIErrorHandler>

@property (nonatomic, weak) id <WADLServerAPITokenProvider> tokenProvider;

@end


@protocol WADLServerAPITokenProvider <NSObject>

- (NSString*)token;
- (void)proceedLogin:(void(^)(void))completionBlock;

@end
