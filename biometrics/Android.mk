LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.biometrics.fingerprint@2.1-service.oscar
LOCAL_INIT_RC := android.hardware.biometrics.fingerprint@2.1-service.oscar.rc
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_SRC_FILES := \
    BiometricsFingerprint.cpp \
    service.cpp

LOCAL_SHARED_LIBRARIES := \
    libbinder \
    libutils \
    libcutils \
    liblog \
    libhidlbase \
    libhardware \
    android.hardware.biometrics.fingerprint@2.1

LOCAL_CFLAGS := -DSMARTISAN_HACK

include $(BUILD_EXECUTABLE)
