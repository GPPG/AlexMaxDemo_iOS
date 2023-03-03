# AlexMaxDemo_iOS

# integration

## 1. Access TopOn SDK

Please refer to [TopOn SDK Integration Documentation](https://docs.toponad.com/#/en-us/ios/GetStarted/TopOn_Get_Started) to access TopOn SDK, it is recommended to access **TopOn v6.1.65 and above**



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

