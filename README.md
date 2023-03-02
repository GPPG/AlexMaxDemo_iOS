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

3.Adapter中使用的Key说明如下：

```
"sdk_key": 广告平台的SDK Key
"unit_id": 广告平台的广告位ID
"unit_type": 广告位类型，0: Banner, 1: MREC
```

### 三. 后台配置

1、按照SDK对接文档接入同时，需要在后台添加自定义广告平台

![image1](https://user-images.githubusercontent.com/124124788/217697673-6991552e-d4de-466d-976c-cc3903cdc60e.png)


2、选择【自定义广告平台】，填写广告平台名称、账号名称，按照SDK的对接文档填写Adapter.  
   ps:(广告平台名称需要写上Max，便于区分广告平台，建议名称格式：Max_XXXXX)

![image2](https://user-images.githubusercontent.com/124124788/217697688-3bc7cc6b-ea95-4887-948c-7eeb30402fbe.png)


3、记录广告平台ID

![image3](https://user-images.githubusercontent.com/124124788/217697699-a08a413b-0e91-4dcb-bb44-56a1ef4c0e39.png)

4、广告平台添加完成后，需要等待15min左右，再添加广告源（添加广告源时按照对应样式配置即可）

5、可编辑广告平台设置，选择是否开通报表api并拉取数据



# integration

## 1. Access TopOn SDK

Please refer to [TopOn SDK Integration Documentation](https://docs.toponad.com/#/zh-cn/android/android_doc/android_sdk_config_access) to access TopOn SDK, it is recommended to access **TopOn v6.1.65 and above**



## 2. Introduce Alex Adapter

1. Drag the code under the Max folder into the project

<img width="987" alt="screenshot 2023-02-08 13 52 41" src="https://user-images.githubusercontent.com/124124788/217446269-c866b212-242a-425a-814a-f7aa14571be8.png ">

2. Add the following instructions to Podfile, and then execute pod install

   pod 'AppLovinSDK', '11.6.0'
  
   pod 'AnyThinkiOS', '6.1.65'

3. The Key used in the Adapter is described as follows:

```
"sdk_key": SDK Key of the advertising platform
"unit_id": the advertising unit ID of the advertising platform
"unit_type": Ad unit type, 0: Banner, 1: MREC
```


### 3. Background configuration

1. You need to add a Custom Network.

![1](https://user-images.githubusercontent.com/124124788/222124007-1a773ce8-aa7a-4a36-842b-9a67577327bb.png)


2. Choose "Custom Network". Fill in Network Name/Account Name and Adapter's class names according to the contents above.
*Network Name needs to contain Max to distinguish the Network. Example: Max_XXXXX,

![2](https://user-images.githubusercontent.com/124124788/222124025-dd7700ad-3190-4c30-a63f-2c82e13005bb.png)


3. Mark the Network Firm ID
 
![3](https://user-images.githubusercontent.com/124124788/222124037-0f4ab1fd-9295-411e-b08b-21d2ac2667b3.png)

4. You can add the Ad Sources after adding the Network.

5. You can edit the placement setting to fill the report api key.

