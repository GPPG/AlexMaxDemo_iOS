
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AppLovinSDK/AppLovinSDK.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, AlexMaxNativeRenderType) {
    AlexMaxNativeRenderTypeTemplate = 1,
    AlexMaxNativeRenderTypeSelfRendering = 2,
};

@class ATUnitGroupModel,ATAdCustomEvent,ATBidInfo;

#define AlexMaxStartInitSuccessKey @"kAdApplovinInitiatedKey"

@interface AlexMaxBaseManager : ATNetworkBaseManager

@property(nonatomic, strong) NSMutableArray *c2sRequestArray;

+ (void)initALSDKWithServerInfo:(NSDictionary *)serverInfo;
+ (NSString *)getMaxFormat:(MAAd*)maxAd;

+ (void)initC2SALSDKWithServerInfo:(NSDictionary *)serverInfo parObject:(id)parObject;

+ (instancetype)sharedManager;

- (BOOL)getMAXInitSucceedStatus;


@end

NS_ASSUME_NONNULL_END
