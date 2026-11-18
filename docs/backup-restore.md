# Backup and restore

## What to back up

A secure backup may include:

- `/etc/wireguard/` (contains highly sensitive private keys and live peer configuration).
- `/etc/ufw/`.
- `/etc/default/ufw`.
- `/etc/sysctl.d/99-wireguard.conf`.

## Create a protected archive

```bash
sudo install -d -o root -g root -m 700 /root/vpn-backup
sudo tar -czf /root/vpn-backup/wireguard-$(date +%F).tar.gz -C / etc/wireguard
sudo chmod 600 /root/vpn-backup/wireguard-$(date +%F).tar.gz
```

Create separate archives for firewall and sysctl configuration as appropriate.

## Backup handling

- A backup containing WireGuard private keys is equivalent to possession of those keys.
- Do not upload unencrypted backups to GitHub, cloud drives, or public file-sharing services.
- Prefer encrypted off-server backups and periodically test restoration.
- Keep at least one recovery path for SSH before changing firewall rules.

## Restore overview

1. Rebuild or prepare a compatible Ubuntu host.
2. Restore files with root ownership and restrictive permissions.
3. Verify the external interface, route, and firewall configuration.
4. Validate WireGuard configuration and peer assignments.
5. Enable/start `wg-quick@wg0`.
6. Test from a client and verify handshake and traffic.
