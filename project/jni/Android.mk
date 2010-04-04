LOCAL_PATH := $(call my-dir)
DUMMY := $(shell cd $(LOCAL_PATH); make -f libperl.mk >&2)

include $(CLEAR_VARS)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/libperl/perl-5.10.0
LOCAL_LDLIBS     := -llog -ldl
LOCAL_MODULE     := PerlDroid
LOCAL_SRC_FILES  := libPerlDroid.c JNIHelp.c

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE     := perl

LOCAL_BUILT_MODULE := $(call shared-library-path,$(LOCAL_MODULE))
LOCAL_MAKEFILE     := $(local-makefile)

include $(BUILD_SYSTEM)/build-binary.mk

$(LOCAL_BUILT_MODULE): $(LOCAL_OBJECTS)
	@ mkdir -p $(dir $@)
	@ echo "SharedLibrary  : $(PRIVATE_NAME)"
	@ cp $(LOCAL_PATH)/libperl/perl-5.10.0/libperl.so out/apps/perldroid/armeabi/

ALL_SHARED_LIBRARIES += $(LOCAL_BUILT_MODULE)

include $(BUILD_SYSTEM)/install-binary.mk

include $(CLEAR_VARS)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/libperl/perl-5.10.0
LOCAL_LDLIBS     := -L$(LOCAL_PATH)/../libs/armeabi -ldl -lperl -lPerlDroid
LOCAL_MODULE     := PerlDroid_so
LOCAL_SRC_FILES  := PerlDroid.c

$(LOCAL_PATH)/PerlDroid.c: $(LOCAL_PATH)/PerlDroid.xs
	xsubpp -prototypes -output $(LOCAL_PATH)/PerlDroid.c $(LOCAL_PATH)/PerlDroid.xs

include $(BUILD_SHARED_LIBRARY)
