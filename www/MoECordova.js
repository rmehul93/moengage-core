var exec = require('cordova/exec');

var MoECordova = function() {

    this._handlers = {
        'onPushClick': [],
        'onPushTokenGenerated':[],
        'onInAppShown': [],
        'onInAppClick': [],
        'onInAppDismiss': [],
        'onInAppCustomAction': [],
        'onInAppSelfHandle': []
    };
    var that =  this;
    var success = function(msg) {
        console.log("MoECordova() : success");
        if (msg) {
          console.log(JSON.stringify(msg));
        if (msg.type === 'MoEPushClicked') {
            that.emit('onPushClick',msg);
        }else if (msg.type === 'MoEPushTokenGenerated') {
            that.emit('onPushTokenGenerated',msg);
        }else if (msg.type === 'MoEInAppCampaignShown') {
            that.emit('onInAppShown',msg);
        }else if (msg.type === 'MoEInAppCampaignClicked') {
            that.emit('onInAppClick',msg);
        }else if (msg.type === 'MoEInAppCampaignDismissed') {
            that.emit('onInAppDismiss',msg);
        }else if (msg.type === 'MoEInAppCampaignCustomAction') {
            that.emit('onInAppCustomAction',msg);
        }else if (msg.type === 'MoEInAppCampaignSelfHandled') {
            that.emit('onInAppSelfHandle',msg);
        }
    }
}
var fail = function () {
    console.log("MoECordova() : fail");
}
exec(success, fail, 'MoEngage', 'init', [{"init":"init"}]);
}


/**
 * Tells the SDK whether this is a migration or a fresh installation.
 * <b>Not calling this method will STOP execution of INSTALL CAMPAIGNS<b/>.
 * This is solely required for migration to MoEngage Platform
 *
 * @param status if it is an existing user set "update" else set "install"
 */
 MoECordova.prototype.setAppStatus = function(status) {
    console.log("setAppStatus(): status: " + status);
    var success = function(result) {
        console.log("setAppStatus : success");
    };

    var fail = function(msg) {
        console.log("setAppStatus : fail");
    };

    var appStatus = {
        "appStatus": status
    }
    exec(success, fail, 'MoEngage', 'appStatus', [appStatus]);
}


/**
 * Tracks an event.
 * @param {String} eventName event name
 * @param {String} generalAttributes JSON string of general attributes
 * @param {String} locationAttributes JSON string of one or more location attributes JSON
 * @param {String} dateTimeAttributes JSON string of  one or more dateTimeAttributes attributes 
 * @param {String} isNonInteractive if event is interactive set true else false
 */
MoECordova.prototype.trackEvent = function(eventName, generalAttributes, locationAttributes, dateTimeAttributes, isNonInteractive) {
    console.log("trackEvent() : eventName: " + eventName 
    + ",\ngeneralAttributes: " + JSON.stringify(generalAttributes) 
    + ",\nlocationAttributes: " + JSON.stringify(locationAttributes)
    + ",\ndateTimeAttribute: " + JSON.stringify(dateTimeAttributes)
    + ",\nisNonInteractive: " + isNonInteractive);

    var success = function(result) {
        console.log("trackEvent : success");
    };

    var fail = function(msg) {
        console.log("trackEvent : fail");
    };

    var trackEventObj = {};
    trackEventObj.eventName = eventName;

    var eventAttributes = {};

    if (typeof(generalAttributes) == "object") {
        eventAttributes.generalAttributes = generalAttributes;
    }
    if (typeof(locationAttributes) == "object") {
        eventAttributes.locationAttributes = locationAttributes;
    }
    if (typeof(generalAttributes) == "object") {
        eventAttributes.dateTimeAttributes = dateTimeAttributes;
    }
    
    trackEventObj.eventAttributes = eventAttributes;
    trackEventObj.isNonInteractive = typeof(isNonInteractive) == "boolean"? isNonInteractive: false;

    console.log("trackEvent() : event: " + JSON.stringify(trackEventObj));
    exec(success, fail, 'MoEngage', 'trackEvent', [trackEventObj]);
}

 /**
 * Sets the unique id of the user. Should be set on user login.
 * 
 * @param uniqueId unique id to be set
 */
MoECordova.prototype.setUniqueId = function(uniqueId) {
    console.log("setUniqueId() : uniqueId: " + uniqueId);

    if (typeof(uniqueId) == "string") {
        var success = function(result) {
            console.log("setUniqueId : success");
        };

        var fail = function(msg) {
            console.log("setUniqueId : fail");
        };

        var userAttribute = {
            "attributeName": "USER_ATTRIBUTE_UNIQUE_ID",
            "attributeValue": uniqueId,
            "type": "general"
        }
        exec(success, fail, 'MoEngage', 'setUserAttribute', [userAttribute]);
    } else {
    console.error("setUniqueId() : invalid uniqueId type.");
    }
}


/**
 * Use this method to update User Attribute Unique ID of a user
 * 
 * @param alias The updated Unique ID for the user 
 */

MoECordova.prototype.setAlias = function (alias) {
    console.log("setAlias() : alias: " + alias);
    var success = function(result) {
        console.log("setAlias() : success");
    };
  
    var fail = function(msg) {
        console.log("setAlias() : fail");
    };
  
    exec(success, fail, 'MoEngage', 'setAlias', [{"alias" : alias}]);
};
  

/**
 * Sets the user-name of the user.
 * 
 * @param userName user-name to be set
 */
MoECordova.prototype.setUserName = function(userName) {
    console.log("setUserName() : userName: " + userName);
    var success = function(result) {
        console.log("setUserName : success");
    };

    var fail = function(msg) {
        console.log("setUserName : fail");
    };

    var userAttribute = {
        "attributeName": "USER_ATTRIBUTE_USER_NAME",
        "attributeValue": userName,
        "type": "general"
    }

    exec(success, fail, 'MoEngage', 'setUserAttribute', [userAttribute]);
}

/**
 * Sets first name of the user.
 * @param firstName user-name to be set
 */
MoECordova.prototype.setFirstName = function(firstName) {
    console.log("setFirstName() : firstName: " + firstName);
    var success = function(result) {
        console.log("setFirstName : success");
    };

    var fail = function(msg) {
        console.log("setFirstName : fail");
    };

    var userAttribute = {
        "attributeName": "USER_ATTRIBUTE_USER_FIRST_NAME",
        "attributeValue": firstName,
        "type": "general"
    }

    exec(success, fail, 'MoEngage', 'setUserAttribute', [userAttribute]);
}

/**
 * Sets last name of the user.
 * 
 * @param userName user-name to be set
 */
MoECordova.prototype.setLastName = function(lastName) {
    console.log("setLastName() : lastName: " + lastName);
    var success = function(result) {
        console.log("setLastName : success");
    };

    var fail = function(msg) {
        console.log("setLastName : fail");
    };

    var userAttribute = {
        "attributeName": "USER_ATTRIBUTE_USER_LAST_NAME",
        "attributeValue": lastName,
        "type": "general"
    }

    exec(success, fail, 'MoEngage', 'setUserAttribute', [userAttribute]);
}

/**
 * Sets the email-id of the user.
 * 
 * @param emailId email-id to be set
 */
MoECordova.prototype.setEmail = function(emailId) {
    console.log("setEmail() : emailId: " + emailId);

    var success = function(result) {
        console.log("setEmail :success");
    }

    var fail = function(result) {
        console.log("setEmail : fail");
    }

    var userAttribute = {
    "attributeName": "USER_ATTRIBUTE_USER_EMAIL",
    "attributeValue": emailId,
    "type": "general"
    }

    exec(success, fail, 'MoEngage', 'setUserAttribute', [userAttribute]);
}

/**
 * Sets the mobile number of the user.
 * 
 * @param mobileNumber mobile number to be set
 */
MoECordova.prototype.setPhoneNumber = function(mobileNumber) {
    console.log("setPhoneNumber() : Phone number: " + mobileNumber);

    var success = function(result) {
        console.log("setPhoneNumber :success");
    }

    var fail = function(result) {
      console.log("setPhoneNumber : fail");
  }

  var userAttribute = {
      "attributeName": "USER_ATTRIBUTE_USER_MOBILE",
      "attributeValue": mobileNumber,
      "type": "general"
  }

  exec(success, fail, 'MoEngage', 'setUserAttribute', [userAttribute]);
}

/**
 * Sets the birthday of the user.
 * 
 * @param birthday birthday to be set in ISO format [yyyy-MM-dd'T'HH:mm:ss'Z'].
 */
MoECordova.prototype.setBirthdate = function(birthday) {
    console.log("setBirthdate() : birthday: " + birthday);

    var success = function(result) {
        console.log("setBirthdate :success");
    }

    var fail = function(result) {
      console.log("setBirthdate : fail");
  }

  var userAttribute = {
      "attributeName": "USER_ATTRIBUTE_USER_BDAY",
      "attributeValue": birthday,
      "type": "timestamp"
  }

  exec(success, fail, 'MoEngage', 'setUserAttribute', [userAttribute]);
}
  
 /**
 * Sets the gender of the user.
 * 
 * @param gender gender to be set {MALE/FEMALE/OTHER}
 */
  MoECordova.prototype.setGender = function(gender) {
    console.log("setGender() : gender: " + gender);

    var success = function(result) {
        console.log("setGender :success");
    }

    var fail = function(result) {
      console.log("setGender : fail");
  }

  var userAttribute = {
      "attributeName": "USER_ATTRIBUTE_USER_GENDER",
      "attributeValue": gender,
      "type": "general"
  }

  exec(success, fail, 'MoEngage', 'setUserAttribute', [userAttribute]);
}

/**
 * Sets the location of the user.
 *
 * @param latitude Latitude value corresponding to the location userAttribute
 * @param longitude Longitude value corresponding to the location userAttribute
 */
MoECordova.prototype.setLocation = function(latitude, longitude) {
    console.log("setLocation() : attributeLatValue: " + latitude +
     " attributeLonValue: " + longitude);
    var success = function(result) {
        console.log("setLocation : success");
    };

    var fail = function(msg) {
        console.log("setLocation : fail");
    };

    var userAttribute = {
        "attributeName": "USER_ATTRIBUTE_USER_LOCATION",
        "locationAttribute" : {
            "latitude": latitude,
            "longitude": longitude
        },
        "type": "location"
    }

    exec(success, fail, 'MoEngage', 'setUserAttribute', [userAttribute]);
}

/**
 * Set a user attribute for the current user
 *
 * @param attributeName The attribute which needs to be set
 * @param attributeValue The attribute value corresponding to the userAttribute
 */
MoECordova.prototype.setUserAttribute = function(attributeName, attributeValue) {
    console.log("inside setUserAttribute");
    var success = function(result) {
        console.log("setUserAttribute : success");
    };

    var fail = function(msg) {
        console.log("setUserAttribute : fail");
    };
    var userAttribute = {
        "attributeName": attributeName,
        "attributeValue": attributeValue,
        "type": "general"
    }

    exec(success, fail, 'MoEngage', 'setUserAttribute', [userAttribute]);
}


/**
 * Set a user attribute timestamp for the current user
 * @param attributeName The attribute which needs to be set
 * @param date The value/attribute, in ISO format [yyyy-MM-dd'T'HH:mm:ss'Z'].
 */
MoECordova.prototype.setUserAttributeISODateString = function(attributeName, date) {
    console.log("setUserAttributeISODateString() : date: " + date);
    var success = function(result) {
        console.log("setUserAttributeISODateString : success");
    };

    var fail = function(msg) {
        console.log("setUserAttributeISODateString : fail");
    };

    var userAttribute = {
        "attributeName": attributeName,
        "attributeValue": date,
        "type": "timestamp"
    }

    exec(success, fail, 'MoEngage', 'setUserAttribute', [userAttribute]);
}

/**
 * Set a user attribute location.
 *
 * @param attributeName attribute name
 * @param latitude Latitude value corresponding to the location userAttribute
 * @param longitude Longitude value corresponding to the location userAttribute
 */
MoECordova.prototype.setUserAttributeLocation = function(attributeName, latitude, longitude) {
    console.log("setUserAttributeLocation() : attributeLatValue: " + latitude +
     " attributeLonValue: " + longitude);
    var success = function(result) {
        console.log("setUserAttributeLocation : success");
    };

    var fail = function(msg) {
        console.log("setUserAttributeLocation : fail");
    };

    var userAttribute = {
        "attributeName": attributeName,
        "locationAttribute" : {
            "latitude": latitude,
            "longitude": longitude
        },
        "type": "location"
    }

    exec(success, fail, 'MoEngage', 'setUserAttribute', [userAttribute]);
}


/**
 * Notifys the SDK that the user has logged out of the app.
 */
MoECordova.prototype.logout = function() {
    console.log("logout() ");
    var success = function(result) {
        console.log("logout : success");
    };

    var fail = function(msg) {
        console.log("logout : fail");
    };
    exec(success, fail, 'MoEngage', 'logout', [{}]);
}

/**
 *  Show inApp view on the window
 */
MoECordova.prototype.showInApp = function() {
    console.log("showInApp() : ");
    var success = function(result) {
        console.log("showInApp : success");
    };

    var fail = function(msg) {
        console.log("showInApp : fail");
    };
    exec(success, fail, 'MoEngage', 'showInApp', [{}]);
}

/**
 * Call this method to get the campaign info for self handled inApps
 */
  MoECordova.prototype.getSelfHandledInApp = function() {
      console.log("getSelfHandledInApp() : ");

    var success = function(result) {
        console.log("getSelfHandledInApp : success");
    };

    var fail = function(msg) {
        console.log("getSelfHandledInApp : fail");
    };
    exec(success, fail, 'MoEngage', 'selfHandledInApp', [{}]);
  }
  

/**
 * Call this method when you show the self handled in-app so we can update impressions.
 * 
 * @param {JSON} campaignPayload received in-app payload
 */
MoECordova.prototype.selfHandledShown = function(campaignPayload) {
    console.log("selfHandledShown() : campaign payload: " + JSON.stringify(campaignPayload));

    var success = function(result) {
        console.log("selfHandledShown : success");
    };

    var fail = function(msg) {
        console.log("selfHandledShown : fail");
    };

    campaignPayload.type = "impression";
    exec(success, fail, 'MoEngage', 'selfHandledCallback', [campaignPayload]);
  }

/**
 * Call this method to track when self handled in app primary widget is clicked.
 * 
 * @param {JSON} campaignPayload received in-app payload
 */
MoECordova.prototype.selfHandledPrimaryClicked = function(campaignPayload) {
    console.log("selfHandledPrimaryClicked() : campaign payload: " + JSON.stringify(campaignPayload));

    var success = function(result) {
        console.log("selfHandledPrimaryClicked : success");
    };

    var fail = function(msg) {
        console.log("selfHandledPrimaryClicked : fail");
    };

    campaignPayload.type = "primary_clicked";
    exec(success, fail, 'MoEngage', 'selfHandledCallback', [campaignPayload]);
}

/**
 * Call this method to track when self handled in app widget(other than Primary Widget) is clicked.
 * 
 * @param {JSON} campaignPayload received in-app payload
 */
MoECordova.prototype.selfHandledClicked = function(campaignPayload) {
    console.log("selfHandledClicked() : campaign payload: " + JSON.stringify(campaignPayload));

    var success = function(result) {
        console.log("selfHandledClicked : success");
    };

    var fail = function(msg) {
        console.log("selfHandledClicked : fail");
    };
    
    campaignPayload.type = "click";
    exec(success, fail, 'MoEngage', 'selfHandledCallback', [campaignPayload]);
}
/**
 * Call this method to track dismiss actions on the inApp.
 * 
 * @param {JSON} campaignPayload received in-app payload
 */
MoECordova.prototype.selfHandledDismissed = function(campaignPayload) {
    console.log("selfHandledDismissed() :  campaign payload: " + JSON.stringify(campaignPayload));

    var success = function(result) {
        console.log("selfHandledDismissed : success");
    };

    var fail = function(msg) {
        console.log("selfHandledDismissed : fail");
    };

    campaignPayload.type = "dismissed";
    exec(success, fail, 'MoEngage', 'selfHandledCallback', [campaignPayload]);
}


 /**
 * Call this method to the current context for inApp module.
 * 
 * @param contexts : Array of all the context names
 */
MoECordova.prototype.setCurrentContext = function(contextArray) {
    console.log("setCurrentContext(): contextArray: " + contextArray);
    var success = function(result) {
        console.log("setCurrentContext : success");
    };

    var fail = function(msg) {
        console.log("setCurrentContext : fail");
    };

    var contexts = {
        "contexts": contextArray
    }
    exec(success, fail, 'MoEngage', 'appContext', [contexts]);
}

/**
 * Call this method to the reset current context for inApp module.
 */
MoECordova.prototype.resetCurrentContext = function() {
    console.log("resetCurrentContext():");
    var success = function(result) {
        console.log("resetCurrentContext : success");
    };

    var fail = function(msg) {
        console.log("resetCurrentContext : fail");
    };

    exec(success, fail, 'MoEngage', 'resetAppContext', [{}]);
}

/**
 * Optionally opt-out of data tracking. When data tracking is opted no event or user
 * attribute is tracked on MoEngage Platform.
 * 
 * @param {boolean} shouldOptOut true if you don't want to track user data, else false.
 */
MoECordova.prototype.optOutDataTracking = function(shouldOptOut) {
    console.log("optOutDataTracking() : shouldOptOut: "+ shouldOptOut);
    var success = function(result) {
        console.log("optOutDataTracking : success");
    };

    var fail = function(msg) {
        console.log("optOutDataTracking : fail");
    };

    var optOut = {
    "type": "data",
    "state": shouldOptOut
    }
    exec(success, fail, 'MoEngage', 'optOutTracking', [optOut]);
}

/**
 * Optionally opt-out of push campaigns. No push campaigns will be shown once this is opted out.
 * 
 * @param {boolean} shouldOptOut true if you don't want users to receive push notification, else false
 */
MoECordova.prototype.optOutPushNotification = function(shouldOptOut) {
    console.log("optOutPushNotification() : shouldOptOut: "+ shouldOptOut);
    var success = function(result) {
        console.log("optOutPushNotification : success");
    };

    var fail = function(msg) {
        console.log("optOutPushNotification : fail");
    };

    var optOut = {
    "type": "push",
    "state": shouldOptOut
    }
    exec(success, fail, 'MoEngage', 'optOutTracking', [optOut]);
}


/**
 * Optionally opt-out of in-app campaigns. No in-app campaigns will be shown once this is opted out.
 * 
 * @param {boolean} shouldOptOut true if you don't want users to receive in-app notification, else false
 */
MoECordova.prototype.optOutInAppNotification = function(shouldOptOut) {
    console.log("optOutInAppNotification() : shouldOptOut: "+ shouldOptOut);
    var success = function(result) {
        console.log("optOutInAppNotification : success");
    };

    var fail = function(msg) {
        console.log("optOutInAppNotification : fail");
    };

    var optOut = {
    "type": "inapp",
    "state": shouldOptOut
    }
    exec(success, fail, 'MoEngage', 'optOutTracking', [optOut]);
}

/**
 * Enables MoEngage logs.
 * Note : This API should be used only if logs are required in production/signed builds.
 */
MoECordova.prototype.enableSDKLogs = function(){
    console.log("inside enableSDKLogs");
    var success = function(result) {
        console.log("enableSDKLogs : success");
    };

    var fail = function(msg) {
        console.log("enableSDKLogs : fail");
    };
    exec(success, fail, 'MoEngage', 'enableSDKLogs', [{}]);
}

/**
 *  Register For Push Notification for iOS
 *  Note : This method is only for iOS
 */

 MoECordova.prototype.registerForPushNotification = function(){
    console.log("inside registerForPushNotification");
    var success = function(result) {
        console.log("registerForPushNotification : success");
    };

    var fail = function(msg) {
        console.log("registerForPushNotification : fail");
    };
    exec(success, fail, 'MoEngage', 'registerForPushNotification', [{}]);
}

/**
 * Passes Push Token to the MoEngage SDK
 * Note : This method is only for Android
 * 
 * @param token Push Token
 */
 MoECordova.prototype.passFcmToken = function(token) {
    console.log("passFcmToken() : token: " + token);
    var success = function(result) {
        console.log("passFcmToken : success");
    };


    var fail = function(msg) {
        console.log("passFcmToken : fail");
    };

    var pushTokenPayload = {
        "token": token,
        "service": PUSH_SERVICE_TYPE_FCM
    }
    exec(success, fail, 'MoEngage', 'passToken', [pushTokenPayload]);
}

/**
 * Passes Push payload to the MoEngage SDK
 * Note : This method is only for Android
 * 
 * @param pushPayload JSONObject of the push payload.
 */
 MoECordova.prototype.passFcmPayload = function(pushPayload) {
    console.log("passFcmPayload() : pushPayload: " + JSON.stringify(pushPayload));
    var success = function(result) {
        console.log("passFcmPayload : success");
    };


    var fail = function(msg) {
        console.log("passFcmPayload : fail");
    };

    var payload = {
        "payload": pushPayload,
        "service": PUSH_SERVICE_TYPE_FCM
    }
    exec(success, fail, 'MoEngage', 'passPayload', [payload]);
}

/**
 * Call this method to start geofenceMonitoring.
 * Note : This method is only for iOS
*/
MoECordova.prototype.startGeofenceMonitoring = function() {
    console.log("geofenceMonitoring():");
    var success = function(result) {
        console.log("geofenceMonitoring : success");
    };

    var fail = function(msg) {
        console.log("geofenceMonitoring : fail");
    };

    exec(success, fail, 'MoEngage', 'startGeofenceMonitoring', [{}]);
}

/**
  Enable  SDK
*/
MoECordova.prototype.enableSdk = function() {
    console.log("enableSdk(): true");
    var success = function(result) {
        console.log("enableSdk : success");
    };

    var fail = function(msg) {
        console.log("enableSdk : fail");
    };

    var sdkState = {
    "isSdkEnabled": true
    }
    exec(success, fail, 'MoEngage', 'updateSDKState', [sdkState]);
}

/**
    Disable  SDK
 */
MoECordova.prototype.disableSdk = function() {
    console.log("disableSdk(): false");
    var success = function(result) {
        console.log("disableSdk : success");
    };

    var fail = function(msg) {
        console.log("disableSdk : fail");
    };

    var sdkState = {
        "isSdkEnabled": false
    }
    exec(success, fail, 'MoEngage', 'updateSDKState', [sdkState]);
}

MoECordova.prototype.emit = function() {
    var args = Array.prototype.slice.call(arguments);
    var eventName = args.shift();

    if (!this._handlers.hasOwnProperty(eventName)) {
        return false;
    }

    for (var i = 0, length = this._handlers[eventName].length; i < length; i++) {
        var callback = this._handlers[eventName][i];
        if (typeof callback === 'function') {
            callback.apply(undefined,args);
        } else {
            console.log('event handler: ' + eventName + ' must be a function');
        }
    }

    return true;
};

MoECordova.prototype.on = function(eventName, callback) {
    if (!this._handlers.hasOwnProperty(eventName)) {
        this._handlers[eventName] = [];
    }
    this._handlers[eventName].push(callback);
};

module.exports = {

    init: function() {
        return new MoECordova();
    },

    MoECordova: MoECordova
}

/* Constants */
const PUSH_SERVICE_TYPE_FCM = "FCM";