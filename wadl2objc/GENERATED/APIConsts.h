//
//  APIConsts.h
//
//  Created by wadl2objc
//

#ifndef wadl2objc_APIConsts_h
#define wadl2objc_APIConsts_h

#pragma mark - Generated Services

// Inventory
#define kWADLServiceInventorySchoolsSchoolStURLPath @"inventory/schools/%@"
#define kWADLServiceInventoryURLPath @"inventory"
#define kWADLServiceInventorySchoolsURLPath @"inventory/schools"
#define kWADLServiceInventorySchoolsSchoolCitySchoolCityURLPath @"inventory/schools/%@/%@"
#define kWADLServiceInventorySchoolsSchoolNoURLPath @"inventory/schools/%@"
#define kWADLServiceInventoryStylesURLPath @"inventory/styles"

// Reservation
#define kWADLServiceReservationMeasurementURLPath @"reservation/measurement"
#define kWADLServiceReservationReservationNoURLPath @"reservation/%@"
#define kWADLServiceReservationURLPath @"reservation"
#define kWADLServiceReservationReservationNoLogisticURLPath @"reservation/%@/logistic"
#define kWADLServiceReservationOffersURLPath @"reservation/offers"
#define kWADLServiceReservationSequenceStyleSequenceURLPath @"reservation/%@/style/%@"
#define kWADLServiceReservationSummaryURLPath @"reservation/summary"
#define kWADLServiceReservationReservationNoOffersURLPath @"reservation/%@/offers"
#define kWADLServiceReservationReservationNoMeasurementURLPath @"reservation/%@/measurement"
#define kWADLServiceReservationReservationNoD114StyleURLPath @"reservation/{reservationNo: \d{1,14}}/style"
#define kWADLServiceReservationLogisticURLPath @"reservation/logistic"
#define kWADLServiceReservationReservationNoStylesURLPath @"reservation/%@/styles"
#define kWADLServiceReservationReservationNoSummaryURLPath @"reservation/%@/summary"

// Auth
#define kWADLServiceAuthUserURLPath @"auth/user"
#define kWADLServiceAuthURLPath @"auth"

// Rules
#define kWADLServiceRulesURLPath @"rules"
#define kWADLServiceRulesEventDateEventDateD4D2D2URLPath @"rules/%@/{eventDate: \d{4}-\d{2}-\d{2}}"

// ApplicationWadl
#define kWADLServiceApplicationWadlPathURLPath @"application.wadl/%@"
#define kWADLServiceApplicationWadlURLPath @"application.wadl"

#pragma mark -

#endif
