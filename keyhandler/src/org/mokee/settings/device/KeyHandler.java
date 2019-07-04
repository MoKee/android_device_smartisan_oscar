/*
 * Copyright (C) 2018-2019 The MoKee Open Source Project
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

package org.mokee.settings.device;

import android.content.Context;
import android.hardware.input.InputManager;
import android.os.SystemClock;
import android.util.Log;
import android.view.InputDevice;
import android.view.KeyCharacterMap;
import android.view.KeyEvent;
import android.view.ViewConfiguration;

import com.android.internal.os.DeviceKeyHandler;

import org.mokee.internal.util.FileUtils;

public class KeyHandler implements DeviceKeyHandler {

    private static final String TAG = "KeyHandler";

    private static final int KEY_HOME_TOUCH_BETTERLIFE = 0;
    private static final int KEY_HOME_TOUCH_GF3206 = 1;

    private final KeyInfo[] keys = new KeyInfo[] {
        new KeyInfo("home_touch", "betterlife-blfp"),
        new KeyInfo("home_touch", "gf3206"),
    };

    private final int doubleTapTimeout = ViewConfiguration.getDoubleTapTimeout();

    private long lastTouchMillis = 0;

    public KeyHandler(Context context) {
    }

    public KeyEvent handleKeyEvent(KeyEvent event) {
        boolean handled = false;
        handled = handleHomeTouchKeyEvent(event) || handled;
        return handled ? null : event;
    }

    private boolean handleHomeTouchKeyEvent(KeyEvent event) {
        // The sensor reports fake DOWN and UP per taps
        if (event.getAction() != KeyEvent.ACTION_UP) {
            return false;
        }

        KeyInfo matchedKey;

        if (keys[KEY_HOME_TOUCH_BETTERLIFE].match(event)) {
            matchedKey = keys[KEY_HOME_TOUCH_BETTERLIFE];
        } else if (keys[KEY_HOME_TOUCH_GF3206].match(event)) {
            matchedKey = keys[KEY_HOME_TOUCH_GF3206];
        } else {
            return false;
        }

        final long now = SystemClock.uptimeMillis();
        if (now - lastTouchMillis < doubleTapTimeout) {
            injectKey(KeyEvent.KEYCODE_APP_SWITCH);
        } else {
            injectKey(matchedKey.keyCode);
        }

        lastTouchMillis = now;
        return true;
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

    private class KeyInfo {

        final String deviceName;
        final int scanCode;
        int deviceId;
        int keyCode;

        KeyInfo(String file, String deviceName) {
            int scanCode;
            this.deviceName = deviceName;
            try {
                scanCode = Integer.parseInt(FileUtils.readOneLine(
                        "/proc/keypad/" + file));
            } catch (NumberFormatException ignored) {
                scanCode = 0;
            }
            this.scanCode = scanCode;
        }

        boolean match(KeyEvent event) {
            if (deviceId == 0) {
                final String deviceName = getDeviceName(event);
                if (this.deviceName.equals(deviceName)) {
                    deviceId = event.getDeviceId();
                } else {
                    return false;
                }
            } else {
                if (deviceId != event.getDeviceId()) {
                    return false;
                }
            }

            if (event.getScanCode() == scanCode) {
                keyCode = event.getKeyCode();
            } else {
                return false;
            }

            return true;
        }

    }

}
