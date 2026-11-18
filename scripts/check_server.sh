#!/usr/bin/env bash
# Read-only WireGuard/UFW diagnostic helper.
set -u

section() {
  printf '\n===== %s =====\n' "$1"
}

section "SYSTEM"
date -Is
. /etc/os-release 2>/dev/null && printf 'OS: %s\n' "${PRETTY_NAME:-unknown}"
uname -r

section "NETWORK"
ip -brief address
ip route

section "WIREGUARD SERVICE"
systemctl is-enabled wg-quick@wg0 2>/dev/null || true
systemctl is-active wg-quick@wg0 2>/dev/null || true

section "WIREGUARD STATUS"
if command -v wg >/dev/null 2>&1; then
  sudo wg show
else
  echo "wg command not found"
fi

section "IPV4 FORWARDING"
sysctl net.ipv4.ip_forward 2>/dev/null || true

section "UFW"
sudo ufw status verbose 2>/dev/null || true

section "NAT POSTROUTING"
sudo iptables -t nat -L POSTROUTING -n -v 2>/dev/null || true

section "LISTENING UDP PORT"
sudo ss -lunp 2>/dev/null | grep -E '(:51820[[:space:]]|:51820$)' || true

printf '\nDiagnostic complete. This script does not modify system configuration.\n'
