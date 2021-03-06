//
//  MoECordovaConstants.m
//  MoEngage
//
//  Created by Rakshitha on 10/02/21.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import "MoECordovaConstants.h"

NSString* const SDKProxyKey                               = @"MoEngageAppDelegateProxyEnabled";
NSString* const SDKVersion                                = @"7.1.1";

// Info.plist Keys
NSString* const kMoEngage                                 = @"MoEngage";
NSString* const kAppId                                    = @"MoEngage_APP_ID";
NSString* const kDataCenter                               = @"DATA_CENTER";
NSString* const kAppGroupId                               = @"APP_GROUP_ID";
NSString* const kDisablePeriodicFlush                     = @"DISABLE_PERIODIC_FLUSH";
NSString* const kPeriodicFlushDuration                    = @"PERIODIC_FLUSH_DURATION";
NSString* const kEncryptNetworkRequests                   = @"ENCRYPT_NETWORK_REQUESTS";
NSString* const kOptOutDataTracking                       = @"OPT_OUT_DATA_TRACKING";
NSString* const kOptOutPushNotifications                  = @"OPT_OUT_PUSH_NOTIFICATIONS";
NSString* const kOptOutInApp                              = @"OPT_OUT_INAPP";
NSString* const kOptOutIDFATracking                       = @"OPT_OUT_IDFA_TRACKING";
NSString* const kOptOutIDFVTracking                       = @"OPT_OUT_IDFV_TRACKING";
NSString* const kDisablePlistInitialization               = @"DISABLE_PLIST_INITIALIZATION";

//DataCenter Constants
NSString* const kDataCenter1                              = @"DATA_CENTER_01";
NSString* const kDataCenter2                              = @"DATA_CENTER_02";
NSString* const kDataCenter3                              = @"DATA_CENTER_03";

NSString* const kInvalidAppIdAlert                        = @"MoEngage - Provide the APP ID for your MoEngage App in Info.plist for key MoEngage_APP_ID to proceed. To get the AppID login to your MoEngage account, after that go to Settings -> App Settings. You will find the App ID in this screen.";
NSString* const kInvalidDataCenterAlert                   = @"MoEngage - Invalid DataCenter";
