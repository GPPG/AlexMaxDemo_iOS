
#import "AlexMaxRewardedVideoAdapter.h"
#import "AlexMaxBaseManager.h"
#import "AlexMaxRewardedVideoCustomEvent.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "AlexMaxBiddingRequest.h"
#import "AlexMaxC2SBiddingRequestManager.h"

@interface AlexMaxRewardedVideoAdapter ()

@property(nonatomic, strong) MARewardedAd *rewardedAd;
@property(nonatomic, strong) AlexMaxRewardedVideoCustomEvent *customEvent;
@property(nonatomic, copy) void (^completionBlock)(NSArray<NSDictionary *> *, NSError *);
@property(nonatomic, strong) NSDictionary *localInfo;
@property(nonatomic, strong) NSDictionary *serverInfo;

@end

@implementation AlexMaxRewardedVideoAdapter

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ATMaxStartInitSuccessKey object:nil];
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSuccessStartLoad) name:ATMaxStartInitSuccessKey object:nil];
        [AlexMaxBaseManager initALSDKWithServerInfo:serverInfo];
    }
}

- (void)initSuccessStartLoad {
    
    dispatch_async(dispatch_get_main_queue(), ^{

        NSString *bidId = self.serverInfo[kATAdapterCustomInfoBuyeruIdKey];
        if (bidId) {
            AlexMaxBiddingRequest *request = [[AlexNetworkC2STool sharedInstance] getRequestItemWithUnitID:self.serverInfo[@"unit_id"]];
            self.customEvent = (AlexMaxRewardedVideoCustomEvent *)request.customEvent;
            self.customEvent.requestCompletionBlock = self.completionBlock;
            self.customEvent.customEventMetaDataDidLoadedBlock = self.metaDataDidLoadedBlock;
            
            ATBidInfo *bidInfo = (ATBidInfo *)self.serverInfo[kATAdapterCustomInfoBidInfoKey];
            self.customEvent.maxAd = bidInfo.customObject;
            
            if (request.customObject) {
                self.rewardedAd = request.customObject;
                if (self.rewardedAd.isReady) {
                    [self.customEvent trackRewardedVideoAdLoaded:self.rewardedAd adExtra:nil];
                } else {
                    [self.rewardedAd loadAd];
                }
            }
            // remove requestItem
            [[AlexNetworkC2STool sharedInstance] removeRequestItemWithUnitID:self.serverInfo[@"unit_id"]];
        } else {
            self.customEvent = [[AlexMaxRewardedVideoCustomEvent alloc]initWithInfo:self.serverInfo localInfo:self.localInfo];
            self.customEvent.requestCompletionBlock = self.completionBlock;
            self.customEvent.customEventMetaDataDidLoadedBlock = self.metaDataDidLoadedBlock;
            self.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier:self.serverInfo[@"unit_id"] sdk:[ALSdk sharedWithKey:self.serverInfo[@"sdk_key"]]];
            self.customEvent.rewardedAd = self.rewardedAd;
            self.rewardedAd.delegate = self.customEvent;
            [self.rewardedAd loadAd];
        }
    });
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary*)info {
    MARewardedAd *reward = customObject;
    return reward.isReady;
}

+ (void)showRewardedVideo:(ATRewardedVideo*)rewardedVideo inViewController:(UIViewController*)viewController delegate:(id<ATRewardedVideoDelegate>)delegate {
    rewardedVideo.customEvent.delegate = delegate;
    MARewardedAd *reward = rewardedVideo.customObject;
    [reward showAd];
}

#pragma mark - C2S
+ (void)bidRequestWithPlacementModel:(ATPlacementModel*)placementModel unitGroupModel:(ATUnitGroupModel*)unitGroupModel info:(NSDictionary*)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    
    AlexMaxBiddingRequest *request = [[AlexNetworkC2STool sharedInstance] getRequestItemWithUnitID:info[@"unit_id"]];
    
    if (request.customObject && request.bidCompletion) {
        MARewardedAd *rewardedAd = request.customObject;
        if (rewardedAd.isReady) {
            ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:placementModel.placementID unitGroupUnitID:unitGroupModel.unitID adapterClassString:unitGroupModel.adapterClassString price:request.price currencyType:ATBiddingCurrencyTypeUS expirationInterval:unitGroupModel.bidTokenTime customObject:nil];
                request.bidCompletion(bidInfo, nil);
                return;
        }
    }
    
    AlexMaxRewardedVideoCustomEvent *customEvent = [[AlexMaxRewardedVideoCustomEvent alloc]initWithInfo:info localInfo:info];
    customEvent.isC2SBiding = YES;
    customEvent.networkAdvertisingID = unitGroupModel.content[@"unit_id"];
    
    AlexMaxBiddingRequest *maxRequest = [AlexMaxBiddingRequest new];
    maxRequest.customEvent = customEvent;
    maxRequest.unitGroup = unitGroupModel;
    maxRequest.placementID = placementModel.placementID;
    maxRequest.bidCompletion = completion;
    maxRequest.unitID = unitGroupModel.content[@"unit_id"];
    maxRequest.extraInfo = info;
    maxRequest.adType = ATAdFormatRewardedVideo;
    [[AlexMaxC2SBiddingRequestManager sharedInstance] startWithRequestItem:maxRequest];
    
}

@end
