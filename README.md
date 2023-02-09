# AlexMaxDemo_iOS

# 集成

## 一. 接入TopOn SDK

请参考[TopOn SDK集成文档](https://docs.toponad.com/#/zh-cn/android/android_doc/android_sdk_config_access)接入TopOn SDK，建议接入**TopOn v6.1.65及以上版本**



## 二. 引入Alex Adapter

1. Max 文件夹下代码拖入项目中

<img width="987" alt="截屏2023-02-08 13 52 41" src="https://user-images.githubusercontent.com/124124788/217446269-c866b212-242a-425a-814a-f7aa14571be8.png">

2.Podfile 添加以下指令, 然后执行 pod install 

  pod 'AppLovinSDK','11.6.0'
  
  pod 'AnyThinkiOS','6.1.65'



### 三. 后台配置

1、按照SDK对接文档接入同时，需要在后台添加自定义广告平台

![image1](https://user-images.githubusercontent.com/124124788/217697673-6991552e-d4de-466d-976c-cc3903cdc60e.png)


2、选择【自定义广告平台】，填写广告平台名称、账号名称，按照SDK的对接文档填写Adapter.  ps:(广告平台名称需要写上Max，便于区分广告平台，建议名称格式：Max_XXXXX)

![image2](https://user-images.githubusercontent.com/124124788/217697688-3bc7cc6b-ea95-4887-948c-7eeb30402fbe.png)


3、记录广告平台ID

![image3](https://user-images.githubusercontent.com/124124788/217697699-a08a413b-0e91-4dcb-bb44-56a1ef4c0e39.png)

4、广告平台添加完成后，需要等待15min左右，再添加广告源（添加广告源时按照对应样式配置即可）

5、可编辑广告平台设置，选择是否开通报表api并拉取数据





