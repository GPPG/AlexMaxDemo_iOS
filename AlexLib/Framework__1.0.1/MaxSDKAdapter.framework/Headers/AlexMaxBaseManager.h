
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AppLovinSDK/AppLovinSDK.h>

NS_ASSUME_NONNULL_BEGIN
#define AlexMaxAdapterVersion 1.0.1

typedef NS_ENUM(NSUInteger, AlexMaxNativeRenderType) {
    AlexMaxNativeRenderTypeTemplate = 1,
    AlexMaxNativeRenderTypeSelfRendering = 2,
};

@class ATUnitGroupModel,ATAdCustomEvent,ATBidInfo;

#define AlexMaxStartInitSuccessKey @"com.AlexMaxStart_init_success"

@interface AlexMaxBaseManager : ATNetworkBaseManager

@property(atomic, assign) BOOL isInitSucceed;
@property(nonatomic, strong) NSMutableArray *c2sRequestArray;

+ (void)initALSDKWithServerInfo:(NSDictionary *)serverInfo;
+ (NSString *)getMaxFormat:(MAAd*)maxAd;

+ (void)initC2SALSDKWithServerInfo:(NSDictionary *)serverInfo parObject:(id)parObject;

+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
