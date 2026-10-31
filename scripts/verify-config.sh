#!/usr/bin/env bash
set -euo pipefail

cfg="${1:?usage: verify-config.sh <path-to-.config>}"

fail=0

require_y() {
    local opt
    for opt in "$@"; do
        if ! grep -qx "CONFIG_${opt}=y" "$cfg"; then
            echo "ERROR: CONFIG_${opt} is not enabled" >&2
            fail=1
        fi
    done
}

require_not_y() {
    local opt
    for opt in "$@"; do
        if grep -qx "CONFIG_${opt}=y" "$cfg"; then
            echo "ERROR: CONFIG_${opt} must stay disabled for kABI safety" >&2
            fail=1
        fi
    done
}

# BakaSU
require_y KSU KSU_TRACEPOINT_HOOK
require_not_y KSU_MANUAL_HOOK KSU_SUSFS

# Droidspaces (GKI requirements)
require_y \
    SYSVIPC POSIX_MQUEUE NAMESPACES PID_NS UTS_NS IPC_NS USER_NS NET_NS \
    SECCOMP SECCOMP_FILTER CGROUPS MEMCG CGROUP_SCHED CGROUP_FREEZER \
    CGROUP_CPUACCT CGROUP_NET_PRIO DEVTMPFS OVERLAY_FS TMPFS_POSIX_ACL \
    TMPFS_XATTR BLK_DEV_LOOP EXT4_FS FUSE_FS TUN MACVLAN \
    NETFILTER_XT_MATCH_ADDRTYPE NETFILTER_XT_TARGET_LOG \
    NETFILTER_XT_MATCH_RECENT IP_SET IP_SET_HASH_IP IP_SET_HASH_NET \
    NETFILTER_XT_SET IP6_NF_NAT IP6_NF_TARGET_MASQUERADE

# GKI / kABI invariants
require_y KALLSYMS_ALL MODVERSIONS MODULE_SIG_PROTECT
require_not_y CFS_BANDWIDTH CGROUP_PIDS

# Tracepoint hook prerequisites
require_y TRACEPOINTS HAVE_SYSCALL_TRACEPOINTS FTRACE

if [ "$fail" -ne 0 ]; then
    echo "Config verification failed: $cfg" >&2
    exit 1
fi

echo "Config verification passed: $cfg"
