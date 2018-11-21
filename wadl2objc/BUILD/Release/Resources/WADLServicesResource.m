//  WADLServicesResource.m
//  wadl2objc
//

#import "WADLServicesResource.h"

@interface WADLServicesResource ()

@property (nonatomic, strong) WADLAbstractServerAPI<WADLServerAPIInheritor> *serverAPI;

@end


@implementation WADLServicesResource

- (instancetype)initWithWADLServerAPI:(WADLAbstractServerAPI<WADLServerAPIInheritor> *)serverAPI
{
    self = [super init];
    if (self) {
        self.serverAPI = serverAPI;
    }
    return self;
}

@end
