LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.biometrics.fingerprint@2.0-service.oscar
LOCAL_INIT_RC := android.hardware.biometrics.fingerprint@2.0-service.oscar.rc
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_SRC_FILES := \
    fingerprintd/FingerprintDaemonCallbackProxy.cpp \
    fingerprintd/FingerprintDaemonProxy.cpp \
    fingerprintd/IFingerprintDaemonCallback.cpp \
    fingerprintd/IFingerprintDaemon.cpp \
    fingerprintd/wrapper.cpp \
    BiometricsFingerprint.cpp \
    service.cpp

LOCAL_SHARED_LIBRARIES := \
    libbinder \
    libutils \
    liblog \
    libhidlbase \
    libhidltransport \
    libhardware \
    libhwbinder \
    libkeystore_binder \
    android.hardware.biometrics.fingerprint@2.1

include $(BUILD_EXECUTABLE)
