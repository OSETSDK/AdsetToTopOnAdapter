//
//  OSETCustomerToNativeAdapter.m
//  YhsADSProject
//
//  Created by Shens on 20/3/2025.
//

#import "OSETCustomerToNativeAdapter.h"
#import "OSETNativeCustomEvent.h"
#import "OSETNativeCustomRenderer.h"


@interface OSETCustomerToNativeAdapter ()<OSETNativeAdDelegate>

@property (nonatomic, strong) OSETNativeCustomEvent *customEvent;
@property (nonatomic, strong) OSETNativeAd *nativeAd;
@property (nonatomic, strong) OSETNativeDataAd *nativeDataAd;

@end


@implementation OSETCustomerToNativeAdapter

#pragma mark - init
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    self.customEvent.biddingAd = nil;

    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize size = CGSizeZero;
        if ([argument.localInfoDic[kATExtraInfoNativeAdSizeKey] respondsToSelector:@selector(CGSizeValue)]) {
            size = [argument.localInfoDic[kATExtraInfoNativeAdSizeKey] CGSizeValue];
        }
        UIViewController *rootVC = argument.viewController;
        if (rootVC == nil) {
            rootVC = [ATGeneralManage getCurrentViewControllerWithWindow:nil];
        }
        id express = argument.serverContentDic[@"isExpressAd"];
        if ([express respondsToSelector:@selector(boolValue)] && [express boolValue]) {
            NSString *osetSlotId = [self osetSlotIdFromServerContent:argument.serverContentDic];
#if DEBUG
            NSLog(@"hh [OSETTopOnAdapter] %@ 后台下发 slotId=%@", NSStringFromClass(self.class), @"<redacted>");
#endif
            self.nativeAd = [[OSETNativeAd alloc]initWithSlotId:osetSlotId size:size rootViewController:rootVC];
            self.nativeAd.delegate = self.customEvent;
            [self.nativeAd loadAdData];
        }else{
            NSString *osetSlotId = [self osetSlotIdFromServerContent:argument.serverContentDic];
#if DEBUG
            NSLog(@"hh [OSETTopOnAdapter] %@ 后台下发 slotId=%@", NSStringFromClass(self.class), @"<redacted>");
#endif
            self.nativeDataAd = [[OSETNativeDataAd alloc]initWithSlotId:osetSlotId size:size rootViewController:rootVC];
            self.nativeDataAd.delegate = self.customEvent;
            [self.nativeDataAd loadAdData];
        }

    });
}

#pragma mark - C2S Win Loss
- (void)didReceiveBidResult:(ATBidWinLossResult *)result {
    [OSETCustomBaseAdapter reportBidResult:result forAd:self.customEvent.biddingAd];
}





#pragma mark - lazy
- (OSETNativeCustomEvent *)customEvent{
    if (_customEvent == nil) {
        _customEvent = [[OSETNativeCustomEvent alloc] init];
        _customEvent.adStatusBridge = self.adStatusBridge;
    }
    return _customEvent;
}



@end
