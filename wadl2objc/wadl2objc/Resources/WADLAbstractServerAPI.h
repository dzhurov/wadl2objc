//  WADLAbstractServerAPI.h
//  wadl2objc
//
//  Created by Dmitry Zhurov (zim01001) on 6/21/15.

//! DO NOT MODIFY THIS CLASS !

#import <Foundation/Foundation.h>
#import "WADLServicesResource.h"
#import "WADLRequestTask.h"

typedef NS_ENUM(NSInteger, WADLRequestMethod) {
    WADLRequestMethodGET,
    WADLRequestMethodPOST,
    WADLRequestMethodPUT,
    WADLRequestMethodDELETE,
    WADLRequestMethodHEAD
};

@protocol WADLServerAPIInheritor <NSObject>
- (WADLRequestTask)makeRequest:(WADLRequestMethod)method
                      resource:(WADLServicesResource*)resource
                    forURLPath:(NSString *)urlPath
               queryParameters:(NSDictionary*)queryParameters
                    bodyObject:(NSDictionary*)parameters
          HTTPHeaderParameters:(NSDictionary*)HTTPHeaderParameters
                   outputClass:(Class)outputClass
                 responseBlock:(void (^)(id, NSError *))responseBlock;

@end


@class MakeRequestInvocation;
@protocol WADLServerAPIErrorHandler <NSObject>
- (BOOL)serverAPI:(WADLAbstractServerAPI*)serverAPI shouldInvokeCompletionBlockWithError:(NSError*)error
                                                                                 request:(NSURLRequest*)request
                                                                                response:(NSURLResponse*)response
                                                               repeatedRequestInvocation:(MakeRequestInvocation*)invocation;

@end


@class WADLAuthServices;
@class WADLCustomCartServices;
@class WADLCustomServices;
@class WADLCustomerServices;
@class WADLDashboardPropertiesServices;
@class WADLFeedbackServices;
@class WADLGroupsServices;
@class WADLHubServices;
@class WADLInventoryServices;
@class WADLLogServices;
@class WADLNotificationServices;
@class WADLPosServices;
@class WADLQuestionnaireServices;
@class WADLReceiptsServices;
@class WADLReservationServices;
@class WADLRulesServices;
@class WADLSearchServices;
@class WADLSettingServices;
@class WADLTenderServices;
@class WADLTransactionServices;

@interface WADLAbstractServerAPI : NSObject
{
    @protected
	WADLAuthServices *_auth;
	WADLCustomCartServices *_customCart;
	WADLCustomServices *_custom;
	WADLCustomerServices *_customer;
	WADLDashboardPropertiesServices *_dashboardProperties;
	WADLFeedbackServices *_feedback;
	WADLGroupsServices *_groups;
	WADLHubServices *_hub;
	WADLInventoryServices *_inventory;
	WADLLogServices *_log;
	WADLNotificationServices *_notification;
	WADLPosServices *_pos;
	WADLQuestionnaireServices *_questionnaire;
	WADLReceiptsServices *_receipts;
	WADLReservationServices *_reservation;
	WADLRulesServices *_rules;
	WADLSearchServices *_search;
	WADLSettingServices *_setting;
	WADLTenderServices *_tender;
	WADLTransactionServices *_transaction;
}

@property (nonatomic, weak) id<WADLServerAPIErrorHandler> errorHanlder;

+ (instancetype)sharedServerAPI;

/***
 * Can be redefined in inheritor to provide different Base URLs for different schemas or targets
 * @retval "base" value in <resources> tag in .wadl file
 */
- (NSURL *)baseURLForServicesResource:(WADLServicesResource*)resource;

- (NSString *)methodNameForMethod:(WADLRequestMethod)method;

/*! Deserializes given data to object. Default implementation gets JSON data and deserializes it to NSDictionary or NSArray*/
- (id)deserializeData:(NSData*)data error:(NSError **)error;

/*! Serializes given object to data. Default implementation gets NSDictionary or NSArray and serializes it to JSON data */
- (NSData*)serializeObject:(id)object error:(NSError **)error;

#pragma Generated services
@property (nonatomic, readonly) WADLAuthServices *auth;
+ (WADLAuthServices*) auth;

@property (nonatomic, readonly) WADLCustomCartServices *customCart;
+ (WADLCustomCartServices*) customCart;

@property (nonatomic, readonly) WADLCustomServices *custom;
+ (WADLCustomServices*) custom;

@property (nonatomic, readonly) WADLCustomerServices *customer;
+ (WADLCustomerServices*) customer;

@property (nonatomic, readonly) WADLDashboardPropertiesServices *dashboardProperties;
+ (WADLDashboardPropertiesServices*) dashboardProperties;

@property (nonatomic, readonly) WADLFeedbackServices *feedback;
+ (WADLFeedbackServices*) feedback;

@property (nonatomic, readonly) WADLGroupsServices *groups;
+ (WADLGroupsServices*) groups;

@property (nonatomic, readonly) WADLHubServices *hub;
+ (WADLHubServices*) hub;

@property (nonatomic, readonly) WADLInventoryServices *inventory;
+ (WADLInventoryServices*) inventory;

@property (nonatomic, readonly) WADLLogServices *log;
+ (WADLLogServices*) log;

@property (nonatomic, readonly) WADLNotificationServices *notification;
+ (WADLNotificationServices*) notification;

@property (nonatomic, readonly) WADLPosServices *pos;
+ (WADLPosServices*) pos;

@property (nonatomic, readonly) WADLQuestionnaireServices *questionnaire;
+ (WADLQuestionnaireServices*) questionnaire;

@property (nonatomic, readonly) WADLReceiptsServices *receipts;
+ (WADLReceiptsServices*) receipts;

@property (nonatomic, readonly) WADLReservationServices *reservation;
+ (WADLReservationServices*) reservation;

@property (nonatomic, readonly) WADLRulesServices *rules;
+ (WADLRulesServices*) rules;

@property (nonatomic, readonly) WADLSearchServices *search;
+ (WADLSearchServices*) search;

@property (nonatomic, readonly) WADLSettingServices *setting;
+ (WADLSettingServices*) setting;

@property (nonatomic, readonly) WADLTenderServices *tender;
+ (WADLTenderServices*) tender;

@property (nonatomic, readonly) WADLTransactionServices *transaction;
+ (WADLTransactionServices*) transaction;

@end

