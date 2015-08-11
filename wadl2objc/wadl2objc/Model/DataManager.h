//
//  DataManager.h
//  wadl2objc
//
//  Created by Andrey Durbalo on 8/10/15.
//  Copyright (c) 2015 zimCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

@interface DataManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(DataManager);

-(void)receiveWadlAndXsdDataCompletionBlock:(void (^)(NSData *wadlData, NSData *xsdData, NSError *error))completionBlock;

@end
