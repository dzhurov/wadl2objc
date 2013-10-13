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

// Inventory

- (NSOperation*)inventorySearchAllWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)inventorySearchByStateAndCityWithSchoolCity:(NSString*)schoolCity schoolSt:(NSString*)schoolSt responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)inventoryFindBySchoolNoWithSchoolNo:(NSNumber*)schoolNo responseBlock:(void(^)(SchoolDto *response, NSError *error))responseBlock;
- (NSOperation*)inventorySearchByStateWithSchoolSt:(NSString*)schoolSt responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)inventorySearchAllWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;

// Reservation

- (NSOperation*)reservationUpdateLogistic:(ReservationLogisticDto*)reservationLogisticDto responseBlock:(void(^)(ReservationLogisticDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationUpdateMeasurement:(ReservationMeasurementDto*)reservationMeasurementDto responseBlock:(void(^)(ReservationMeasurementDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationUpdateSummary:(ReservationSummaryDto*)reservationSummaryDto responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationCreateReservation:(ReservationSummaryDto*)reservationSummaryDto responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationFindLogisticByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationLogisticDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationFindOffersByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationUpdateOffers:(ReservationOffersDto*)reservationOffersDto responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationFindSummaryByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationFindMeasurementByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationMeasurementDto *response, NSError *error))responseBlock;

// Auth

- (NSOperation*)authAuthenticateUser:(AuthUserDto*)authUserDto responseBlock:(void(^)(AuthUserDto *response, NSError *error))responseBlock;

// ApplicationWadl

- (NSOperation*)applicationWadlGetWadlWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)applicationWadlGeExternalGrammarWithPath:(NSString*)path responseBlock:(void(^)(id response, NSError *error))responseBlock;

#pragma mark -
// end of generated services methods

@end
