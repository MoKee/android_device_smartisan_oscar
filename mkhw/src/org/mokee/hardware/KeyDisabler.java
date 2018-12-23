/*
 * Copyright (C) 2014 The CyanogenMod Project
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

package org.mokee.hardware;

import org.mokee.internal.util.FileUtils;

/*
 * Disable capacitive keys
 *
 * This is intended for use on devices in which the capacitive keys
 * can be fully disabled for replacement with a soft navbar. You
 * really should not be using this on a device with mechanical or
 * otherwise visible-when-inactive keys
 */

public class KeyDisabler {

    private static final String FILE_GOODIX =
            "/sys/devices/soc/soc:goodix_fp/key_disabled";

    private static final String FILE_BETTERLIFE =
            "/sys/devices/soc/soc:betterlife_fp/key_disabled";

    /*
     * All HAF classes should export this boolean.
     * Real implementations must, of course, return true
     */

    public static boolean isSupported() {
        return FileUtils.isFileWritable(FILE_GOODIX) &&
                FileUtils.isFileWritable(FILE_BETTERLIFE);
    }

    /*
     * Are the keys currently blocked?
     */

    public static boolean isActive() {
        return !FileUtils.readOneLine(FILE_GOODIX).equals("0") &&
                !FileUtils.readOneLine(FILE_BETTERLIFE).equals("0");
    }

    /*
     * Disable capacitive keys
     */

    public static boolean setActive(boolean state) {
        final String value = state ? "1" : "0";
        return FileUtils.writeLine(FILE_GOODIX, value) &&
                FileUtils.writeLine(FILE_BETTERLIFE, value);
    }

}
