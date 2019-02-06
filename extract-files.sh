#!/bin/bash
#
# Copyright (C) 2018 The MoKee Open Source Project
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

set -e

export DEVICE=oscar
export DEVICE_COMMON=msm8953-common
export VENDOR=smartisan

export DEVICE_BRINGUP_YEAR=2018

./../../$VENDOR/$DEVICE_COMMON/extract-files.sh $@

MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi
MK_ROOT="$MY_DIR"/../../..

BLOB_ROOT="$MK_ROOT"/vendor/"$VENDOR"/"$DEVICE"/proprietary

# Audio
sed -i 's|/system/etc/|/vendor/etc/|g' $BLOB_ROOT/vendor/lib/hw/audio.primary.msm8953.so
sed -i 's|/system/etc/|/vendor/etc/|g' $BLOB_ROOT/vendor/lib64/hw/audio.primary.msm8953.so
sed -i 's|/system/lib/|/vendor/lib/|g' $BLOB_ROOT/vendor/lib/hw/audio.primary.msm8953.so
sed -i 's|/system/lib/|/vendor/lib/|g' $BLOB_ROOT/vendor/lib64/hw/audio.primary.msm8953.so

# Camera
sed -i 's|/system/etc/|/vendor/etc/|g' $BLOB_ROOT/vendor/lib/libmmcamera2_sensor_modules.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/bin/mm-qcamera-daemon
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera2_cpp_module.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera2_dcrf.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera2_iface_modules.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera2_imglib_modules.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera2_mct.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera2_pproc_modules.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera2_q3a_core.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera2_sensor_modules.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera2_stats_algorithm.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera2_stats_modules.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera_dbg.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera_imglib.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera_pdaf.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera_pdafcamif.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera_tintless_algo.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera_tintless_bg_pca_algo.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmmcamera_tuning.so
sed -i 's|/data/misc/camera|/data/vendor/qcam|g' $BLOB_ROOT/vendor/lib/libmms_hal_vstab.so
