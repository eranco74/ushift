#!/bin/bash

RHCOS_IMAGE="/tmp/fiot-pods.img"
VM_NAME="aio-test"
OS_VARIANT="fedora33"
#OS_VARIANT="rhel8.1"
RAM_MB="4096"
DISK_GB="20"

virt-install \
    --connect qemu:///system \
    -n "${VM_NAME}" \
    -r "${RAM_MB}" \
    --os-variant="${OS_VARIANT}" \
    --import \
    --network=network:test-net,mac=52:54:00:ee:42:e5 \
    --graphics=none \
    --disk "size=${DISK_GB},backing_store=${RHCOS_IMAGE}" \
#    --qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${IGNITION_CONFIG}"
