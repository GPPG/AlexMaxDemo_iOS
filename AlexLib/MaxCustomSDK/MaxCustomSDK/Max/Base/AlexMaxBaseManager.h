
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AppLovinSDK/AppLovinSDK.h>

NS_ASSUME_NONNULL_BEGIN

@class ATUnitGroupModel,ATAdCustomEvent,ATBidInfo;

#define ATMaxStartInitSuccessKey @"com.MaxStart_init_success"

@interface AlexMaxBaseManager : ATNetworkBaseManager

@property(atomic, assign) BOOL isInitSucceed;
@property(nonatomic, strong) NSMutableArray *c2sRequestArray;

+ (void)initALSDKWithServerInfo:(NSDictionary *)serverInfo;
+ (NSString *)getMaxFormat:(MAAd*)maxAd;

+ (void)initC2SALSDKWithServerInfo:(NSDictionary *)serverInfo parObject:(id)parObject;

+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
