package com.moengage.cordova;

import android.content.Context;
import android.content.Intent;
import com.moengage.core.internal.logger.Logger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.moengage.plugin.base.PluginHelper;

/**
 * This class echoes a string called from JavaScript.
 */
public class MoECordova extends CordovaPlugin {

  private static final String TAG = MoEConstants.MODULE_TAG + "Plugin";

  private static final String ACTION_PASS_TOKEN = "passToken";
  private static final String ACTION_PASS_PAYLOAD = "passPayload";
  private static final String ACTION_SET_APP_STATUS = "appStatus";
  private static final String ACTION_SET_USER_ATTRIBUTE = "setUserAttribute";
  private static final String ACTION_TRACK_EVENT = "trackEvent";
  private static final String ACTION_USER_LOGOUT = "logout";
  private static final String ACTION_ENABLE_SDK_LOGS = "enableSDKLogs";
  private static final String ACTION_ENABLE_DATA_REDIRECTION = "enableDataRedirection";
  private static final String ACTION_INIT = "init";
  private static final String ACTION_SET_ALIAS = "setAlias";
  private static final String ACTION_INAPP = "showInApp";
  private static final String ACTION_SELF_HANDLE_INAPP = "selfHandledInApp";
  private static final String ACTION_SELF_HANDLE_CALLBACK = "selfHandledCallback";
  private static final String ACTION_SET_APP_CONTEXT = "appContext";
  private static final String ACTION_RESET_APP_CONTEXT = "resetAppContext";
  private static final String ACTION_OPT_OUT = "optOutTracking";
  private static final String ACTION_UPDATE_SDK_STATE = "updateSDKState";

  private static CallbackContext nativeCallbackContext;
  private static CordovaWebView cordovaWebView;
  private boolean isPluginHelperInitialised = false;
  private static List<JSONObject> cachedExtras = Collections.synchronizedList(new ArrayList<JSONObject>());

  private final PluginHelper pluginHelper = new PluginHelper();

  @Override public boolean execute(String action, JSONArray args, CallbackContext callbackContext)
      throws JSONException {
    Context context = getApplicationContext();
    JSONObject payload = args.getJSONObject(0);
    Logger.v(TAG + " execute() : action: " + action + ", payload : " + payload.toString());
    switch (action) {
      case ACTION_INIT:
        nativeCallbackContext = callbackContext;
        pluginHelper.initialize();
        isPluginHelperInitialised = true;
        flushNativeEvents();
        break;

      case ACTION_ENABLE_SDK_LOGS:
        pluginHelper.enableSDKLogs();
        callbackContext.success("success");
        break;

      case ACTION_TRACK_EVENT:
        pluginHelper.trackEvent(context, payload);
        callbackContext.success("success");
        break;

      case ACTION_SET_USER_ATTRIBUTE:
        pluginHelper.setUserAttribute(context, payload);
        callbackContext.success("success");
        break;

      case ACTION_USER_LOGOUT:
        pluginHelper.logout(context);
        callbackContext.success("success");
        break;

      case ACTION_INAPP:
        pluginHelper.showInApp(context);
        callbackContext.success("success");
        break;

      case ACTION_SELF_HANDLE_INAPP:
        pluginHelper.getSelfHandledInApp(context);
        callbackContext.success("success");
        break;

      case ACTION_SELF_HANDLE_CALLBACK:
        pluginHelper.selfHandledCallback(context, payload);
        callbackContext.success("success");
        break;


      case ACTION_PASS_TOKEN:
        pluginHelper.passPushToken(context, payload);
        callbackContext.success("success");
        break;

      case ACTION_PASS_PAYLOAD:
        pluginHelper.passPushPayload(context, payload);
        callbackContext.success("success");
        break;

      case ACTION_SET_ALIAS:
        pluginHelper.setAlias(context, payload);
        callbackContext.success("success");
        break;

      case ACTION_SET_APP_STATUS:
        pluginHelper.setAppStatus(context, payload);
        callbackContext.success("success");
        break;

      case ACTION_SET_APP_CONTEXT:
        pluginHelper.setAppContext(context, payload);
        callbackContext.success("success");
        break;

      case ACTION_RESET_APP_CONTEXT:
        pluginHelper.resetAppContext(context);
        callbackContext.success("success");
        break;

      case ACTION_OPT_OUT:
        pluginHelper.optOutTracking(context, payload);
        callbackContext.success("success");
        break;

      case ACTION_ENABLE_DATA_REDIRECTION:
        boolean shouldRedirectData = payload.getBoolean("set_redirect");
        // moeHelper.setDataRedirection(shouldRedirectData);
        callbackContext.success("success");
        break;

        case ACTION_UPDATE_SDK_STATE:
        pluginHelper.storeFeatureStatus(context, payload);
        callbackContext.success("success");

      default:
        callbackContext.error("fail");
    }
    return true;
  }

  /**
   * Called after plugin construction and fields have been initialized.
   */
  @Override protected void pluginInitialize() {
    Logger.v(TAG + " pluginInitialize() : ");
    pluginHelper.setEventCallback(new EventEmitterImpl());
    flushNativeEvents();
  }

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
    Logger.v(TAG + " initialize() : ");
    cordovaWebView = this.webView;
  }

  @Override
  public void onPause(boolean multitasking) {
    super.onPause(multitasking);
    Logger.v(TAG + " onPause() : ");
  }

  @Override
  public void onResume(boolean multitasking) {
    super.onResume(multitasking);
    Logger.v(TAG + " onResume() : ");
  }

  /**
   * Called when the activity is becoming visible to the user.
   */
  public void onStart() {
    super.onStart();
    Logger.v(TAG + " onStart() : ");
  }

  /**
   * Called when the activity is no longer visible to the user.
   */
  public void onStop() {
    super.onStop();
    Logger.v(TAG + " onStop() : ");
  }

  @Override
  public void onDestroy() {
    super.onDestroy();
    Logger.v(TAG + " onDestroy() : ");
    cordovaWebView = null;
  }

  @Override
  public void onNewIntent(Intent intent) {
    Logger.v(TAG + "onNewIntent() ");
  }

  private Context getApplicationContext() {
    return this.cordova.getActivity().getApplicationContext();
  }

  public static void sendEvent(JSONObject _json) {
    try {
      if (_json != null) {
        Logger.v(TAG + " sendEvent() : " + _json.toString());

        String noCache = "0";

        if (_json.has("no-cache"))
          _json.getString("no-cache");

        if (cordovaWebView != null) {
          PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, _json);
          pluginResult.setKeepCallback(true);
          if (nativeCallbackContext != null) {
            Logger.v(TAG + " sendEvent() : Sending Event" + _json.toString());
            nativeCallbackContext.sendPluginResult(pluginResult);
          }
        } else if(!"1".equals(noCache)){
          Logger.v(TAG + " sendEvent() : webview is null, adding event to cache");
          cachedExtras.add(_json);
        }
      }
    } catch(Exception e) {
      Logger.e(TAG + " sendEvent() : Exception: ", e);
    }
  }

  private void flushNativeEvents() {
    Logger.v(TAG + " flushNativeEvents() : ");
    if (cordovaWebView != null && isPluginHelperInitialised && !cachedExtras.isEmpty()) {
      synchronized(cachedExtras) {
        Iterator<JSONObject> iterator = cachedExtras.iterator();
        while (iterator.hasNext()) {
          sendEvent(iterator.next());
        }
      }
      cachedExtras.clear();
    }
  }
}
