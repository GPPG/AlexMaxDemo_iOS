

#import "AlexMaxBannerAdapter.h"
#import "AlexMaxBaseManager.h"
#import "AlexMaxBannerCustomEvent.h"
#import "AlexMaxBiddingRequest.h"
#import "AlexMaxC2SBiddingRequestManager.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface AlexMaxBannerAdapter ()

@property(nonatomic, strong) MAAdView *adView;
@property(nonatomic, strong) AlexMaxBannerCustomEvent *customEvent;
@property(nonatomic, copy) void (^completionBlock)(NSArray<NSDictionary *> *, NSError *);
@property(nonatomic, strong) NSDictionary *localInfo;
@property(nonatomic, strong) NSDictionary *serverInfo;

@end

@implementation AlexMaxBannerAdapter
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AlexMaxStartInitSuccessKey object:nil];
}

- (instancetype)initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    
    self = [super init];
    if (self != nil) {
        [AlexMaxBaseManager initWithCustomInfo:serverInfo localInfo:localInfo];
    }
    return self;
}

- (void)loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    
    self.localInfo = localInfo;
    self.serverInfo = serverInfo;
    self.completionBlock = completion;
    
    if ([AlexMaxBaseManager sharedManager].isInitSucceed) {
        [self initSuccessStartLoad];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSuccessStartLoad) name:AlexMaxStartInitSuccessKey object:nil];
        [AlexMaxBaseManager initALSDKWithServerInfo:serverInfo];
    }
}

- (void)initSuccessStartLoad {
    
    dispatch_async(dispatch_get_main_queue(), ^{

        NSString *bidId = self.serverInfo[kATAdapterCustomInfoBuyeruIdKey];
        if (bidId) {
            
            AlexMaxBiddingRequest *request = [[AlexMAXNetworkC2STool sharedInstance] getRequestItemWithUnitID:self.serverInfo[@"unit_id"]];
            self.customEvent = (AlexMaxBannerCustomEvent *)request.customEvent;
            self.customEvent.requestCompletionBlock = self.completionBlock;
            ATBidInfo *bidInfo = (ATBidInfo *)self.serverInfo[kATAdapterCustomInfoBidInfoKey];
            self.customEvent.maxAd = bidInfo.customObject;
            if (request.customObject) {
                self.adView = request.customObject;
                [self.customEvent trackBannerAdLoaded:self.adView adExtra:nil];
            }
            
            // remove requestItem
            [[AlexMAXNetworkC2STool sharedInstance] removeRequestItemWithUnitID:self.serverInfo[@"unit_id"]];
            
        } else {
            self.customEvent = [[AlexMaxBannerCustomEvent alloc]initWithInfo:self.serverInfo localInfo:self.localInfo];
            self.customEvent.requestCompletionBlock = self.completionBlock;
            MAAdFormat *format = [self.serverInfo[@"unit_type"] boolValue] ? [MAAdFormat mrec] : [MAAdFormat banner];
            self.adView = [[MAAdView alloc]initWithAdUnitIdentifier:self.serverInfo[@"unit_id"] adFormat:format sdk:[ALSdk sharedWithKey:self.serverInfo[@"sdk_key"]]];
            self.adView.delegate = self.customEvent;
            UIView *bannerView = (UIView *)self.adView;
            bannerView.frame = [self.serverInfo[@"unit_type"] boolValue] ? CGRectMake(0, 0, 300, 250) : CGRectMake(0, 0, 320, 50);
            [self.adView loadAd];
            self.customEvent.adView = self.adView;
        }
    });
}

#pragma mark - C2S
+ (void)bidRequestWithPlacementModel:(ATPlacementModel*)placementModel unitGroupModel:(ATUnitGroupModel*)unitGroupModel info:(NSDictionary*)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    
    AlexMaxBiddingRequest *request = [[AlexMAXNetworkC2STool sharedInstance] getRequestItemWithUnitID:info[@"unit_id"]];
    
    if (request.customObject && request.bidCompletion) {
        
        ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:placementModel.placementID unitGroupUnitID:unitGroupModel.unitID adapterClassString:unitGroupModel.adapterClassString price:request.price currencyType:ATBiddingCurrencyTypeUS expirationInterval:unitGroupModel.bidTokenTime customObject:nil];
        
        request.bidCompletion(bidInfo, nil);
        return;
    }
    
    AlexMaxBannerCustomEvent *customEvent = [[AlexMaxBannerCustomEvent alloc]initWithInfo:info localInfo:info];
    customEvent.networkAdvertisingID = unitGroupModel.content[@"unit_id"];
    customEvent.isC2SBiding = YES;
    
    AlexMaxBiddingRequest *maxRequest = [AlexMaxBiddingRequest new];
    maxRequest.customEvent = customEvent;
    maxRequest.unitGroup = unitGroupModel;
    maxRequest.placementID = placementModel.placementID;
    maxRequest.bidCompletion = completion;
    maxRequest.unitID = unitGroupModel.content[@"unit_id"];
    maxRequest.extraInfo = info;
    maxRequest.adType = ATAdFormatBanner;
    [[AlexMaxC2SBiddingRequestManager sharedInstance] startWithRequestItem:maxRequest];
    
}


@end
