//
//  ATNativeADCustomEvent.h
//  AnyThinkSDK
//
//  Created by Martin Lau on 25/04/2018.
//  Copyright © 2018 Martin Lau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>

#import "ATNativeADView.h"
//#import "ATTracker.h"
#import "ATNativeADDelegate.h"
//#import "ATAdCustomEvent.h"

@class ATNativeADCache;

@interface ATNativeADCustomEvent : ATAdCustomEvent

/// callback to developer when ad is loaded
/// @param assets - native ad assets
- (void)trackNativeAdLoaded:(NSArray *)assets;

/// callback to developer when ad is load failed
/// @param error - error message
- (void)trackNativeAdLoadFailed:(NSError *)error;

- (void)didAttachMediaView;
- (void)invalidateUsedAdInfo;
- (void)willDetachOffer:(ATNativeADCache *)offer fromAdView:(ATNativeADView *)adView;

/// callback to developer when ad is showed
/// @param refresh - whether the show is trigered by a ad refresh
- (void)trackNativeAdShow:(BOOL)refresh;

/// callback to developer when ad is clicked
- (void)trackNativeAdClick;

- (void)trackNativeAdVideoStart;
- (void)trackNativeAdVideoEnd;

/// callback to developer when ad is closed
- (void)trackNativeAdClosed;

- (void)trackNativeAdImpression;
- (void)trackNativeAdDeeplinkOrJumpResult:(BOOL)success;

//v5.7.47
- (void)trackNativeAdCloseDetail;

/// If it returns YES, then when sending the embedding points of "show", the embedding points of "impression" will be sent together. Otherwise, it will not be sent. Same for the banner ads (ATBannerCustomEvent.h).
- (BOOL)sendImpressionTrackingIfNeed;

/// only for adx、onlineApi、myoffer、directOffer
- (NSTimeInterval)getNativeAdViewMonitoringShowTime;

- (BOOL)isAutoClickdSwitch;
- (CGFloat)popupReminderDuration;
- (CGFloat)autoClickdDuration;


- (BOOL)isAllowMraidWebPreLoad;
- (BOOL)isMraidAd;
- (NSString *)getNativeAdViewOfferIdentifier;
- (void)sendMraidAdRenderSuccessEvent;

-(NSDictionary *)delegateExtra;
- (NSMutableDictionary *)delegateExtraWithNativeAD:(ATNativeADCache *)cache;
- (instancetype)initWithInfo:(NSDictionary *)serverInfo
                   localInfo:(NSDictionary *)localInfo;

-(ATNativeADSourceType) sourceType;

@property (nonatomic,copy) void(^requestCompletionBlock)(NSArray<NSDictionary *> *assets, NSError *error);
@property (nonatomic,weak) ATNativeADView *adView;
@property (nonatomic) NSInteger requestNumber;
/**
 * Failed or successful, a request's considered finished.
 */
@property(nonatomic) NSInteger numberOfFinishedRequests;
@property(nonatomic, readonly) NSMutableArray<NSDictionary *>* assets;

@property (nonatomic, assign) ATOfferClickAdType clickType;



@end

@interface ATNativeADView(Event)
- (void)notifyNativeAdClick;
- (void)notifyVideoStart;
- (void)notifyVideoEnd;
- (void)notifyVideoEnterFullScreen;
- (void)notifyVideoExitFullScreen;
- (void)notifyCloseButtonTapped;
- (void)notifyDeeplinkOrJumpResult:(BOOL)success;
- (void)notifyAdDetailClosed;
- (void)notifyNativeAdShow;
@end
