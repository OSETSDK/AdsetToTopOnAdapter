//
//  OSETCustomerToRewardAdapter.m
//  YhsADSProject
//
//  Created by Shens on 20/3/2025.
//

#import "OSETCustomerToRewardAdapter.h"
#import "OSETRewardedVideoCustomEvent.h"
#import <AnyThinkSDK/ATAdManager+RewardedVideo.h>

@interface OSETCustomerToRewardAdapter ()
@property (nonatomic, strong) OSETRewardedVideoCustomEvent *customEvent;
@property (nonatomic, strong) OSETRewardVideoAd *rewardAd;

@end
@implementation OSETCustomerToRewardAdapter

#pragma mark - Ad load
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {

   NSString *osetSlotId = [self osetSlotIdFromServerContent:argument.serverContentDic];
#if DEBUG
   NSLog(@"hh [OSETTopOnAdapter] %@ 后台下发 slotId=%@", NSStringFromClass(self.class), @"<redacted>");
#endif
   id value = argument.localInfoDic[kATAdLoadingExtraUserIDKey];
   NSString *userId = [value isKindOfClass:NSString.class] ? value : @"";
   self.rewardAd = [[OSETRewardVideoAd alloc] initWithSlotId:osetSlotId withUserId:userId];
   self.rewardAd.delegate = self.customEvent;
   [self.rewardAd loadRewardAdData];
}

#pragma mark - Ad show
- (void)showRewardedVideoInViewController:(UIViewController *)viewController {
   [self.rewardAd showRewardFromRootViewController:viewController];
}

#pragma mark - Ad ready
- (BOOL)adReadyRewardedWithInfo:(NSDictionary *)info {
   return self.rewardAd.isAdValid;
}

#pragma mark - C2S Win Loss
- (void)didReceiveBidResult:(ATBidWinLossResult *)result {
    [OSETCustomBaseAdapter reportBidResult:result forAd:self.rewardAd];
}




#pragma mark - lazy
- (OSETRewardedVideoCustomEvent *)customEvent{
   if (_customEvent == nil) {
       _customEvent = [[OSETRewardedVideoCustomEvent alloc] init];
       _customEvent.adStatusBridge = self.adStatusBridge;
   }
   return _customEvent;
}

@end
