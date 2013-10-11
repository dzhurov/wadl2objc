//
//  ServerInteractionManager.h
//  GroupManager
//
//  Created by Dmitry Zhurov on 14.09.12.
//  Copyright (c) 2012 The Mens Wearhouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import "APIConsts.h"

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
    RequestMethodPUT,
    RequestMethodDELETE
};

typedef void(^ResponseBlock)(id responseObject, NSError *error);

#define kRequestTimeoutInterval     (NSTimeInterval)(10.f)  //sec

@protocol MWAccountManager <NSObject>

- (BOOL)reloginSynchronous:(NSError**)error;
- (NSString*)token:(NSError**)error;

@end

@interface ServerInteractionManager : NSObject

@property (nonatomic, weak) id <MWAccountManager> accountManager;

+ (instancetype)sharedManager;

// Here starts generated services methods. Don't touch it!
#pragma mark - Generated Services

#pragma mark -
// end of generated services methods

@end
