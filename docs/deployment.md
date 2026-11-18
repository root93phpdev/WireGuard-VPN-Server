# Deployment guide

This guide describes the deployment approach used in the lab. Review every command for your provider, interface names, and Ubuntu version before applying it.

## 1. Prepare the VPS

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y wireguard wireguard-tools ufw qrencode curl
```

Confirm the external interface and default route:

```bash
ip -brief address
ip route
```

The lab used `eth0`; your provider may use another interface name.

## 2. Prepare WireGuard directory and server keys

```bash
sudo install -d -o root -g root -m 700 /etc/wireguard
umask 077
wg genkey | sudo tee /etc/wireguard/server_private.key >/dev/null
sudo sh -c 'wg pubkey < /etc/wireguard/server_private.key > /etc/wireguard/server_public.key'
sudo chmod 600 /etc/wireguard/server_private.key
sudo chmod 644 /etc/wireguard/server_public.key
```

Never print or publish the private key. Generate client key pairs independently for each device.

## 3. Configure the server

Use [`../config/wg0.conf.example`](../config/wg0.conf.example) as a reference. Create `/etc/wireguard/wg0.conf` with your actual server private key and each client's public key.

Secure it:

```bash
sudo chown root:root /etc/wireguard/wg0.conf
sudo chmod 600 /etc/wireguard/wg0.conf
```

## 4. Enable IPv4 forwarding

Create `/etc/sysctl.d/99-wireguard.conf`:

```ini
net.ipv4.ip_forward=1
```

Apply and verify:

```bash
sudo sysctl --system
sysctl net.ipv4.ip_forward
```

Expected value: `1`.

## 5. Configure NAT

Add a NAT section before the `*filter` section in `/etc/ufw/before.rules`, adapting the VPN subnet and external interface:

```iptables
*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
COMMIT
```

Do not add a second conflicting NAT table section if one already exists. Back up the file before editing.

## 6. Configure UFW

Allow only required inbound services, retaining your actual SSH port:

```bash
sudo ufw allow 22/tcp
sudo ufw allow 51820/udp
sudo ufw route allow in on wg0 out on eth0 from 10.8.0.0/24 to any
```

In this lab, `/etc/default/ufw` used:

```ini
DEFAULT_FORWARD_POLICY="DROP"
```

The explicit UFW route rule permits the intended forwarding path. Do not blindly replace the default policy with `ACCEPT`.

Before enabling or reloading UFW, confirm that SSH access and firewall rules are correct:

```bash
sudo ufw status verbose
sudo ufw reload
```

## 7. Start WireGuard

```bash
sudo systemctl enable --now wg-quick@wg0
sudo systemctl status wg-quick@wg0 --no-pager
sudo wg show
```

`wg-quick@wg0` may show `active (exited)`; this is expected for this oneshot-style service when the interface is configured.

## 8. Validate

```bash
ip -brief address show wg0
sudo wg show
sudo ufw status verbose
sudo iptables -t nat -L POSTROUTING -n -v
```

Connect a client and verify its handshake, traffic counters, DNS resolution, and public IPv4 egress.

> The live VPS was configured and tested separately. This repository intentionally does not include its actual configuration or credentials.
