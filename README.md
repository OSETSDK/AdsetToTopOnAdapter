# AdsetToTopOnAdapter

Adset 的 TopOn 适配器。版本 `8.0.0.0`，最低支持 iOS 13.0。

## Pod 接入

[Git 仓库](https://github.com/OSETSDK/AdsetToTopOnAdapter) · [Podspec](https://github.com/OSETSDK/AdsetToTopOnAdapter/blob/main/AdsetToTopOnAdapter.podspec)

在 Podfile 中配置提供 Adset 正式版本的 Specs 源，并通过适配器 Git 地址和版本 tag 接入：

```ruby
source 'https://github.com/OSETSDK/Adset.git'
source 'https://cdn.cocoapods.org/'
platform :ios, '13.0'
use_frameworks! :linkage => :static

target 'YourApp' do
  pod 'Adset', '>= 8.0.0.0'
  pod 'AdsetToTopOnAdapter', :git => 'https://github.com/OSETSDK/AdsetToTopOnAdapter.git', :tag => '8.0.0.0'
  pod 'TPNMediationAdxSmartdigimktAdapter', '6.5.85.2.1'
end
```

## 依赖

| Pod | 最低版本 |
| --- | --- |
| [Adset](https://github.com/OSETSDK/Adset) | `8.0.0.0` |
| `TPNiOS` | `6.6.11` |

TPNiOS 6.6.11 初始化需要 ADX 组件及资源，以上示例同时引入 `TPNMediationAdxSmartdigimktAdapter`。

## 自定义 ADN 配置

a01、在 TopOn 后台的广告平台管理中新增自定义广告平台“奇点”，按下表填写 iOS 适配器类名。

a02、添加应用维度参数 `app_id`（必填），值为奇点媒体 App ID；添加广告源维度参数 `slot_id`（必填），值为奇点对应格式的广告位 ID。旧配置 `unit_id` 仍可用，两者同时存在时优先非空 `slot_id`。奇点初始化不需要 App Key。

a03、信息流模板添加广告源参数 `isExpressAd: true`；自渲染设为 false 或不填，两种模式共用同一适配类。

a04、在聚合管理中为对应格式添加奇点广告源，选择竞价接入并填写上述参数。保存并等待平台配置生效后，应用通过 TopOn 聚合广告位 ID 请求广告。

| 用途 | iOS 适配器类名 |
| --- | --- |
| 初始化 | `OSETCustomInitAdapter` |
| 开屏 | `OSETCustomerToSplashAdapter` |
| 插屏 | `OSETCustomerToInterstitialAdapter` |
| 激励视频 | `OSETCustomerToRewardAdapter` |
| Banner | `OSETCustomerToBannerAdapter` |
| 信息流模板／自渲染 | `OSETCustomerToNativeAdapter` |

类名不加 `.h`／`.m` 后缀。平台自身 App ID／App Key 用于初始化聚合平台，与奇点渠道参数分别配置。

模板广告源参数示例（自渲染设为 false 或省略该字段）：

```json
{ "isExpressAd": true }
```

后台操作参考 [第三方 ADN 接入说明](https://doc.shenshiads.com/IOS.html#topon适配器接入)，Pod 名称和参数兼容规则以本文为准。

## 使用要求

- 宿主保留 `-ObjC` 链接参数，按平台文档完成聚合 SDK 初始化。
- 加载成功后再展示；在主线程传入有效的控制器或窗口。
- Taku 与 TopOn 适配器含同名类，同一个 App target 仅选择一套。

许可证：[Apache 2.0](LICENSE)。
