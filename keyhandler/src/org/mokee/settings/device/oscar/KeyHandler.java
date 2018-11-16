/*
 * Copyright (C) 2018 The MoKee Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.mokee.settings.device.oscar;

import android.content.Context;
import android.hardware.input.InputManager;
import android.os.SystemClock;
import android.util.Log;
import android.view.InputDevice;
import android.view.KeyCharacterMap;
import android.view.KeyEvent;
import android.view.ViewConfiguration;

import com.android.internal.os.DeviceKeyHandler;

public class KeyHandler implements DeviceKeyHandler {

    private static final String TAG = "KeyHandler";

    private static final String DEVICE_BETTERLIFE = "betterlife-blfp";

    private final int doubleTapTimeout = ViewConfiguration.getDoubleTapTimeout();

    private int trustedDeviceId = 0;

    private long lastTapMillis = 0;

    public KeyHandler(Context context) {
    }

    public KeyEvent handleKeyEvent(KeyEvent event) {
        // The sensor reports fake DOWN and UP per taps
        if (event.getScanCode() != 158 || event.getAction() != KeyEvent.ACTION_UP) {
            return event;
        }

        if (trustedDeviceId == 0) {
            if (DEVICE_BETTERLIFE.equals(getDeviceName(event))) {
                trustedDeviceId = event.getDeviceId();
            } else {
                return event;
            }
        } else {
            if (trustedDeviceId != event.getDeviceId()) {
                return event;
            }
        }

        final long now = SystemClock.uptimeMillis();
        if (now - lastTapMillis < doubleTapTimeout) {
            injectKey(KeyEvent.KEYCODE_APP_SWITCH);
        } else {
            injectKey(KeyEvent.KEYCODE_BACK);
        }

        lastTapMillis = now;
        return null;
    }

    private String getDeviceName(KeyEvent event) {
        final int deviceId = event.getDeviceId();
        final InputDevice device = InputDevice.getDevice(deviceId);
        return device == null ? null : device.getName();
    }

    private void injectKey(int code) {
        injectKey(code, KeyEvent.ACTION_DOWN, 0);
        injectKey(code, KeyEvent.ACTION_UP, 0);
    }

    private void injectKey(int code, int action, int flags) {
        final long now = SystemClock.uptimeMillis();
        InputManager.getInstance().injectInputEvent(new KeyEvent(
                        now, now, action, code, 0, 0,
                        KeyCharacterMap.VIRTUAL_KEYBOARD,
                        0, flags,
                        InputDevice.SOURCE_KEYBOARD),
                InputManager.INJECT_INPUT_EVENT_MODE_ASYNC);
    }

}
