
#import "AlexMaxNativeCustomEvent.h"
#import "AlexMaxBaseManager.h"
#import "AlexMaxC2SBiddingRequestManager.h"

NSString *const kATMAXNativeAssetsExpressAdViewKey = @"max_express_ad_view";

@implementation AlexMaxNativeCustomEvent

#pragma mark - MANativeAdDelegate
- (void)didLoadNativeAd:(nullable MANativeAdView *)nativeAdView forAd:(MAAd *)ad {
    
    if (self.isC2SBiding) {
        AlexMaxBiddingRequest *request = [[AlexNetworkC2STool sharedInstance] getRequestItemWithUnitID:self.networkAdvertisingID];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:nativeAdView];
        request.nativeAds = array;

        NSString *price = [NSString stringWithFormat:@"%f",ad.revenue * 1000];
        [AlexMaxC2SBiddingRequestManager disposeLoadSuccessCall:price customObject:ad unitID:self.networkAdvertisingID];
        self.isC2SBiding = NO;
    }else{
        self.maxAd = ad;
        [self maxExpressWithMaAd:ad nativeAdView:nativeAdView];
    }
}

- (void)didFailToLoadNativeAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    
    NSError *loadFailError = [NSError errorWithDomain:(adUnitIdentifier ?: @"") code:error.code userInfo:@{
        NSLocalizedDescriptionKey:kATSDKFailedToLoadNativeADMsg,
        NSLocalizedFailureReasonErrorKey:error.message
    }];
    if (self.isC2SBiding) {
        [AlexMaxC2SBiddingRequestManager disposeLoadFailCall:loadFailError key:kATSDKFailedToLoadNativeADMsg unitID:self.networkAdvertisingID];
    }else{
        [self trackNativeAdLoadFailed:loadFailError];
    }
}

- (void)didClickNativeAd:(MAAd *)ad {
    [self trackNativeAdClick];
}

- (void)didExpireNativeAd:(MAAd *)ad {
}

- (void)didPayRevenueForAd:(MAAd *)ad {
    [self trackNativeAdImpression];
}

#pragma mark - 模板
- (void)maxExpressWithMaAd:(MAAd * _Nonnull)ad nativeAdView:(MANativeAdView * _Nullable)nativeAdView {
    NSMutableArray<NSDictionary*>* assetArray = [NSMutableArray<NSDictionary*> array];
    NSMutableDictionary *assetDic = [NSMutableDictionary dictionary];
    [assetDic setValue:self forKey:kATAdAssetsCustomEventKey];
    [assetDic setValue:self forKey:kATAdAssetsDelegateObjKey];
    [assetDic setValue:self.maxNativeAd forKey:kATAdAssetsCustomObjectKey];
    [assetDic setValue:nativeAdView forKey:kATMAXNativeAssetsExpressAdViewKey];
    [assetDic setValue:@(1) forKey:kATNativeADAssetsIsExpressAdKey];
    [assetDic setValue:[NSString stringWithFormat:@"%lf",nativeAdView.frame.size.width] forKey:kATNativeADAssetsNativeExpressAdViewWidthKey];
    [assetDic setValue:[NSString stringWithFormat:@"%lf",nativeAdView.frame.size.height] forKey:kATNativeADAssetsNativeExpressAdViewHeightKey];
    [assetArray addObject:assetDic];
    [self trackNativeAdLoaded:assetArray];
}

#pragma mark - other
- (NSString *)networkUnitId {
    return self.serverInfo[@"unit_id"];
}

- (NSDictionary *)networkCustomInfo {
    NSMutableDictionary *customInfo = [[NSMutableDictionary alloc] init];
    [customInfo setValue:@(self.maxAd.revenue) forKey:@"Revenue"];
    [customInfo setValue:self.maxAd.adUnitIdentifier forKey:@"AdUnitId"];
    [customInfo setValue:self.maxAd.creativeIdentifier forKey:@"CreativeId"];
    [customInfo setValue:[AlexMaxBaseManager getMaxFormat:self.maxAd] forKey:@"Format"];
    [customInfo setValue:self.maxAd.networkName forKey:@"NetworkName"];
    [customInfo setValue:self.maxAd.networkPlacement forKey:@"NetworkPlacement"];
    [customInfo setValue:self.maxAd.placement forKey:@"Placement"];
    
    ALSdk *alSdk = [ALSdk sharedWithKey:self.serverInfo[@"sdk_key"]];
    [customInfo setValue:alSdk.configuration.countryCode forKey:@"CountryCode"];
    return customInfo;
}

@end
