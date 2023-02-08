//
//  ATAdCustomEvent.h
//  AnyThinkSDK
//
//  Created by Martin Lau on 05/07/2018.
//  Copyright © 2018 Martin Lau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATAd.h"
#import "ATTracker.h"
#import "ATBidInfo.h"

extern NSString *const kATSDKFailedToLoadSplashADMsg;
extern NSString *const kATSDKFailedToLoadBannerADMsg;
extern NSString *const kATSDKFailedToLoadInterstitialADMsg;
extern NSString *const kATSDKFailedToLoadNativeADMsg;
extern NSString *const kATSDKFailedToLoadRewardedVideoADMsg;
extern NSString *const kATSDKSplashADTooLongToLoadPlacementSettingMsg;
extern NSString *const kATSDKImportIssueErrorReason;
extern NSString *const kATAdAssetsAppIDKey;

extern NSString *const kATAdCustomEventNotificationKey;

typedef NS_OPTIONS(NSInteger, ATCustomEventType) {
    ATCustomEventLoaded = 0,
    ATCustomEventLoadFail = 1,
    ATCustomEventShow = 2,
    ATCustomEventShowFail = 3,
    ATCustomEventClick = 4,
    ATCustomEventClose = 5,
    ATCustomEventDetailViewWillPresentScreen = 6,
    ATCustomEventCloseBeforeViewAppear = 7, 
};

typedef NS_OPTIONS(NSInteger, ATAdCloseType) {
    ATAdCloseUnknow = 1,            // ad close type unknow
    ATAdCloseSkip = 2,              // ad skip to close
    ATAdCloseCountdown = 3,         // ad countdown to close
    ATAdCloseClickcontent = 4,      // ad clickcontent to close
    ATAdCloseShowfail = 99          // ad showfail to close
};


@interface ATAdCustomEvent : NSObject
+(NSDictionary*)customInfoWithUnitGroupModel:(ATUnitGroupModel*)unitGroupModel extra:(NSDictionary*)extra;
-(instancetype) initWithUnitID:(NSString*)unitID serverInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo;
-(void) handleAssets:(NSDictionary*)assets;
-(void) handleLoadingFailure:(NSError*)error;
-(void) handleClose;
-(void) handleShow;
-(void) handleShowFailed;

-(void) trackShow;
-(void) trackClick;

-(ATNativeADSourceType) adSourceType;
@property(nonatomic, weak) id<ATAd> ad;
@property(nonatomic) NSNumber *sdkTime;
@property(nonatomic, copy) void(^requestCompletionBlock)(NSArray<NSDictionary*> *assets, NSError *error);
@property(nonatomic) NSInteger requestNumber;
@property (nonatomic,copy) void (^customEventMetaDataDidLoadedBlock)(void);
/**
 * Failed or successful, a request's considered finished.
 */
@property(nonatomic) NSInteger numberOfFinishedRequests;
@property(nonatomic, readonly) NSMutableArray<NSDictionary*>* assets;
@property(nonatomic, strong) NSDictionary *serverInfo;
@property(nonatomic, strong) NSDictionary *localInfo;
@property(nonatomic) BOOL rewardGranted;

-(void) saveShowAPIContext;
@property(nonatomic, readonly) NSDate *showDate;
@property(nonatomic, readonly) NSString *psIDOnShow;

+(NSInteger) calculateAdPriority:(id<ATAd>)ad;

@property (nonatomic, assign) NSString *networkUnitId;
@property (nonatomic) NSDictionary *networkCustomInfo;

@property(nonatomic, weak) id adapter;

@property (nonatomic, assign) ATAdCloseType closeType;

@property (nonatomic, assign) BOOL isC2SBiding;

@property(nonatomic, strong) NSString *networkAdvertisingID;

@end
