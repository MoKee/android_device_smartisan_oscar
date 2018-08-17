LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := librecovery_updater_oscar
LOCAL_MODULE_TAGS := eng

LOCAL_C_INCLUDES := $(call project-path-for,recovery)

LOCAL_SRC_FILES := recovery_updater.cpp

include $(BUILD_STATIC_LIBRARY)
