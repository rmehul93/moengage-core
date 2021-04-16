
//
//  MoECordova.m
//  MoEngage
//
//  Created by Chengappa C D on 27/07/2016.
//  Copyright MoEngage 2016. All rights reserved.
//

#import "MoECordova.h"
#import <MoEPluginBase/MoEPluginBase.h>

@implementation MoECordova

- (void)init:(CDVInvokedUrlCommand*)command;
{
    [self.commandDelegate runInBackground:^ {
        NSLog(@"MoECordova register called");
        self.callbackId = command.callbackId;
        [[MoEPluginBridge sharedInstance] pluginInitialized];
    }];
}

#pragma mark- Set AppStatus INSTALL/UPDATE

- (void)appStatus:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
            NSDictionary* appStatusDict = [command.arguments objectAtIndex:0];
            [[MoEPluginBridge sharedInstance] setAppStatus:appStatusDict];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"App Status tracked"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

#pragma mark- Track Event

- (void)trackEvent:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
            NSDictionary* trackEventDict = [command.arguments objectAtIndex:0];
            if (trackEventDict != nil) {
                [[MoEPluginBridge sharedInstance] trackEventWithPayload:trackEventDict];
                NSString* message = [NSString stringWithFormat:@"%@ tracked", trackEventDict];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Event payload was null"];
            }
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

#pragma mark- Set User Attributes

- (void)setUserAttribute:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        
        [self.commandDelegate runInBackground:^{
            NSDictionary* userAttributeDict = [command.arguments objectAtIndex:0];
            if (userAttributeDict!=nil) {
                [[MoEPluginBridge sharedInstance] setUserAttributeWithPayload:userAttributeDict];
                NSString* message = [NSString stringWithFormat:@"User attribute tracked %@", userAttributeDict];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
            }
            else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"User Attribute value was null"];
            }
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)setAlias:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
            NSDictionary* aliasDict = [command.arguments objectAtIndex:0];
            if (aliasDict != nil) {
                [[MoEPluginBridge sharedInstance] setAlias:aliasDict];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Set Alias used to update User Attribute Unique ID"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Alias argument not sent correctly"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

#pragma mark- Reset method
- (void)logout:(CDVInvokedUrlCommand*)command{
    [[MoEPluginBridge sharedInstance] resetUser];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark- Push Registration
- (void)registerForPushNotification:(CDVInvokedUrlCommand*)command{
    [[MoEPluginBridge sharedInstance] registerForPush];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark- Show InApp method
- (void)showInApp:(CDVInvokedUrlCommand*)command{
    [[MoEPluginBridge sharedInstance] showInApp];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)selfHandledInApp:(CDVInvokedUrlCommand*)command{
    [[MoEPluginBridge sharedInstance] getSelfHandledInApp];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)selfHandledCallback:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
            NSDictionary* selfHandledDict = [command.arguments objectAtIndex:0];
            if (selfHandledDict != nil) {
                [[MoEPluginBridge sharedInstance] updateSelfHandledInAppStatusWithPayload:selfHandledDict];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Self Handled Callback called successfully"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Self Handled Callback argument not sent correctly"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)appContext:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
            NSDictionary* appContextDict = [command.arguments objectAtIndex:0];
            if (appContextDict != nil) {
                [[MoEPluginBridge sharedInstance] setInAppContexts:appContextDict];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Set InApp Context called successfully"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Set InApp Context argument not sent correctly"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)resetAppContext:(CDVInvokedUrlCommand*)command{
    [[MoEPluginBridge sharedInstance] invalidateInAppContexts];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


#pragma mark- OptOut methods

- (void)optOutTracking:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
            NSDictionary* optOutDict = [command.arguments objectAtIndex:0];
            if (optOutDict != nil) {
                [[MoEPluginBridge sharedInstance] optOutTracking:optOutDict];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OptOut Tracking called successfully"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"OptOut Tracking argument not sent correctly"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

#pragma mark- Enable Logs

- (void)enableSDKLogs:(CDVInvokedUrlCommand*)command{
    [[MoEPluginBridge sharedInstance] enableLogs];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark- GeoFence Monitoring
- (void)startGeofenceMonitoring:(CDVInvokedUrlCommand*)command{
    [[MoEPluginBridge sharedInstance] startGeofenceMonitoring];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark- Unused methods

- (void)passToken:(CDVInvokedUrlCommand*)command{
    NSString* message = @"Not available for iOS";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)passPayload:(CDVInvokedUrlCommand*)command{
    NSString* message = @"Not available for iOS";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark- Enable/Disable SDK

- (void)updateSDKState:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult* pluginResult = nil;
    if (command.arguments.count >=1) {
        [self.commandDelegate runInBackground:^{
            NSDictionary* sdkStateDict = [command.arguments objectAtIndex:0];
            [[MoEPluginBridge sharedInstance] updateSDKState:sdkStateDict];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"SDK Status tracked"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Insufficient arguments"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

@end
