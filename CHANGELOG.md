### 7.1.1 (31-03-2021)
- iOS
   -  Added support to explicitly initialize the plugin instead of the default Info.plist initialization.

### 7.0.0 (26-02-2021)
- iOS
   -  Support added for Native iOS SDK version `7.0` and above.
   -  iOS Base plugin version dependency updated to `~>2.0.1`.
- Android 
    - Android Native SDK updated to support version `11.0.04` and above.
    - Update the payload structure for Push APIs.
- Added APIs to enable/disable SDK.
- Added push token generated callback listener.

### 6.1.4 (16-02-2021)
- Android artifacts use manven central instead of Jcenter.
    - Android Native SDK version 10.6.01
    - Android Plugin Base 1.2.01

### 6.1.3 (18-01-2021)
- iOS Base plugin version dependency updated to `~>1.2`.

### 6.1.2 (07-12-2020)
- Android Base plugin update for enabling native callback extension.
- Android Native SDK updated to `10.5.00`

### 6.1.1 (23-10-2020)
- Bugfix
    - iOS 
        - Payload sent in callback was incorrect, it was sent inside another "payload" key earlier.
    - Android
        - Events not being marked as non-interactive on Android

### 6.1.0 (21-09-2020)
- Android 
    - SDK updated to `10.4.00`
    - Migration to androidx namespace. 
    - Plugin Base updated to `1.1.00` 

### 6.0.00 (18-09-2020)
- MOEN-1588: Javascript methods for GDPR opt outs in Cordova
- MOEN-8342: Cordova SDK Update
- Removed APIs

|                                           Then                                           	|                                                       Now                                                      	|
|:----------------------------------------------------------------------------------------:	|:--------------------------------------------------------------------------------------------------------------:	|
| MoECordova#passToken(token)                                                              	| MoECardova#passFcmToken(token)                                                                                 	|
| MoECordova#pushPayload(pushPayload)                                                      	| MoECordova#passFcmPayload(pushPayload)                                                                         	|
| MoECordova#setExistingUser(isExisting)                                                   	| MoECordova#setAppStatus(status)                                                                                	|
| MoECordova#trackEvent(eventName, eventAttributes)                                        	| MoECordova#trackEvent(eventName, generalAttributes, locationAttributes, dataTimeAttributes , isNonInteractive) 	|
| MoECordova#setLogLevelForAndroid(loglevel)/setLogLevelForiOS(loglevel)                                               	| MoECordova#enableSDKLogs()                                                                                     	|
| MoECordova#setUserAttributeLocation(attributeName, attributeLatValue, attributeLonValue) 	| MoECordova#setUserLocation(latitude, longitude)                                                                	|
| MoECordova#setUserAttributeTimestamp(attributeName, epochTimeStampVal)                   	| MoECordova#setUserAttributeISODateString(attributeName, date)
