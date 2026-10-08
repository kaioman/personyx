#!/usr/bin/env bash

set -u

VPN_NAME="badcompany2-IKEv2-tls"
LOG_TAG="vpn-reconnect"
MAX_ATTEMPTS=4
INITIAL_DELAY=5
NMCLI_TIMEOUT=15
TARGET_MTU=1370
TARGET_SUBNET="10.0.0.0/24"

delay="$INITIAL_DELAY"

for ((attempt = 1; attempt <= MAX_ATTEMPTS; attempt++)); do
    if nmcli --wait "$NMCLI_TIMEOUT" connection up id "$VPN_NAME"; then
        logger -t "$LOG_TAG" "VPN connected: $VPN_NAME (attempt $attempt/$MAX_ATTEMPTS)"

        IFACE=$(ip -o link show | grep -oE 'nm-xfrm-[0-9a-zA-Z]+' | head -n 1 || true)

        if [[ -n "${IFACE:-}" ]]; then
            if ip link set dev "$IFACE" mtu "$TARGET_MTU"; then
                logger -t "$LOG_TAG" "Successfully set MTU=$TARGET_MTU on interface $IFACE"
            else
                logger -t "$LOG_TAG" "Failed to set MTU=$TARGET_MTU on interface $IFACE"
            fi

            if ip route replace "$TARGET_SUBNET" dev "$IFACE"; then
                logger -t "$LOG_TAG" "Successfully added route $TARGET_SUBNET via $IFACE"
            fi
        else
            logger -t "$LOG_TAG" "Warning: Could not detect interface name for $VPN_NAME to set MTU"
        fi

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
