

#import "AlexMaxSplashAdapter.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "AlexMaxBiddingRequest.h"
#import "AlexMaxC2SBiddingRequestManager.h"
#import "AlexMaxSplashCustomEvent.h"
#import "AlexMaxBaseManager.h"

@interface AlexMaxSplashAdapter()

@property (nonatomic, strong) MAAppOpenAd *splashAd;
@property(nonatomic, strong) AlexMaxSplashCustomEvent *customEvent;
@property(nonatomic, copy) void (^completionBlock)(NSArray<NSDictionary *> *, NSError *);
@property(nonatomic, strong) NSDictionary *localInfo;
@property(nonatomic, strong) NSDictionary *serverInfo;

@end

@implementation AlexMaxSplashAdapter

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
        AlexMaxBiddingRequest *request = [[AlexNetworkC2STool sharedInstance] getRequestItemWithUnitID:self.serverInfo[@"unit_id"]];
        
        if (bidId && request) {
            ATBidInfo *bidInfo = (ATBidInfo *)self.serverInfo[kATAdapterCustomInfoBidInfoKey];
            self.customEvent = (AlexMaxSplashCustomEvent *)request.customEvent;
            self.customEvent.requestCompletionBlock = self.completionBlock;
            self.customEvent.maxAd = bidInfo.customObject;
            if (request.customObject) {
                self.splashAd = request.customObject;
                if (self.splashAd.isReady) {
                    [self.customEvent trackSplashAdLoaded:self.splashAd];
                } else {
                    [self.splashAd loadAd];
                }
            }
            self.splashAd = request.customObject;
            // remove requestItem
            [[AlexNetworkC2STool sharedInstance] removeRequestItemWithUnitID:self.serverInfo[@"unit_id"]];
        } else {
            self.customEvent = [[AlexMaxSplashCustomEvent alloc]initWithInfo:self.serverInfo localInfo:self.localInfo];
            self.customEvent.requestCompletionBlock = self.completionBlock;
            self.splashAd = [[MAAppOpenAd alloc] initWithAdUnitIdentifier:self.serverInfo[@"unit_id"] sdk:[ALSdk sharedWithKey:self.serverInfo[@"sdk_key"]]];
            self.customEvent.splashAd = self.splashAd;
            self.splashAd.delegate = self.customEvent;
            [self.splashAd loadAd];
        }
    });
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary*)info {
    
    MAAppOpenAd *splashAd = customObject;
    return splashAd.isReady;
}

+ (void)showSplash:(ATSplash *)splash localInfo:(NSDictionary *)localInfo delegate:(id<ATSplashDelegate>)delegate {
    
    MAAppOpenAd *splashAd = splash.customObject;
    [splashAd showAd];
}

#pragma mark - C2S
+ (void)bidRequestWithPlacementModel:(ATPlacementModel*)placementModel unitGroupModel:(ATUnitGroupModel*)unitGroupModel info:(NSDictionary*)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    
    AlexMaxBiddingRequest *request = [[AlexNetworkC2STool sharedInstance] getRequestItemWithUnitID:info[@"unit_id"]];
    
    if (request.customObject && request.bidCompletion) {
        MAAppOpenAd *splashAd = request.customObject;
        if (splashAd.isReady) {
            ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:placementModel.placementID unitGroupUnitID:unitGroupModel.unitID adapterClassString:unitGroupModel.adapterClassString token:unitGroupModel.content[@"unit_id"] price:request.price currencyType:ATBiddingCurrencyTypeUS expirationInterval:unitGroupModel.bidTokenTime customObject:nil];
            request.bidCompletion(bidInfo, nil);
            return;
        }
    }
    
    AlexMaxSplashCustomEvent *customEvent = [[AlexMaxSplashCustomEvent alloc]initWithInfo:info localInfo:info];
    customEvent.isC2SBiding = YES;
    customEvent.networkAdvertisingID = unitGroupModel.content[@"unit_id"];
    
    AlexMaxBiddingRequest *maxRequest = [AlexMaxBiddingRequest new];
    maxRequest.customEvent = customEvent;
    maxRequest.unitGroup = unitGroupModel;
    maxRequest.placementID = placementModel.placementID;
    maxRequest.bidCompletion = completion;
    maxRequest.unitID = unitGroupModel.content[@"unit_id"];
    maxRequest.extraInfo = info;
    maxRequest.adType = ATAdFormatSplash;
    [[AlexMaxC2SBiddingRequestManager sharedInstance] startWithRequestItem:maxRequest];
    
}

@end
