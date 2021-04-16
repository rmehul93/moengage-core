
//
//  AppDelegate+MoEngage.m
//  MoEngage
//
//  Created by Chengappa C D on 18/08/2016.
//  Copyright MoEngage 2016. All rights reserved.
//


#import "AppDelegate+MoEngage.h"
#import <objc/runtime.h>
#import "MoECordova.h"
#import "MoECordovaConstants.h"
#import <MoEPluginBase/MoEPluginBase.h>

static BOOL pluginInitialized = false;

@implementation AppDelegate (MoEngageCordova)

#pragma mark- Load Method

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //ApplicationDidFinshLaunching Method
        SEL appDidFinishLaunching = @selector(application:didFinishLaunchingWithOptions:);
        SEL swizzledAppDidFinishLaunching = @selector(moengage_swizzled_application:didFinishLaunchingWithOptions:);
        if ([self shouldInitializeSDKConfigFromPlist]) {
          [self swizzleMethodWithClass:class originalSelector:appDidFinishLaunching andSwizzledSelector:swizzledAppDidFinishLaunching];
        }
    });
}


#pragma mark- Swizzle Method

+ (void)swizzleMethodWithClass:(Class)class originalSelector:(SEL)originalSelector andSwizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark- Application LifeCycle methods

- (BOOL)moengage_swizzled_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self initializeMoEngageSDKWithConfig:[self fetchSDKConfig] withSDKState:[[MoEngageCore sharedInstance] isSDKEnabled]  andLaunchOptions: launchOptions];
    return [self moengage_swizzled_application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)initializeMoEngageSDKWithConfig:(MOSDKConfig*)sdkConfig andLaunchOptions:(NSDictionary*)launchOptions {
    [self initializeMoEngageSDKWithConfig:sdkConfig withSDKState:[[MoEngageCore sharedInstance] isSDKEnabled] andLaunchOptions: launchOptions];
}

- (void)initializeMoEngageSDKWithConfig:(MOSDKConfig*)sdkConfig withSDKState:(BOOL)isSdkEnabled andLaunchOptions:(NSDictionary*)launchOptions {
    if (!pluginInitialized) {
      [MoEPluginBridge sharedInstance].bridgeDelegate = self;
   
      if (sdkConfig.moeAppID == nil || sdkConfig == nil)
      {
          return;
      }
        
      sdkConfig.pluginIntegrationType = CORDOVA;
      sdkConfig.pluginIntegrationVersion = SDKVersion;
      
      [[MoEPluginInitializer sharedInstance] intializeSDKWithConfig:sdkConfig withSDKState:isSdkEnabled andLaunchOptions: launchOptions];

      pluginInitialized = true;
    }
}

+ (BOOL) shouldInitializeSDKConfigFromPlist {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    if ([infoDict objectForKey: kMoEngage] != nil && [infoDict objectForKey: kMoEngage] != [NSNull null]) {
        NSDictionary* moeDict = [infoDict objectForKey: kMoEngage];
        if ([moeDict objectForKey: kDisablePlistInitialization] != nil && [moeDict objectForKey: kDisablePlistInitialization] != [NSNull null]) {
        BOOL shouldSDKInitialize = [moeDict getBooleanForKey: kDisablePlistInitialization];
        if (shouldSDKInitialize == true) {
            return false;
         }
      }
    }
    
    return true;
}

-(MOSDKConfig*)fetchSDKConfig {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    MOSDKConfig *sdkConfig = [[MoEngage sharedInstance] getDefaultSDKConfiguration];
   
    if ( [infoDict objectForKey: kMoEngage] != nil && [infoDict objectForKey: kMoEngage] != [NSNull null]) {
        NSDictionary* moeDict = [infoDict objectForKey: kMoEngage];
        if ([moeDict objectForKey: kAppId] != nil && [moeDict objectForKey:kAppId] != [NSNull null]) {
           
            NSString *appId = [moeDict objectForKey: kAppId];
           
            if (appId.length > 0) {
                sdkConfig.moeAppID = appId;
            }
            else{
                NSLog(@"%@", kInvalidAppIdAlert);
                return nil;
            }
        }
    
        if ([moeDict objectForKey: kDataCenter] != nil && [moeDict objectForKey:kDataCenter] != [NSNull null]) {
            sdkConfig.moeDataCenter = [self getDataCenterFromString: [moeDict objectForKey: kDataCenter]];
        }
        
        if ([moeDict objectForKey:kAppGroupId] != nil && [moeDict objectForKey:kAppGroupId] != [NSNull null]) {
             sdkConfig.appGroupID = [moeDict objectForKey:kAppGroupId];
        }
        
        if ([moeDict objectForKey:kDisablePeriodicFlush] != nil && [moeDict objectForKey:kDisablePeriodicFlush] != [NSNull null]) {
            sdkConfig.analyticsDisablePeriodicFlush = [moeDict getBooleanForKey:kDisablePeriodicFlush];
        }
        
        if ([moeDict objectForKey:kPeriodicFlushDuration] != nil && [moeDict objectForKey:kPeriodicFlushDuration] != [NSNull null]) {
             sdkConfig.analyticsPeriodicFlushDuration = [moeDict getIntegerForKey:kPeriodicFlushDuration];
        }
        
        if ([moeDict objectForKey:kEncryptNetworkRequests] != nil && [moeDict objectForKey:kEncryptNetworkRequests] != [NSNull null]) {
             sdkConfig.encryptNetworkRequests = [moeDict getBooleanForKey:kEncryptNetworkRequests];
        }
        
        if ([moeDict objectForKey:kOptOutDataTracking] != nil && [moeDict objectForKey:kOptOutDataTracking] != [NSNull null]) {
             sdkConfig.optOutDataTracking = [moeDict getBooleanForKey:kOptOutDataTracking];
        }
        
        if ([moeDict objectForKey:kOptOutPushNotifications] != nil && [moeDict objectForKey:kOptOutPushNotifications] != [NSNull null]) {
             sdkConfig.optOutPushNotification = [moeDict getBooleanForKey:kOptOutPushNotifications];
        }
        
        if ([moeDict objectForKey:kOptOutInApp] != nil && [moeDict objectForKey:kOptOutInApp] != [NSNull null]) {
             sdkConfig.optOutInAppCampaign = [moeDict getBooleanForKey:kOptOutInApp];
        }
        
        if ([moeDict objectForKey:kOptOutIDFATracking] != nil && [moeDict objectForKey:kOptOutIDFATracking] != [NSNull null]) {
             sdkConfig.optOutIDFATracking = [moeDict getBooleanForKey:kOptOutIDFATracking];
        }
        
        if ([moeDict objectForKey:kOptOutIDFVTracking] != nil && [moeDict objectForKey:kOptOutIDFVTracking] != [NSNull null]) {
             sdkConfig.optOutIDFVTracking = [moeDict getBooleanForKey:kOptOutIDFVTracking];
        }
    }
    
    return  sdkConfig;
}

- (MODataCenter)getDataCenterFromString:(NSString*)stringVal {
    MODataCenter dataCenter = DATA_CENTER_01;
    
    if ([stringVal  isEqual:kDataCenter1])
    {
        dataCenter = DATA_CENTER_01;
    }
    else if ([stringVal  isEqual:kDataCenter2])
    {
        dataCenter = DATA_CENTER_02;
    }
    else if ([stringVal  isEqual:kDataCenter3])
    {
        dataCenter = DATA_CENTER_03;
    }
    else
    {
        NSLog(@"%@", kInvalidDataCenterAlert);
    }
    
    return dataCenter;
}

#pragma mark- Utility methods

- (id) getCommandInstance:(NSString*)className
{
    return [self.viewController getCommandInstance:className];
}
     
- (void)sendMessageWithName:(NSString *)name andPayload:(NSDictionary *)payloadDict {
    MoECordova* cordovaHandler = [self getCommandInstance:@"MoEngage"];
    
    if (cordovaHandler) {
        NSMutableDictionary* message;
        if (payloadDict && [payloadDict validObjectForKey:@"payload"]) {
            NSDictionary* payload = [payloadDict validObjectForKey:@"payload"];
            message = [[NSMutableDictionary alloc] initWithDictionary:payload];
        }
        else{
            message = [NSMutableDictionary dictionary];
        }
        [message setObject:name forKey:@"type"];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:message];
        [pluginResult setKeepCallbackAsBool:YES];
        [cordovaHandler.commandDelegate sendPluginResult:pluginResult callbackId:cordovaHandler.callbackId];
    }
}
@end


