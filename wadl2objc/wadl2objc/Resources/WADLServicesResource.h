//  WADLServicesResource.h
//  wadl2objc
//
//  Created by Dmitry Zhurov (zim01001) on 6/21/15.

#import <Foundation/Foundation.h>
#import "WADLRequestTask.h"

@class WADLAbstractServerAPI;

@interface WADLServicesResource : NSObject

- (instancetype)initWithWADLServerAPI:(WADLAbstractServerAPI*)serverAPI;

@end
