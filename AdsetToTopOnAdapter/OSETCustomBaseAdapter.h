//
//  OSETCustomBaseAdapter.h
//  OSETATADemo
//
//  Created by Shens on 25/11/2025.
//

#import <Foundation/Foundation.h>
#import "OSETCustomAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSETCustomBaseAdapter : ATBaseMediationAdapter

/// 优先读取后台 slot_id，兼容旧配置 unit_id。
- (nullable NSString *)osetSlotIdFromServerContent:(NSDictionary *)serverContent;

/** 将竞价结果回传到本次广告对象，非主线程调用会转到主线程。 */
+ (void)reportBidResult:(ATBidWinLossResult *)result forAd:(nullable id)ad;

//C2S flow needed
+ (NSMutableDictionary *)getLossInfoResult:(ATBidWinLossResult *)winLossResult;

//C2S flow needed
+ (NSMutableDictionary *)getWinInfoResult:(ATBidWinLossResult *)winLossResult;

//C2S flow needed
+ (NSMutableDictionary *)getC2SInfo:(NSInteger)ecpm;
@end

NS_ASSUME_NONNULL_END
