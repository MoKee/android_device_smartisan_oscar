#
# Copyright (C) 2018-2019 The MoKee Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

$(call inherit-product, vendor/smartisan/oscar/oscar-vendor.mk)

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    $(LOCAL_PATH)/overlay-mokee

# Boot animation
TARGET_SCREEN_HEIGHT := 2160
TARGET_SCREEN_WIDTH := 1080

# Audio
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/audio,$(TARGET_COPY_OUT_VENDOR)/etc)

# Camera
PRODUCT_PACKAGES += \
    camera.msm8953 \
    libmm-qcamera

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/camera/camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/camera/camera_config.xml

PRODUCT_PACKAGES += \
    libshim_camera

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.0-service.oscar

# Init
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/init/vendor,$(TARGET_COPY_OUT_VENDOR))

# Input
PRODUCT_PACKAGES += \
    KeyHandlerOscar

# IRQ
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

# Inherit from msm8953-common
$(call inherit-product, device/smartisan/msm8953-common/common.mk)
