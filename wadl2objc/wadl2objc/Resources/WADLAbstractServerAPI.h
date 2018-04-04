//  WADLAbstractServerAPI.h
//  wadl2objc
//
//  Created by Dmitry Zhurov (zim01001) on 6/21/15.

//! DO NOT MODIFY THIS CLASS !

#import <Foundation/Foundation.h>
#import "WADLServicesResource.h"
#import "WADLRequestTask.h"

typedef NS_ENUM(NSInteger, WADLRequestMethod) {
    WADLRequestMethodGET,
    WADLRequestMethodPOST,
    WADLRequestMethodPUT,
    WADLRequestMethodDELETE,
    WADLRequestMethodHEAD
};

@protocol WADLServerAPIInheritor <NSObject>
- (WADLRequestTask)makeRequest:(WADLRequestMethod)method
                      resource:(WADLServicesResource*)resource
                    forURLPath:(NSString *)urlPath
               queryParameters:(NSDictionary *)queryParameters
                    bodyObject:(NSDictionary *)parameters
          HTTPHeaderParameters:(NSDictionary *)HTTPHeaderParameters
                   outputClass:(Class)outputClass
                 responseBlock:(void (^)(id, NSError *))responseBlock;

@end


@class WADLMakeRequestInvocation;
@protocol WADLServerAPIErrorHandler <NSObject>
- (BOOL)serverAPI:(WADLAbstractServerAPI*)serverAPI shouldInvokeCompletionBlockWithError:(NSError *)error
                                                                                 request:(NSURLRequest *)request
                                                                                response:(NSURLResponse *)response
                                                               repeatedRequestInvocation:(WADLMakeRequestInvocation *)invocation;

@end

<services_classes_declaration>
@interface WADLAbstractServerAPI : NSObject
{
    @protected
<services_ivars>}

@property (nonatomic, weak) id<WADLServerAPIErrorHandler> errorHanlder;

+ (instancetype)sharedServerAPI;

/***
 * Can be redefined in inheritor to provide different Base URLs for different schemas or targets
 * @retval "base" value in <resources> tag in .wadl file
 */
- (NSURL *)baseURLForServicesResource:(WADLServicesResource *)resource;

- (NSString *)methodNameForMethod:(WADLRequestMethod)method;

/// Deserializes given data to object. Default implementation gets JSON data and deserializes it to NSDictionary or NSArray
- (id)deserializeData:(NSData*)data error:(NSError **)error;

/// Serializes given object to data. Default implementation gets NSDictionary or NSArray and serializes it to JSON data
- (NSData*)serializeObject:(id)object error:(NSError **)error;

#pragma Generated services
<services_definition>

@end


