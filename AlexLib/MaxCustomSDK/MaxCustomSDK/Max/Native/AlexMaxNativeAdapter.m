
#import "AlexMaxNativeAdapter.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "AlexMaxBiddingRequest.h"
#import "AlexMaxC2SBiddingRequestManager.h"
#import "AlexMaxNativeCustomEvent.h"
#import "AlexMaxBaseManager.h"
#import "AlexMaxNativeRenderer.h"

@interface AlexMaxNativeAdapter()

@property(nonatomic, strong) MANativeAdLoader *maxNativeAdLoader;
@property(nonatomic, strong) AlexMaxNativeCustomEvent *customEvent;
@property(nonatomic, copy) void (^completionBlock)(NSArray<NSDictionary *> *, NSError *);
@property(nonatomic, strong) NSDictionary *localInfo;
@property(nonatomic, strong) NSDictionary *serverInfo;

@end

@implementation AlexMaxNativeAdapter
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
    
    if ([[AlexMaxBaseManager sharedManager] getMAXInitSucceedStatus]) {
        [self initSuccessStartLoad];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSuccessStartLoad) name:AlexMaxStartInitSuccessKey object:nil];
        [AlexMaxBaseManager initALSDKWithServerInfo:serverInfo];
    }
}

- (void)initSuccessStartLoad {
    
    dispatch_async(dispatch_get_main_queue(), ^{

        NSString *bidId = self.serverInfo[kATAdapterCustomInfoBuyeruIdKey];
        AlexMaxBiddingRequest *request = [[AlexMAXNetworkC2STool sharedInstance] getRequestItemWithUnitID:self.serverInfo[@"unit_id"]];
        
        if (bidId && request) {
            self.customEvent = (AlexMaxNativeCustomEvent *)request.customEvent;
            self.customEvent.requestCompletionBlock = self.completionBlock;
            ATBidInfo *bidInfo = (ATBidInfo *)self.serverInfo[kATAdapterCustomInfoBidInfoKey];
            self.customEvent.maxAd = bidInfo.customObject;
            if (request.customObject) {
                self.maxNativeAdLoader = request.customObject;
                self.customEvent.maxNativeAdLoader = self.maxNativeAdLoader;
                [self.customEvent maxNativeRenderWithMaAd:request.customObject nativeAdView:request.nativeAds.firstObject];
            }
            // remove requestItem
            [[AlexMAXNetworkC2STool sharedInstance] removeRequestItemWithUnitID:self.serverInfo[@"unit_id"]];
            
        } else {
            self.customEvent = [[AlexMaxNativeCustomEvent alloc]initWithInfo:self.serverInfo localInfo:self.localInfo];
            self.customEvent.requestCompletionBlock = self.completionBlock;
            self.maxNativeAdLoader = [[MANativeAdLoader alloc] initWithAdUnitIdentifier:self.serverInfo[@"unit_id"] sdk:[ALSdk sharedWithKey:self.serverInfo[@"sdk_key"]]];
            
            NSLog(@"MAX--unit_id:%@--sdk_key:%@",self.serverInfo[@"unit_id"],self.serverInfo[@"sdk_key"]);
            self.customEvent.maxNativeAdLoader = self.maxNativeAdLoader;
            self.maxNativeAdLoader.nativeAdDelegate = self.customEvent;
            self.maxNativeAdLoader.revenueDelegate = self.customEvent;
            [self.maxNativeAdLoader loadAd];
        }        
    });
}

+ (Class)rendererClass {
    return [AlexMaxNativeRenderer class];
}

#pragma mark - C2S
+ (void)bidRequestWithPlacementModel:(ATPlacementModel*)placementModel unitGroupModel:(ATUnitGroupModel*)unitGroupModel info:(NSDictionary*)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    
    AlexMaxBiddingRequest *request = [[AlexMAXNetworkC2STool sharedInstance] getRequestItemWithUnitID:info[@"unit_id"]];
    
    if (request.customObject && request.bidCompletion) {
        ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:placementModel.placementID unitGroupUnitID:unitGroupModel.unitID adapterClassString:unitGroupModel.adapterClassString price:request.price currencyType:ATBiddingCurrencyTypeUS expirationInterval:unitGroupModel.bidTokenTime customObject:nil];
        request.bidCompletion(bidInfo, nil);
        return;
    }
    AlexMaxNativeCustomEvent *customEvent = [[AlexMaxNativeCustomEvent alloc]initWithInfo:info localInfo:info];
    customEvent.isC2SBiding = YES;
    customEvent.networkAdvertisingID = unitGroupModel.content[@"unit_id"];
    
    AlexMaxBiddingRequest *maxRequest = [AlexMaxBiddingRequest new];
    maxRequest.customEvent = customEvent;
    maxRequest.unitGroup = unitGroupModel;
    maxRequest.placementID = placementModel.placementID;
    maxRequest.bidCompletion = completion;
    maxRequest.unitID = unitGroupModel.content[@"unit_id"];
    maxRequest.extraInfo = info;
    maxRequest.adType = ATAdFormatNative;
    [[AlexMaxC2SBiddingRequestManager sharedInstance] startWithRequestItem:maxRequest];
    
}

@end
