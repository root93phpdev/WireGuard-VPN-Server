# WireGuard VPN Server

A documented, IPv4-only WireGuard VPN deployment on an Ubuntu VPS, with firewall hardening, NAT, systemd startup, and Windows/Android clients.

This repository documents a real personal infrastructure lab and provides sanitized examples for repeatable setup. It intentionally contains **no live private keys, production configuration files, client credentials, or backup archives**.

## Project overview

| Component | Configuration |
|---|---|
| OS | Ubuntu 26.04.1 LTS |
| Virtualization | KVM VPS |
| VPN | WireGuard |
| VPN interface | `wg0` |
| VPN network | `10.8.0.0/24` |
| Server VPN address | `10.8.0.1/24` |
| WireGuard transport | UDP `51820` |
| External interface | `eth0` |
| Firewall | UFW |
| NAT | iptables MASQUERADE |
| Service management | systemd (`wg-quick@wg0`) |
| Tested clients | Windows, Android |
| Routing scope | IPv4 full tunnel |

## Features

- WireGuard server with a separate key pair and VPN address for each device.
- IPv4 forwarding and NAT for VPN clients.
- UFW inbound and routed-traffic rules.
- SSH hardening: key-based authentication, root login disabled, password authentication disabled.
- systemd service enabled for startup after reboot.
- Windows and Android client configuration examples.
- Read-only diagnostic script.
- Backup and restore guidance.
- Secret-safe repository structure and `.gitignore`.

## Architecture

```text
                    Internet
                       |
                UDP 51820 / SSH 22
                       |
                +--------------+
                | Ubuntu VPS   |
                |              |
                | WireGuard wg0|
                | 10.8.0.1/24  |
                | UFW + NAT    |
                +------+-------+
                       |
                 IPv4 forwarding
                       |
                     eth0
                       |
                    Internet

       +---------------+---------------+
       |                               |
+--------------+                +--------------+
| Windows      |                | Android      |
| 10.8.0.2/32  |                | 10.8.0.3/32  |
+--------------+                +--------------+
```

## Repository layout

```text
tgops-wireguard-vpn/
├── README.md
├── README.ru.md
├── SECURITY.md
├── .gitignore
├── config/
│   ├── wg0.conf.example
│   ├── client-android.conf.example
│   └── client-windows.conf.example
├── docs/
│   ├── architecture.md
│   ├── deployment.md
│   ├── clients.md
│   └── backup-restore.md
└── scripts/
    └── check_server.sh
```

## Quick start

1. Read [`docs/deployment.md`](docs/deployment.md).
2. Install WireGuard and configure the server using [`config/wg0.conf.example`](config/wg0.conf.example) as a reference.
3. Configure IPv4 forwarding, NAT, and UFW as described in the deployment guide.
4. Generate a unique key pair for every client. Never reuse a private key.
5. Register each client's **public** key on the server.
6. Create a client configuration from the relevant example.
7. Import the client configuration into WireGuard.
8. Run the read-only diagnostic script:

```bash
sudo bash scripts/check_server.sh
```

The example files contain placeholders. They are not ready to use until reviewed and populated with your own values.

## Validation performed in the lab

- Successful WireGuard handshakes from Windows and Android.
- VPN reachability to the server VPN address (`10.8.0.1`).
- IPv4 public IP verification through the VPS.
- DNS resolution through `1.1.1.1`.
- Peer traffic counters and handshake timestamps.
- Service startup and client reconnection after VPS reboot.

## Security

- Do not commit `/etc/wireguard/wg0.conf`.
- Do not commit any real client `.conf` file.
- Do not commit private keys, QR codes containing real client configurations, or backup archives.
- Keep `/etc/wireguard` restricted to root (`0700` directory; private files `0600`).
- Use one key pair per device.
- If a client private key is exposed, revoke that peer and generate a replacement.
- Review [`SECURITY.md`](SECURITY.md) before publishing.

## Limitations

- IPv4-only full-tunnel routing; IPv6 tunneling is intentionally out of scope in this deployment.
- Single VPS, with no high availability or automatic failover.
- This is a personal infrastructure/DevOps lab, not a managed commercial VPN service.

## Resume bullet

> Deployed and secured a WireGuard VPN server on Ubuntu VPS; configured SSH key-only access, UFW firewall policies, IPv4 forwarding and NAT, systemd auto-start, and Windows/Android clients. Validated VPN handshakes, DNS, public IPv4 egress, and recovery after server reboot.

## License

No license has been selected. Until a license is added, assume that the repository is provided for viewing and that reuse is not automatically permitted.
