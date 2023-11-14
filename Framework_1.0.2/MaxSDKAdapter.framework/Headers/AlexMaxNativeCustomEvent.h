

#import <AnyThinkNative/AnyThinkNative.h>
#import <AppLovinSDK/AppLovinSDK.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kATMAXNativeAssetsExpressAdViewKey;

@interface AlexMaxNativeCustomEvent : ATNativeADCustomEvent<MANativeAdDelegate,MAAdRevenueDelegate>

@property(nonatomic, weak) id maxNativeAd;

@property (nonatomic, readwrite) MAAd *maxAd;

- (void)maxExpressWithMaAd:(MAAd * _Nonnull)ad nativeAdView:(MANativeAdView * _Nullable)nativeAdView;

@end

NS_ASSUME_NONNULL_END
