#import "DPLDeepLink+AppLinks.h"

NSString * const DPLAppLinksDataKey              = @"al_applink_data";
NSString * const DPLAppLinksTargetURLKey         = @"target_url";
NSString * const DPLAppLinksExtrasKey            = @"extras";
NSString * const DPLAppLinksVersionKey           = @"version";
NSString * const DPLAppLinksUserAgentKey         = @"user_agent";
NSString * const DPLAppLinksReferrerAppLinkKey   = @"referer_app_link";
NSString * const DPLAppLinksReferrerTargetURLKey = @"target_url";
NSString * const DPLAppLinksReferrerURLKey       = @"url";
NSString * const DPLAppLinksReferrerAppNameKey   = @"app_name";

@implementation DPLDeepLink (AppLinks)

- (NSDictionary<NSString *, NSObject *> *)appLinkData {
    return (NSDictionary<NSString *, NSObject *> *)self.queryParameters[DPLAppLinksDataKey];
}


- (NSDictionary<NSString *, NSObject *> *)referrerAppLinkData {
    return (NSDictionary<NSString *, NSObject *> *)self.appLinkData[DPLAppLinksDataKey];
}


#pragma mark - App Link Properties

- (NSURL *)targetURL {
    return [NSURL URLWithString:(NSString *)self.appLinkData[DPLAppLinksTargetURLKey]];
}


- (NSDictionary<NSString *, NSString *> *)extras {
    return (NSDictionary<NSString *, NSString *> *)self.appLinkData[DPLAppLinksExtrasKey];
}


- (NSString *)version {
    return (NSString *)self.appLinkData[DPLAppLinksVersionKey];
}


- (NSString *)userAgent {
    return (NSString *)self.appLinkData[DPLAppLinksUserAgentKey];
}


#pragma mark - Referrer App Link Properties

- (NSURL *)referrerTargetURL {
    return [NSURL URLWithString:(NSString *)self.referrerAppLinkData[DPLAppLinksReferrerTargetURLKey]];
}


- (NSURL *)referrerURL {
    return [NSURL URLWithString:(NSString *)self.referrerAppLinkData[DPLAppLinksReferrerURLKey]];
}


- (NSString *)referrerAppName {
    return (NSString *)self.referrerAppLinkData[DPLAppLinksReferrerAppNameKey];
}

@end
