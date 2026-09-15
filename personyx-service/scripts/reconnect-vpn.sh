#!/usr/bin/env bash

set -u

VPN_NAME="badcompany2-IKEv2-tls"
LOG_TAG="vpn-reconnect"

if nmcli connection up id "$VPN_NAME"; then
    logger -t "$LOG_TAG" "VPN connected: $VPN_NAME"
    exit 0
fi

logger -t "$LOG_TAG" "VPN connection failed: $VPN_NAME"
exit 1
