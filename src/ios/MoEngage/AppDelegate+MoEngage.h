
//
//  AppDelegate+MoEngage.h
//  MoEngage
//
//  Created by Chengappa C D on 18/08/2016.
//  Copyright MoEngage 2016. All rights reserved.
//

#import "AppDelegate.h"
#import <MoEPluginBase/MoEPluginBase.h>

@interface AppDelegate (MoEngageCordova) <MoEPluginBridgeDelegate>

+ (void)swizzleMethodWithClass:(Class)class originalSelector:(SEL)originalSelector andSwizzledSelector:(SEL)swizzledSelector;

//Application LifeCycle methods
- (BOOL)moengage_swizzled_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/// Initialization Methods to setup SDK with MOSDKConfig instance instead of from Info.plist file
/// @param sdkConfig MOSDKConfig instance for SDK configuration
/// @param launchOptions Launch Options dictionary
/// @warning Make sure to call only one of the initialization methods available (set DISABLE_PLIST_INITIALIZATION to true under MoEngage dict in info.plist)
/// @version 7.1.1 and above
- (void)initializeMoEngageSDKWithConfig:(MOSDKConfig*)sdkConfig andLaunchOptions:(NSDictionary*)launchOptions;

/// Initialization Methods to setup SDK with MOSDKConfig instance instead of from Info.plist file
/// @param sdkConfig MOSDKConfig instance for SDK configuration
/// @param isSdkEnabled Bool indicating if SDK is Enabled/Disabled, refer (link)[https://docs.moengage.com/docs/gdpr-compliance-1#enabledisable-sdk] for more info
/// @param launchOptions Launch Options dictionary
/// @warning Make sure to call only one of the initialization methods available (set DISABLE_PLIST_INITIALIZATION to true under MoEngage dict in info.plist)
/// @version 7.1.1 and above
- (void)initializeMoEngageSDKWithConfig:(MOSDKConfig*)sdkConfig withSDKState:(BOOL)isSdkEnabled andLaunchOptions:(NSDictionary*)launchOptions;
@end
