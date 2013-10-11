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
- (NSOperation*)InventorysearchAllWithresponseBlock:(void(^)(NSObject *response, NSError *error))responseBlock;
- (NSOperation*)InventorysearchByStateAndCityWithschoolCity:(NSString*)schoolCity schoolSt:(NSString*)schoolSt responseBlock:(void(^)(NSObject *response, NSError *error))responseBlock;
- (NSOperation*)InventoryfindBySchoolNoWithschoolNo:(NSNumber*)schoolNo responseBlock:(void(^)(SchoolDto * *response, NSError *error))responseBlock;
- (NSOperation*)InventorysearchByStateWithschoolSt:(NSString*)schoolSt responseBlock:(void(^)(NSObject *response, NSError *error))responseBlock;
- (NSOperation*)InventorysearchAllWithresponseBlock:(void(^)(NSObject *response, NSError *error))responseBlock;

// Reservation
- (NSOperation*)ReservationupdateLogistic:(ReservationLogisticDto*)reservationlogisticdto responseBlock:(void(^)(ReservationLogisticDto * *response, NSError *error))responseBlock;
- (NSOperation*)ReservationupdateMeasurement:(ReservationMeasurementDto*)reservationmeasurementdto responseBlock:(void(^)(ReservationMeasurementDto * *response, NSError *error))responseBlock;
- (NSOperation*)ReservationupdateSummary:(ReservationSummaryDto*)reservationsummarydto responseBlock:(void(^)(ReservationSummaryDto * *response, NSError *error))responseBlock;
- (NSOperation*)ReservationcreateReservation:(ReservationSummaryDto*)reservationsummarydto responseBlock:(void(^)(ReservationSummaryDto * *response, NSError *error))responseBlock;
- (NSOperation*)ReservationfindLogisticByNoWithreservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationLogisticDto * *response, NSError *error))responseBlock;
- (NSOperation*)ReservationfindOffersByNoWithreservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationOffersDto * *response, NSError *error))responseBlock;
- (NSOperation*)ReservationupdateOffers:(ReservationOffersDto*)reservationoffersdto responseBlock:(void(^)(ReservationOffersDto * *response, NSError *error))responseBlock;
- (NSOperation*)ReservationfindSummaryByNoWithreservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationSummaryDto * *response, NSError *error))responseBlock;
- (NSOperation*)ReservationfindMeasurementByNoWithreservationNo:(NSString*)reservationNo responseBlock:(void(^)(ReservationMeasurementDto * *response, NSError *error))responseBlock;

// Auth
- (NSOperation*)AuthauthenticateUser:(AuthUserDto*)authuserdto responseBlock:(void(^)(AuthUserDto * *response, NSError *error))responseBlock;

// Application.wadl
- (NSOperation*)Application.wadlgetWadlWithresponseBlock:(void(^)(NSObject *response, NSError *error))responseBlock;
- (NSOperation*)Application.wadlgeExternalGrammarWithpath:(NSString*)path responseBlock:(void(^)(NSObject *response, NSError *error))responseBlock;

#pragma mark -
// end of generated services methods

@end
