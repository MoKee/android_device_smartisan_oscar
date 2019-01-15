/*
 * Copyright (C) 2019 The MoKee Open Source Project
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

#include <android-base/file.h>
#include <android-base/logging.h>
#include <android-base/strings.h>

#include "KeyDisabler.h"

namespace vendor {
namespace mokee {
namespace touch {
namespace V1_0 {
namespace implementation {

constexpr const char kGoodixControlPath[] = "/sys/devices/soc/soc:goodix_fp/key_disabled";
constexpr const char kBettterlifeControlPath[] = "/sys/devices/soc/soc:betterlife_fp/key_disabled";

KeyDisabler::KeyDisabler() {
    mHasKeyDisabler = !access(kGoodixControlPath, F_OK) && !access(kBettterlifeControlPath, F_OK);
}

// Methods from ::vendor::mokee::touch::V1_0::IKeyDisabler follow.
Return<bool> KeyDisabler::isEnabled() {
    std::string buf1, buf2;

    if (!mHasKeyDisabler) return false;

    if (!android::base::ReadFileToString(kGoodixControlPath, &buf1, true)) {
        LOG(ERROR) << "Failed to read " << kGoodixControlPath;
        return false;
    }

    if (!android::base::ReadFileToString(kBettterlifeControlPath, &buf2, true)) {
        LOG(ERROR) << "Failed to read " << kBettterlifeControlPath;
        return false;
    }

    return std::stoi(android::base::Trim(buf1)) == 0 && std::stoi(android::base::Trim(buf2)) == 0;
}

Return<bool> KeyDisabler::setEnabled(bool enabled) {
    std::string value = (enabled ? "1" : "0");

    if (!mHasKeyDisabler) return false;

    if (!android::base::WriteStringToFile(value, kGoodixControlPath, true)) {
        LOG(ERROR) << "Failed to write " << kGoodixControlPath;
        return false;
    }

    if (!android::base::WriteStringToFile(value, kBettterlifeControlPath, true)) {
        LOG(ERROR) << "Failed to write " << kBettterlifeControlPath;
        return false;
    }

    return true;
}

}  // namespace implementation
}  // namespace V1_0
}  // namespace touch
}  // namespace mokee
}  // namespace vendor
