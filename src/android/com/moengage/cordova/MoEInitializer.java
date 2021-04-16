package com.moengage.cordova;

import android.content.Context;
import com.moengage.core.MoEngage;
import com.moengage.core.internal.logger.Logger;
import com.moengage.core.internal.model.IntegrationMeta;
import com.moengage.plugin.base.PluginInitializer;
import com.moengage.cordova.MoEConstants;

public class MoEInitializer {

  private static final String TAG = MoEConstants.MODULE_TAG + "MoEInitializer";

  public static void initialize(Context context, MoEngage.Builder builder) {
    try {
      Logger.v(TAG + " initialize() : Will try to initialize the sdk.");
      initialize(
          context,
          builder,
          true
      );
    } catch (Exception e) {
      Logger.e(TAG + " initialize() : Exception: ", e);
    }
  }

  public static void initialize(Context context, MoEngage.Builder builder, boolean isSdkEnabled) {
    try {
      Logger.v(TAG + " initialize() : Initialising MoEngage SDK.");
      PluginInitializer.INSTANCE.initialize(context, builder,
          (new IntegrationMeta(MoEConstants.INTEGRATION_TYPE, MoEConstants.CORDOVA_PLUGIN_VERSION)),
          isSdkEnabled);
      Logger.v(TAG + " initialize() : Initialising MoEngage SDK.");
    } catch (Exception e) {
      Logger.e( TAG + " initialize() : ", e);
    }
  }
}