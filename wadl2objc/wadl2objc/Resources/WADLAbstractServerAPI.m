//  WADLAbstractServerAPI.m
//  wadl2objc
//

//! DO NOT MODIFY THIS CLASS !

#import "WADLAbstractServerAPI.h"
<import_services>

@implementation WADLAbstractServerAPI

#pragma mark - Lifecycle

+ (instancetype)sharedServerAPI
{
    static dispatch_once_t once;
    static WADLAbstractServerAPI *sharedInstance;
    dispatch_once(&once, ^{
        NSAssert(self conformsToProtocol:@protocol(WADLServerAPIInheritor)],
                 @"WADLAbstractServerAPI is an abstract class. It must be inherited for use. Inheritor must conform to protocol WADLAbstractServerAPI");
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Generated services

<services_getters>

#pragma mark - Serialization

- (id)deserializeData:(NSData*)data error:(NSError *__autoreleasing *)error
{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

- (NSData*)serializeObject:(id)object error:(NSError *__autoreleasing *)error
{
    return [NSJSONSerialization dataWithJSONObject:object
                                        #ifdef DEBUG
                                           options:NSJSONWritingPrettyPrinted
                                        #else
                                           options:0
                                        #endif
                                             error:error];
}

#pragma mark -

- (NSURL *)baseURLForServicesResource:(WADLServicesResource *)resource
{
    return [NSURL URLWithString:@"<base_url>"];
}

- (NSString *)methodNameForMethod:(WADLRequestMethod)method
{
    switch (method) {
        case WADLRequestMethodGET:      return @"GET";
        case WADLRequestMethodPOST:     return @"POST";
        case WADLRequestMethodPUT:      return @"PUT";
        case WADLRequestMethodDELETE:   return @"DELETE";
        case WADLRequestMethodHEAD:     return @"HEAD";
        default:
            NSAssert(0, @"Method not supported: %ld", (long)method);
    }
    return nil;
}

- (WADLAbstractServerAPI<WADLServerAPIInheritor>*)child
{
    return (WADLAbstractServerAPI<WADLServerAPIInheritor>*)self;
}

@end
