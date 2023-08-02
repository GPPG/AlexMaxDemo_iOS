# AlexMaxDemo_iOS

# integration

## 1. Access TopOn SDK

Please refer to [TopOn SDK Integration Documentation](https://docs.toponad.com/#/en-us/ios/GetStarted/TopOn_Get_Started) to access TopOn SDK, it is recommended to access **TopOn v6.1.65 and above**

### 1.1 Cocoapods

```
// This article uses version 6.2.34 as an example.
    pod 'AnyThinkiOS','6.2.34'
```

## 2. Import Mediation and Adapter

### 2.1 Introduce Alex Adapter

Drag the source code or MaxSDKAdapter.framework from the Max folder into the project.

<img width="987" alt="截屏2023-02-08 13 52 41" src="https://user-images.githubusercontent.com/124124788/217446269-c866b212-242a-425a-814a-f7aa14571be8.png">

![Max_lib](https://github.com/Alex-only/AlexMaxDemo_iOS/assets/124124788/53747ba4-bd5b-41ef-8154-d355dc2213ad)

### 2.2 Introduce Max Mediation

Max has Mediation for different advertising platforms. It is suggested that developers import Mediation for advertising that needs to be interfacing. You can download resource pack from Max's [github](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/tree/master) and switch tags to find the corresponding Max version.

The file extracted after downloading is shown in the figure. In this article, AdColony is used as an example.

![Max_Mediation](https://github.com/Alex-only/AlexMaxDemo_iOS/assets/124124788/b603e84e-ef63-43d1-a618-ac544d641db6)

We can find the AdColonyMediation dependent warehouse name and corresponding AdColonySDK version number uploaded by Max to Cocoapods from the figure. As the picture shows:

![Max_Mediation_pod](https://github.com/Alex-only/AlexMaxDemo_iOS/assets/124124788/59737d8c-7794-41db-9a8f-c6782f318185)

This way we can add pod code to the Podfile file in your project.

```
pod 'AppLovinMediationAdColonyAdapter','4.9.0.0.4'
```
### 2.3 Introduce Max Mediation SDK

Add the following command to the Podfile and then execute pod install. This step will introduce the SDK for the Max aggregation platform of your choice into the project. This example uses AdColony as an example.

1. You can import the Max Mediation SDK using the pod dependency of TopOn's adapter.

```
pod 'AnyThinkiOS/AnyThinkAdColonyAdapter','6.2.34'
```

2. Use the advertising platform's SDK.

```
pod 'AdColony','4.9.0'
```

You only need to choose one of the two options above.

## 3 Introduce The Key

The Key used in the Adapter is described as follows:

```
"sdk_key": SDK Key of the advertising platform
"unit_id": the advertising unit ID of the advertising platform
"unit_type": Ad unit type, 0: Banner, 1: MREC
```


## 4. Background configuration

1. You need to add a Custom Network.

![1](https://user-images.githubusercontent.com/124124788/222124007-1a773ce8-aa7a-4a36-842b-9a67577327bb.png)


2. Choose "Custom Network". Fill in Network Name/Account Name and Adapter's class names according to the contents above.
*Network Name needs to contain Max to distinguish the Network. Example: Max_XXXXX,

The files used in the SDK for this article are named:

Interstitial：AlexMaxInterstitialAdapter<br/>
Banner：AlexMaxBannerAdapter<br/>
Native：AlexMaxNativeAdapter<br/>
RewardedVideo：AlexMaxRewardedVideoAdapter<br/>
Splash：AlexMaxSplashAdapter<br/>

If the developer has modified the file name in the source code behind, please use the modified name to fill in the background.

![2](https://user-images.githubusercontent.com/124124788/222124025-dd7700ad-3190-4c30-a63f-2c82e13005bb.png)


3. Mark the Network Firm ID

![3](https://user-images.githubusercontent.com/124124788/222124037-0f4ab1fd-9295-411e-b08b-21d2ac2667b3.png)

4. You can add the Ad Sources after adding the Network.

5. You can edit the placement setting to fill the report api key.

## 5. Used in Unity

. We just need to put MaxSDKAdapter framework is imported into the path of ` Assets/AnyThinkAds/Plugins/iOS `, as shown:

![Unity_Max_Podfile_1](https://github.com/Alex-only/AlexMaxDemo_iOS/assets/124124788/266b34ab-6f1c-4878-bdb1-bf8a41c44ee3)


Then find the desired Mediation according to 2.2 of Step 2 above. In this paper, AdColony Mediation is used as an example to add it in the Podfile file of Xcode. After the addition, pod install is used to rely on it.

```
  pod 'AnyThinkiOS', '6.2.34'
  pod 'AnyThinkiOS/AnyThinkAdColonyAdapter','6.2.34'
  pod 'AppLovinMediationAdColonyAdapter','4.9.0.0.4'
#  pod 'AdColony','4.9.0'
```

![Unity_Max_Podfile](https://github.com/Alex-only/AlexMaxDemo_iOS/assets/124124788/000a21db-b325-4669-9064-ae47b70c5e8d)


## 5. Used in Flutter

We just need to import MaxSDKAdapter.framework into the path `plugins/anythink_sdk/ios/ThirdPartySDK` as shown in the figure, and then find the desired Mediation according to 2.2 of Step 2 above. This paper takes AdColony Mediation as an example.

![Flutter_Max_setting](https://github.com/Alex-only/AlexMaxDemo_iOS/assets/124124788/dde19de8-e04a-40e5-93ab-24f97411967f)

