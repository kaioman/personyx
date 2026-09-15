#!/usr/bin/env bash

set -u

VPN_NAME="badcompany2-IKEv2-tls"
LOG_TAG="vpn-reconnect"
MAX_ATTEMPTS=4
INITIAL_DELAY=5
NMCLI_TIMEOUT=15

delay="$INITIAL_DELAY"

for ((attempt = 1; attempt <= MAX_ATTEMPTS; attempt++)); do
    if nmcli --wait "$NMCLI_TIMEOUT" connection up id "$VPN_NAME"; then
        logger -t "$LOG_TAG" "VPN connected: $VPN_NAME (attempt $attempt/$MAX_ATTEMPTS)"
        exit 0
    fi

    if ((attempt < MAX_ATTEMPTS)); then
        logger -t "$LOG_TAG" "VPN reconnect failed: $VPN_NAME (attempt $attempt/$MAX_ATTEMPTS), retrying in ${delay}s"
        sleep "$delay"
        delay=$((delay * 2))
    fi
done

logger -t "$LOG_TAG" "VPN connection failed after $MAX_ATTEMPTS attempts: $VPN_NAME"
exit 1
