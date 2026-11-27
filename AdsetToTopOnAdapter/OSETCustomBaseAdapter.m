//
//  OSETCustomBaseAdapter.m
//  OSETATADemo
//
//  Created by Shens on 25/11/2025.
//

#import "OSETCustomBaseAdapter.h"
#import <math.h>


/** 竞价价格沿用人民币分；非法、负值或超出可表示范围的价格不回传。 */
static NSNumber *OSETBidPrice(id value) {
    if (![value isKindOfClass:NSString.class]) return nil;
    NSScanner *scanner = [NSScanner scannerWithString:value];
    double price = 0;
    if (![scanner scanDouble:&price] || !scanner.isAtEnd || !isfinite(price) || price < 0 || price >= (double)NSIntegerMax) return nil;
    return @(price);
}

@implementation OSETCustomBaseAdapter

#pragma mark - adapter init class name define
- (Class)initializeClassName {
    return [OSETCustomInitAdapter class];
}

- (nullable NSString *)osetSlotIdFromServerContent:(NSDictionary *)serverContent {
    for (NSString *key in @[@"slot_id", @"unit_id"]) {
        id value = serverContent[key];
        if ([value isKindOfClass:NSString.class] && [value length] > 0) {
            return value;
        }
    }
    return nil;
}

#pragma mark - tools
+ (NSMutableDictionary *)getC2SInfo:(NSInteger)ecpm {

    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];

    NSString *priceStr = [NSString stringWithFormat:@"%ld",ecpm];
#if DEBUG
    NSString *logOriginalString = [NSString stringWithFormat:@"MS:C2S Original priceStr :%@",priceStr];
    NSLog(@"hh DemoCustomBaseAdapter 获取到广告价格:%@", @"<redacted>");
#endif

    if ([priceStr doubleValue] < 0) {
        priceStr = @"0";
    }

    [infoDic AT_setDictValue:priceStr key:ATAdSendC2SBidPriceKey];
    [infoDic AT_setDictValue:@(ATBiddingCurrencyTypeCNYCents) key:ATAdSendC2SCurrencyTypeKey];

#if DEBUG
    NSString *logString = [NSString stringWithFormat:@"[Network:C2S]::MS::%@",infoDic];
    NSLog(@"hh DemoCustomBaseAdapter 获取到C2S信息:%@", @"<redacted>");
#endif
    return infoDic;
}

+ (NSMutableDictionary *)getLossInfoResult:(ATBidWinLossResult *)result {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    OSETBiddingFailureReason reason = OSETBiddingFailureReasonOther;
    switch (result.lossReasonType) {
        case ATBiddingLossWithLowPriceInNormal:
        case ATBiddingLossWithLowPriceInHB: reason = OSETBiddingFailureReasonLowBid; break;
        case ATBiddingLossWithBiddingTimeOut: reason = OSETBiddingFailureReasonTimeout; break;
        case ATBiddingLossWithExpire: reason = OSETBiddingFailureReasonExpired; break;
        case ATBiddingLossWithFloorFilter: reason = OSETBiddingFailureReasonBelowFloorPrice; break;
        default: break;
    }
    info[OSETBiddingInfoLossReasonKey] = @(reason);
    NSNumber *price = OSETBidPrice(result.winPrice);
    if (price) {
        info[OSETBiddingInfoWinPriceKey] = price;
        if (price.integerValue > 0) info[OSETBiddingInfoBiddingPriceKey] = @(price.integerValue);
    }
    return info;
}

+ (NSMutableDictionary *)getWinInfoResult:(ATBidWinLossResult *)result {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    NSNumber *price = OSETBidPrice(result.winPrice);
    if (price && price.integerValue > 0) info[OSETBiddingInfoBiddingPriceKey] = @(price.integerValue);
    NSNumber *secondPrice = OSETBidPrice(result.secondPrice);
    if (secondPrice) info[@"secondPrice"] = secondPrice;
    return info;
}

+ (void)reportBidResult:(ATBidWinLossResult *)result forAd:(id)ad {
    if (![result isKindOfClass:ATBidWinLossResult.class] ||
        (![ad isKindOfClass:OSETBaseAd.class] && ![ad isKindOfClass:OSETBaseView.class])) return;
    if (result.bidResultType != ATBidWinLossResultTypeWin && result.bidResultType != ATBidWinLossResultTypeLoss) return;
    BOOL win = result.bidResultType == ATBidWinLossResultTypeWin;
    NSMutableDictionary *info = win ? [self getWinInfoResult:result] : [self getLossInfoResult:result];
    info[OSETBiddingInfoExtraKey] = @{@"mediation": @"TopOn", @"win": @(win)};
    NSDictionary *snapshot = info.copy;
    dispatch_block_t report = ^{
        if (win && [ad respondsToSelector:@selector(reportBiddingWinWithInfo:)]) [ad reportBiddingWinWithInfo:snapshot];
        else if (!win && [ad respondsToSelector:@selector(reportBiddingLossWithInfo:)]) [ad reportBiddingLossWithInfo:snapshot];
    };
    if (NSThread.isMainThread) report();
    else dispatch_async(dispatch_get_main_queue(), report);
}

@end
