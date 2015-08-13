//  WADLServicesResource.h
//  wadl2objc
//

#import <Foundation/Foundation.h>
#import "WADLRequestTask.h"

@class WADLAbstractServerAPI;
@protocol WADLServerAPIInheritor;

@interface WADLServicesResource : NSObject

- (instancetype)initWithWADLServerAPI:(WADLAbstractServerAPI<WADLServerAPIInheritor> *)serverAPI;

@property (nonatomic, readonly) WADLAbstractServerAPI<WADLServerAPIInheritor> *serverAPI;

@end
