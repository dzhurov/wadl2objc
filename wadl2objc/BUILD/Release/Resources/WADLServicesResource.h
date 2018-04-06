//  WADLServicesResource.h
//  wadl2objc
//

#import <Foundation/Foundation.h>
#import "WADLRequestTask.h"

@class WADLAbstractServerAPI;
@protocol WADLServerAPIInheritor;

/**
 @class WADLServicesResource.
 Abstract class. Inheritor is a container for several requests joined by first path component.
 e.g. `WADLAuthServices` will contain all requests started with `/auth/`:
 /auth/user
 /auth/user/validate
 /auth/manager
 etc.
 */
@interface WADLServicesResource : NSObject

- (instancetype)initWithWADLServerAPI:(WADLAbstractServerAPI<WADLServerAPIInheritor> *)serverAPI;

@property (nonatomic, readonly) WADLAbstractServerAPI<WADLServerAPIInheritor> *serverAPI;

@end
