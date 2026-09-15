#!/usr/bin/env bash

set -u

VPN_NAME="badcompany2-IKEv2-tls"
RECONNECT_SCRIPT="/usr/local/sbin/reconnect-vpn.sh"
LOG_TAG="vpn-monitor"

if nmcli -g NAME connection show --active | grep -Fxq "$VPN_NAME"; then
    logger -t "$LOG_TAG" "VPN is connected: $VPN_NAME"
    exit 0
fi

logger -t "$LOG_TAG" "VPN is disconnected: $VPN_NAME. Reconnecting."
"$RECONNECT_SCRIPT"
