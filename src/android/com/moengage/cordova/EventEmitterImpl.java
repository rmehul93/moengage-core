/*
 * Copyright (c) 2014-2021 MoEngage Inc.
 *
 * All rights reserved.
 *
 *  Use of source code or binaries contained within MoEngage SDK is permitted only to enable use of the MoEngage platform by customers of MoEngage.
 *  Modification of source code and inclusion in mobile apps is explicitly allowed provided that all other conditions are met.
 *  Neither the name of MoEngage nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 *  Redistribution of source code or binaries is disallowed except with specific prior written permission. Any such redistribution must retain the above copyright notice, this list of conditions and the following disclaimer.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.moengage.cordova;

import com.moengage.core.internal.logger.Logger;
import com.moengage.plugin.base.EventEmitter;
import com.moengage.plugin.base.model.Event;
import com.moengage.plugin.base.model.EventType;
import com.moengage.plugin.base.model.InAppEvent;
import com.moengage.plugin.base.model.PushEvent;
import com.moengage.cordova.MoEConstants;
import com.moengage.plugin.base.model.TokenEvent;
import org.json.JSONObject;
import java.util.EnumMap;
import com.moengage.cordova.MoEConstants;
import com.moengage.plugin.base.UtilsKt;

public class EventEmitterImpl implements EventEmitter {

  private static final String TAG = MoEConstants.MODULE_TAG+ "EventEmitterImpl";

  @Override public void emit(Event event) {
    try {
      Logger.v(TAG + " emit() : " + event);
      if (event instanceof InAppEvent) {
        this.emitInAppEvent((InAppEvent)event);
      } else if (event instanceof PushEvent) {
        this.emitPushEvent((PushEvent)event);
      } else if (event instanceof TokenEvent) {
        this.emitPushTokenEvent((TokenEvent)event);
      }
    } catch(Exception e) {
      Logger.e(TAG + " emit() : Exception: ", e);
    }
  }

  private void emitInAppEvent(InAppEvent inAppEvent) {
    try {
      Logger.v(TAG + " emitInAppEvent() : " + inAppEvent);
      String eventType = eventMap.get(inAppEvent.getEventType());
      if (eventType == null) return;
      JSONObject campaign = UtilsKt.inAppCampaignToJson(inAppEvent.getInAppCampaign());
      campaign.put(MoEConstants.KEY_TYPE, eventType);
      emit(campaign);
    } catch (Exception e) {
      Logger.e(TAG + " emitInAppEvent() : Exception: ", e);
    }
  }

  private void emitPushEvent(PushEvent pushEvent) {
    try {
      Logger.v(TAG + " emitPushEvent() : " + pushEvent);
      String eventType = eventMap.get(pushEvent.getEventType());
      if (eventType == null) return;
      JSONObject payload = UtilsKt.pushPayloadToJson(pushEvent.getPayload());
      payload.put(MoEConstants.KEY_TYPE, eventType);
      emit(payload);
    } catch (Exception e) {
      Logger.e(TAG + " emitPushEvent() : Exception: ", e);
    }
  }

  private void emitPushTokenEvent(TokenEvent tokenEvent) {
    try {
      Logger.v(TAG + " emitPushTokenEvent() : " + tokenEvent);
      String eventType = eventMap.get(tokenEvent.getEventType());
      if (eventType == null) return;
      JSONObject payload = UtilsKt.pushTokenToJson(tokenEvent.getPushToken());
      payload.put(MoEConstants.KEY_TYPE, eventType);
      emit(payload);
    } catch (Exception e) {
      Logger.e(TAG + " emitPushTokenEvent() : Exception: ", e);
    }
  }

  private void emit(JSONObject payload) {
    try {
      MoECordova.sendEvent(payload);
    } catch(Exception e) {
      Logger.e(TAG + " emit() : ", e);
    }
  }

  private static EnumMap<EventType, String> eventMap = new EnumMap<>(EventType.class);

  static {
    eventMap.put(EventType.PUSH_CLICKED, "MoEPushClicked");
    eventMap.put(EventType.INAPP_SHOWN,  "MoEInAppCampaignShown");
    eventMap.put(EventType.INAPP_NAVIGATION, "MoEInAppCampaignClicked");
    eventMap.put(EventType.INAPP_CLOSED, "MoEInAppCampaignDismissed");
    eventMap.put(EventType.INAPP_CUSTOM_ACTION, "MoEInAppCampaignCustomAction");
    eventMap.put(EventType.INAPP_SELF_HANDLED_AVAILABLE, "MoEInAppCampaignSelfHandled");
    eventMap.put(EventType.PUSH_TOKEN_GENERATED, "MoEPushTokenGenerated");
  }

}
