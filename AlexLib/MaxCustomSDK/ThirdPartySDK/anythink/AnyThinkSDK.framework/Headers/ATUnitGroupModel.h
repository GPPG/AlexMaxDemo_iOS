//
//  ATUnitGroupModel.h
//  AnyThinkSDK
//
//  Created by Martin Lau on 11/04/2018.
//  Copyright © 2018 Martin Lau. All rights reserved.
//

#import "ATModel.h"
#import <UIKit/UIKit.h>
#import "ATMyOfferOfferModel.h"
#import "ATBidInfo.h"


typedef NS_ENUM(NSInteger, ATShowAutoLoadType) {
    ATShowAutoOneAdSupportLoadType = 1,
    ATShowAutoOneAdNotSupportLoadType,
    ATShowAutoOneNetWorkNotSupportLoadType,
};
/// ad type：0 Native, 1 Rewarded, 2 Banner, 3 Interstitial, 4 Splash
typedef NS_ENUM(NSInteger, ATUnitGroupJointAdType) {
    ATUnitGroupJointAdOtherType = -1,
    ATUnitGroupJointAdNativeType = 0,
    ATUnitGroupJointAdRewardedType = 1,
    ATUnitGroupJointAdBannerType = 2,
    ATUnitGroupJointAdInterstitialType = 3,
    ATUnitGroupJointAdSplashType = 4,
};

typedef NS_ENUM(NSInteger, ATNetworkCurrencyType) {
    ATNetworkCurrencyCNYType = 0,
    ATNetworkCurrencyUSDType,

};


@interface ATUnitGroupModel : ATModel
-(instancetype) initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, strong) NSString *tpBidID;

@property(nonatomic, readonly, weak) Class adapterClass;
@property(nonatomic, readonly) NSString *adapterClassString;
@property(nonatomic, readonly) NSInteger capByDay;
@property(nonatomic, readonly) NSInteger capByHour;
@property(nonatomic, assign) NSTimeInterval networkCacheTime;
@property(nonatomic, readonly) NSInteger networkFirmID;
@property(nonatomic, readonly) NSString *networkName;
@property(nonatomic, readonly) NSInteger networkRequestNum;
@property(nonatomic, readonly) NSTimeInterval networkDataTimeout; //  5.1.0 双回调数据超时
@property(nonatomic, readonly) NSTimeInterval networkTimeout;
@property(nonatomic, readonly) NSTimeInterval skipIntervalAfterLastLoadingFailure;
@property(nonatomic, readonly) NSTimeInterval skipIntervalAfterLastBiddingFailure;
@property(nonatomic, readonly) NSString *unitGroupID;// 废弃
@property(nonatomic, readonly) NSString *unitID;
@property(nonatomic, readonly) NSDictionary *content;
@property(nonatomic, readonly) NSTimeInterval showingInterval;//minimum interval between previous request & last impression
@property(nonatomic, readonly) CGSize adSize;

@property(nonatomic, readonly) BOOL splashZoomOut;
@property(nonatomic, readwrite) NSString *price;
@property(nonatomic, readonly) NSString *ecpmByCurrency;
@property(nonatomic, readonly) NSInteger ecpmLevel;
@property(nonatomic, readonly) NSTimeInterval headerBiddingRequestTimeout;
@property(nonatomic, readwrite) NSString *bidPrice;
@property(nonatomic, readwrite) NSString *bidToken;
@property(nonatomic, readonly) BOOL headerBidding;
@property(nonatomic, readonly) ATUnitGroupType unitGroupType;
@property(nonatomic, readonly) NSTimeInterval bidTokenTime;
@property(nonatomic, readonly) NSTimeInterval statusTime;
@property(nonatomic, readonly) NSString *clickTkAddress;
@property(nonatomic, readonly) NSTimeInterval clickTkDelayMin;
@property(nonatomic, readonly) NSTimeInterval clickTkDelayMax;
@property(nonatomic, readonly) BOOL postsNotificationOnShow;
@property(nonatomic, readonly) BOOL postsNotificationOnClick;
@property(nonatomic, readonly) NSString *precision;
@property(nonatomic, readonly) BOOL canAutoReady;
@property(nonatomic, readonly) BOOL waterfallTimeOutSW;
@property(nonatomic, readonly) BOOL reportBidPriceSW;
@property(nonatomic, assign) BOOL bidRealTimeLoadSW;
@property(nonatomic, readonly) BOOL returnHBEcpmSW;
@property(nonatomic, readwrite) ATBidInfo *bidInfo;

@property(nonatomic, readonly, getter=isBidInfoNoPrice) BOOL bidInfoNoPrice;
@property(nonatomic, readonly) BOOL unitGroupS2SSW;

@property(nonatomic) BOOL s2sRewardEnabled;

// v5.7.61+
@property(nonatomic, readonly) NSInteger weight;

@property(nonatomic, copy) NSString *directOfferOid;
// v6.1.10
@property (nonatomic,readonly) NSTimeInterval showDelay;

@property(nonatomic, assign) ATShowAutoLoadType showAutoLoadType;


@property(nonatomic) NSInteger priority; // when ad is filterd

/// ad type：0 Native, 1 Rewarded, 2 Banner, 3 Interstitial, 4 Splash
@property(nonatomic, assign) ATUnitGroupJointAdType jointAdType;

@property(nonatomic, assign) BOOL isHBAdvanceRequest;

@property (nonatomic,strong) NSString *bidFloor;

// 新价格
@property (nonatomic, strong) NSString *sortPriorityLevel;

//reference 6.1.42
@property(nonatomic) NSInteger s2sSendLossPosition;

@property (nonatomic, strong) NSString *bidinfoEcpmStr;

@property (nonatomic, assign) ATNetworkCurrencyType networkCurrencyType;

@end
