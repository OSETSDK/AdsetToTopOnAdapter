//
//  OSETRewardedVideoCustomEvent.m
//  YhsADSProject
//
//  Created by Shens on 21/3/2025.
//

#import "OSETRewardedVideoCustomEvent.h"




@implementation OSETRewardedVideoCustomEvent


- (void)rewardVideoDidReceiveSuccess:(nonnull id)rewardVideoAd slotId:(nonnull NSString *)slotId {
//    [self trackRewardedVideoAdLoaded:rewardVideoAd adExtra:@{}];
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoLoaded" type:ATLogTypeExternal];
//    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoRenderSuccess" type:ATLogTypeExternal];
//    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoCached" type:ATLogTypeExternal];
    NSDictionary * extraDic;
    if([rewardVideoAd isKindOfClass:[OSETRewardVideoAd class]]){
        OSETRewardVideoAd * r = rewardVideoAd;
        extraDic = [OSETCustomBaseAdapter getC2SInfo:r.eCPM];
    }else{
        extraDic = [OSETCustomBaseAdapter getC2SInfo:0];
    }
#if DEBUG
    NSLog(@"hh [OSETTopOnAdapter] %@ 奇点加载成功，回传 TopOn 参与竞价", NSStringFromClass(self.class));
#endif
    [self.adStatusBridge atOnRewardedAdLoadedExtra:extraDic];

}

- (void)rewardVideoLoadToFailed:(nonnull id)rewardVideoAd error:(nonnull NSError *)error {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoError" type:ATLogTypeExternal];
    // 广告加载失败回调
#if DEBUG
    NSLog(@"hh [OSETTopOnAdapter] %@ 奇点加载失败", NSStringFromClass(self.class));
#endif
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}

- (void)rewardVideoDidClick:(nonnull id)rewardVideoAd {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoClicked" type:ATLogTypeExternal];
    [self.adStatusBridge atOnAdClick:nil];

}

- (void)rewardVideoDidClose:(OSETRewardVideoAd *)rewardVideoAd checkString:(NSString *)checkString {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoClosed" type:ATLogTypeExternal];
    [self.adStatusBridge atOnAdClosed:nil];
}
//激励视频播放结束
- (void)rewardVideoPlayEnd:(OSETRewardVideoAd *)rewardVideoAd checkString:(NSString *)checkString {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoFinish" type:ATLogTypeExternal];
    // 视频播放完成回调
    [self.adStatusBridge atOnAdVideoEnd:nil];
}

//激励视频开始播放
- (void)rewardVideoPlayStart:(OSETRewardVideoAd *)rewardVideoAd checkString:(NSString *)checkString {
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoShow" type:ATLogTypeExternal];
    // 广告展示成功回调
    [self.adStatusBridge atOnAdShow:nil];
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoStartPlaying" type:ATLogTypeExternal];
    // 视频开始播放回调
    [self.adStatusBridge atOnAdVideoStart:nil];
}
//激励视频奖励
- (void)rewardVideoOnReward:(OSETRewardVideoAd *)rewardVideoAd checkString:(NSString *)checkString {
    if (!rewardVideoAd.verify) { return; }
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoReward" type:ATLogTypeExternal];
    [self.adStatusBridge atOnRewardedVideoAdRewarded];
}

//激励视频播放出错
- (void)rewardVideoPlayError:(id)rewardVideoAd error:(NSError *)error{
    [ATAdLogger logMessage:@"ATMSRewardedVideoCustomEvent::msRewardVideoRenderFail" type:ATLogTypeExternal];
    [self.adStatusBridge atOnAdShowFailed:error extra:nil];
}
@end
