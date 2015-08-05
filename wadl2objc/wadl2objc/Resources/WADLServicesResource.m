//  WADLServicesResource.m
//  wadl2objc
//
//  Created by Dmitry Zhurov (zim01001) on 6/21/15.

#import "WADLServicesResource.h"

@interface WADLServicesResource ()

@property (nonatomic, strong) WADLAbstractServerAPI *serverAPI;

@end

@implementation WADLServicesResource

- (instancetype)initWithWADLServerAPI:(WADLAbstractServerAPI *)serverAPI
{
    self = [super init];
    if (self) {
        self.serverAPI = serverAPI;
    }
    return self;
}

@end
