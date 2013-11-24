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

- (NSOperation*)inventoryStylesSearchAllWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)inventorySchoolsSchoolStSearchByStateWithSchoolSt:(NSString*)schoolSt responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)inventorySchoolsSearchAllWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)inventorySchoolsSchoolCitySchoolCitySearchByStateAndCityWithSchoolCity:(NSString*)schoolCity schoolSt:(NSString*)schoolSt responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)inventorySchoolsSchoolNoFindBySchoolNoWithSchoolNo:(NSNumber*)schoolNo responseBlock:(void(^)(SchoolDto *response, NSError *error))responseBlock;

// Reservation

- (NSOperation*)reservationReservationNoD114StyleCreateStyle:(ReservationStyleDto*)reservationStyleDto responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoD114StyleUpdateStyle:(ReservationStyleDto*)reservationStyleDto responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoStylesFindReservationStylesWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)reservationSequenceStyleSequenceFindReservationStyleWithSequence:(NSNumber*)sequence reservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationStyleDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoLogisticFindLogisticByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationLogisticDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationLogisticUpdateLogistic:(ReservationLogisticDto*)reservationLogisticDto responseBlock:(void(^)(ReservationLogisticDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationSummaryUpdateSummary:(ReservationSummaryDto*)reservationSummaryDto responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationSummaryCreateReservation:(ReservationSummaryDto*)reservationSummaryDto responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoMeasurementFindMeasurementByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationMeasurementDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationMeasurementUpdateMeasurement:(ReservationMeasurementDto*)reservationMeasurementDto responseBlock:(void(^)(ReservationMeasurementDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoSummaryFindSummaryByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationSummaryDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationOffersUpdateOffers:(ReservationOffersDto*)reservationOffersDto responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock;
- (NSOperation*)reservationReservationNoOffersFindOffersByNoWithReservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationOffersDto *response, NSError *error))responseBlock;

// Auth

- (NSOperation*)authUserAuthenticateUser:(AuthUserDto*)authUserDto responseBlock:(void(^)(AuthUserDto *response, NSError *error))responseBlock;

// Rules

- (NSOperation*)rulesEventDateEventDateD4D2D2FindReservationStylesWithEventDate:(NSString*)eventDate responseBlock:(void(^)(EventDatesDto *response, NSError *error))responseBlock;

// ApplicationWadl

- (NSOperation*)applicationWadlGetWadlWithResponseBlock:(void(^)(id response, NSError *error))responseBlock;
- (NSOperation*)applicationWadlPathGeExternalGrammarWithPath:(NSString*)path responseBlock:(void(^)(id response, NSError *error))responseBlock;

#pragma mark -
// end of generated services methods

@end
