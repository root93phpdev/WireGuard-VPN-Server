# Security policy

## Never publish

- WireGuard server private key.
- Any client private key.
- Real client configuration files.
- `/etc/wireguard/wg0.conf` from a live server.
- QR codes generated from real client configurations.
- Backup archives containing keys or live configuration.
- SSH private keys, passwords, API tokens, or recovery codes.

## Before every commit

```bash
git status --short
git diff --cached
git ls-files
```

Search tracked files for likely secrets:

```bash
git grep -n -E 'PrivateKey[[:space:]]*=|BEGIN OPENSSH PRIVATE KEY|BEGIN PRIVATE KEY' -- ':!*.example'
```

This is a basic review, not a complete secret scanner.

## If a secret is exposed

1. Treat the key as compromised.
2. Remove/revoke the affected peer on the server.
3. Generate a new key pair on the client.
4. Register the new public key.
5. Replace the client configuration.
6. Review Git history. Deleting a file in a later commit does not remove it from earlier commits.
7. If the server private key is exposed, rotate the server key and update every client peer configuration.

## File permissions on the server

- `/etc/wireguard`: `0700`, owned by root.
- Server private key and live WireGuard config: `0600`, owned by root.
- Client configuration containing a private key: protect as a secret; use restrictive permissions and transfer securely.
