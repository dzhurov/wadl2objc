//  WADLAbstractServerAPI.h
//  wadl2objc
//
//  Created by Dmitry Zhurov (zim01001) on 6/21/15.

//  DO NOT MODIFY THIS CLASS

#import <Foundation/Foundation.h>
#import "WADLServicesResource.h"
#import "WADLRequestTask.h"

typedef NS_ENUM(NSInteger, WADLRequestMethod) {
    WADLRequestMethodGET,
    WADLRequestMethodPOST,
    WADLRequestMethodPUT,
    WADLRequestMethodDELETE
};

@class WADLAuthService;
@protocol WADLServerAPIInheritor <NSObject>

- (WADLRequestTask)makeRequestWithMethod:(WADLRequestMethod)method
                                resource:(WADLServicesResource*)resource
                                 URLPath:(NSString *)urlPath
                                useToken:(BOOL)useToken
                         inputParameters:(NSDictionary*)parameters
                    HTTPHeaderParameters:(NSDictionary*)HTTPHeaderParameters
                             outputClass:(Class)outputClass
                               isInvoked:(BOOL)isInvoked
                           responseBlock:(void (^)(id, NSError *))responseBlock;

@end

@class MakeRequestInvocation;
@protocol WADLServerAPIErrorHandler <NSObject>

- (BOOL)serverAPI:(WADLAbstractServerAPI*)serverAPI shouldInvokeCompletionBlockWithError:(NSError*)error repeatedRequestInvocation:(MakeRequestInvocation*)invocation;

@end

@interface WADLAbstractServerAPI : NSObject

+ (instancetype)sharedManager;

- (NSURL *)baseURLForServicesResource:(WADLServicesResource*)resource;

// Services
@property (nonatomic, readonly) WADLAuthService *auth;
+ (WADLAuthService*) auth;

@end

@interface MakeRequestInvocation : NSObject
{
    __strong NSInvocation *_invocation;
    
    __strong NSString *_urlPath;
    __strong id _parameters;
    __strong id _HTTPHeaderParameters;
    __strong Class _outputClass;
    __strong void (^_responseBlock)(id, NSError *);
    WADLRequestMethod _requestMethod;
    BOOL _useToken;
}
- (id)initWithTarget:(WADLAbstractServerAPI*)target requestMethod:(WADLRequestMethod)method urlPath:(NSString*)urlPath useToken:(BOOL)useToken parameters:(id)parameters HTTPHeaderParameters:(NSDictionary*)HTTPHeaderParameters outputClass:(Class)outputClass responseBlock:(void (^)(id, NSError *))block;

@end
