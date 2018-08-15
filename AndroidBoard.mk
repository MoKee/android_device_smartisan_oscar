LOCAL_PATH := $(call my-dir)

TARGET_PREBUILT_KERNEL_INCLUDE := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
$(TARGET_PREBUILT_KERNEL_INCLUDE):
	mkdir -p $@
	cp -rf device/smartisan/oscar/prebuilt/include $@/

$(INSTALLED_KERNEL_TARGET): $(TARGET_PREBUILT_KERNEL) | $(ACP) $(TARGET_PREBUILT_KERNEL_INCLUDE)
	$(transform-prebuilt-to-target)
