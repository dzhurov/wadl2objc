//  WADLAbstractServerAPI.m
//  wadl2objc
//

//! DO NOT MODIFY THIS CLASS !

#import "WADLAbstractServerAPI.h"
#import "WADLAuthServices.h"
#import "WADLCustomCartServices.h"
#import "WADLCustomServices.h"
#import "WADLCustomerServices.h"
#import "WADLDashboardPropertiesServices.h"
#import "WADLFeedbackServices.h"
#import "WADLGroupsServices.h"
#import "WADLHubServices.h"
#import "WADLInventoryServices.h"
#import "WADLLogServices.h"
#import "WADLNotificationServices.h"
#import "WADLPosServices.h"
#import "WADLQuestionnaireServices.h"
#import "WADLReceiptsServices.h"
#import "WADLReservationServices.h"
#import "WADLRulesServices.h"
#import "WADLSearchServices.h"
#import "WADLSettingServices.h"
#import "WADLTenderServices.h"
#import "WADLTransactionServices.h"


@implementation WADLAbstractServerAPI

#pragma mark - Lifecycle

+ (instancetype)sharedServerAPI
{
    static dispatch_once_t once;
    static WADLAbstractServerAPI *sharedInstance;
    dispatch_once(&once, ^{
        NSAssert([self conformsToProtocol:@protocol(WADLServerAPIInheritor)],
                 @"WADLAbstractServerAPI is an abstract class. It must be inherited for use. Inheritor must conform to protocol WADLAbstractServerAPI");
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Generated services

- (WADLAuthServices *)auth
{
	if ( !_auth) _auth = [[WADLAuthServices alloc] initWithWADLServerAPI:self.child];
	return _auth;
}

+ (WADLAuthServices *)auth 
{
	 return [[self sharedServerAPI] auth]; 
}

- (WADLCustomCartServices *)customCart
{
	if ( !_customCart) _customCart = [[WADLCustomCartServices alloc] initWithWADLServerAPI:self.child];
	return _customCart;
}

+ (WADLCustomCartServices *)customCart 
{
	 return [[self sharedServerAPI] customCart]; 
}

- (WADLCustomServices *)custom
{
	if ( !_custom) _custom = [[WADLCustomServices alloc] initWithWADLServerAPI:self.child];
	return _custom;
}

+ (WADLCustomServices *)custom 
{
	 return [[self sharedServerAPI] custom]; 
}

- (WADLCustomerServices *)customer
{
	if ( !_customer) _customer = [[WADLCustomerServices alloc] initWithWADLServerAPI:self.child];
	return _customer;
}

+ (WADLCustomerServices *)customer 
{
	 return [[self sharedServerAPI] customer]; 
}

- (WADLDashboardPropertiesServices *)dashboardProperties
{
	if ( !_dashboardProperties) _dashboardProperties = [[WADLDashboardPropertiesServices alloc] initWithWADLServerAPI:self.child];
	return _dashboardProperties;
}

+ (WADLDashboardPropertiesServices *)dashboardProperties 
{
	 return [[self sharedServerAPI] dashboardProperties]; 
}

- (WADLFeedbackServices *)feedback
{
	if ( !_feedback) _feedback = [[WADLFeedbackServices alloc] initWithWADLServerAPI:self.child];
	return _feedback;
}

+ (WADLFeedbackServices *)feedback 
{
	 return [[self sharedServerAPI] feedback]; 
}

- (WADLGroupsServices *)groups
{
	if ( !_groups) _groups = [[WADLGroupsServices alloc] initWithWADLServerAPI:self.child];
	return _groups;
}

+ (WADLGroupsServices *)groups 
{
	 return [[self sharedServerAPI] groups]; 
}

- (WADLHubServices *)hub
{
	if ( !_hub) _hub = [[WADLHubServices alloc] initWithWADLServerAPI:self.child];
	return _hub;
}

+ (WADLHubServices *)hub 
{
	 return [[self sharedServerAPI] hub]; 
}

- (WADLInventoryServices *)inventory
{
	if ( !_inventory) _inventory = [[WADLInventoryServices alloc] initWithWADLServerAPI:self.child];
	return _inventory;
}

+ (WADLInventoryServices *)inventory 
{
	 return [[self sharedServerAPI] inventory]; 
}

- (WADLLogServices *)log
{
	if ( !_log) _log = [[WADLLogServices alloc] initWithWADLServerAPI:self.child];
	return _log;
}

+ (WADLLogServices *)log 
{
	 return [[self sharedServerAPI] log]; 
}

- (WADLNotificationServices *)notification
{
	if ( !_notification) _notification = [[WADLNotificationServices alloc] initWithWADLServerAPI:self.child];
	return _notification;
}

+ (WADLNotificationServices *)notification 
{
	 return [[self sharedServerAPI] notification]; 
}

- (WADLPosServices *)pos
{
	if ( !_pos) _pos = [[WADLPosServices alloc] initWithWADLServerAPI:self.child];
	return _pos;
}

+ (WADLPosServices *)pos 
{
	 return [[self sharedServerAPI] pos]; 
}

- (WADLQuestionnaireServices *)questionnaire
{
	if ( !_questionnaire) _questionnaire = [[WADLQuestionnaireServices alloc] initWithWADLServerAPI:self.child];
	return _questionnaire;
}

+ (WADLQuestionnaireServices *)questionnaire 
{
	 return [[self sharedServerAPI] questionnaire]; 
}

- (WADLReceiptsServices *)receipts
{
	if ( !_receipts) _receipts = [[WADLReceiptsServices alloc] initWithWADLServerAPI:self.child];
	return _receipts;
}

+ (WADLReceiptsServices *)receipts 
{
	 return [[self sharedServerAPI] receipts]; 
}

- (WADLReservationServices *)reservation
{
	if ( !_reservation) _reservation = [[WADLReservationServices alloc] initWithWADLServerAPI:self.child];
	return _reservation;
}

+ (WADLReservationServices *)reservation 
{
	 return [[self sharedServerAPI] reservation]; 
}

- (WADLRulesServices *)rules
{
	if ( !_rules) _rules = [[WADLRulesServices alloc] initWithWADLServerAPI:self.child];
	return _rules;
}

+ (WADLRulesServices *)rules 
{
	 return [[self sharedServerAPI] rules]; 
}

- (WADLSearchServices *)search
{
	if ( !_search) _search = [[WADLSearchServices alloc] initWithWADLServerAPI:self.child];
	return _search;
}

+ (WADLSearchServices *)search 
{
	 return [[self sharedServerAPI] search]; 
}

- (WADLSettingServices *)setting
{
	if ( !_setting) _setting = [[WADLSettingServices alloc] initWithWADLServerAPI:self.child];
	return _setting;
}

+ (WADLSettingServices *)setting 
{
	 return [[self sharedServerAPI] setting]; 
}

- (WADLTenderServices *)tender
{
	if ( !_tender) _tender = [[WADLTenderServices alloc] initWithWADLServerAPI:self.child];
	return _tender;
}

+ (WADLTenderServices *)tender 
{
	 return [[self sharedServerAPI] tender]; 
}

- (WADLTransactionServices *)transaction
{
	if ( !_transaction) _transaction = [[WADLTransactionServices alloc] initWithWADLServerAPI:self.child];
	return _transaction;
}

+ (WADLTransactionServices *)transaction 
{
	 return [[self sharedServerAPI] transaction]; 
}



#pragma mark - Serialization

- (id)deserializeData:(NSData*)data error:(NSError *__autoreleasing *)error
{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

- (NSData*)serializeObject:(id)object error:(NSError *__autoreleasing *)error
{
    return [NSJSONSerialization dataWithJSONObject:object
                                        #ifdef DEBUG
                                           options:NSJSONWritingPrettyPrinted
                                        #else
                                           options:0
                                        #endif
                                             error:error];
}

#pragma mark -

- (NSURL *)baseURLForServicesResource:(WADLServicesResource *)resource
{
    return [NSURL URLWithString:@"<base_url>"];
}

- (NSString *)methodNameForMethod:(WADLRequestMethod)method
{
    switch (method) {
        case WADLRequestMethodGET:      return @"GET";
        case WADLRequestMethodPOST:     return @"POST";
        case WADLRequestMethodPUT:      return @"PUT";
        case WADLRequestMethodDELETE:   return @"DELETE";
        case WADLRequestMethodHEAD:     return @"HEAD";
        default:
            NSAssert(0, @"Method not supported: %ld", (long)method);
    }
    return nil;
}

- (WADLAbstractServerAPI<WADLServerAPIInheritor>*)child
{
    return (WADLAbstractServerAPI<WADLServerAPIInheritor>*)self;
}

@end
