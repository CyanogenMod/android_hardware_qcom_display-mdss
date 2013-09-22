#Common headers
common_includes := hardware/qcom/display-mdss/libgralloc
common_includes += hardware/qcom/display-mdss/liboverlay
common_includes += hardware/qcom/display-mdss/libcopybit
common_includes += hardware/qcom/display-mdss/libqdutils
common_includes += hardware/qcom/display-mdss/libhwcomposer
common_includes += hardware/qcom/display-mdss/libexternal
common_includes += hardware/qcom/display-mdss/libqservice

ifeq ($(TARGET_USES_POST_PROCESSING),true)
    common_flags     += -DUSES_POST_PROCESSING
    common_includes += $(TARGET_OUT_HEADERS)/pp/inc
endif

#Common libraries external to display HAL
common_libs := liblog libutils libcutils libhardware

ifeq ($(TARGET_USES_POST_PROCESSING),true)
    common_libs += libmm-abl
endif

#Common C flags
common_flags := -DDEBUG_CALC_FPS -Wno-missing-field-initializers
common_flags += -Werror

ifeq ($(ARCH_ARM_HAVE_NEON),true)
    common_flags += -D__ARM_HAVE_NEON
endif

ifeq ($(call is-board-platform-in-list, msm8974 msm8226 msm8610), true)
    common_flags += -DVENUS_COLOR_FORMAT
    common_flags += -DMDSS_TARGET
endif

common_deps  :=
kernel_includes :=

# Executed only on QCOM BSPs
ifeq ($(TARGET_USES_QCOM_BSP),true)
# Enable QCOM Display features
    common_flags += -DQCOM_BSP
endif
ifeq ($(call is-vendor-board-platform,QCOM),true)
# This check is to pick the kernel headers from the right location.
# If the macro above is defined, we make the assumption that we have the kernel
# available in the build tree.
# If the macro is not present, the headers are picked from hardware/qcom/msmXXXX
# failing which, they are picked from bionic.
    common_deps += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
    kernel_includes += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
endif
