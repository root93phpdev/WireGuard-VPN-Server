# Client setup

## General rules

- Generate a unique key pair for every device.
- Keep each private key on that device.
- Add only the client's public key to the server peer configuration.
- Assign a unique VPN address (`/32`) to each peer.
- Never share a real client configuration in chat, email, issue trackers, or a public repository.

## Android

1. Install the official WireGuard application.
2. Generate a tunnel/key pair in the app, or securely provision a generated client configuration.
3. Use [`../config/client-android.conf.example`](../config/client-android.conf.example) as a template.
4. Import the `.conf` file using the app's file import option.
5. Activate the tunnel and test over mobile data.
6. Verify the public IPv4 address and server-side handshake.

The tested lab Android peer used `10.8.0.3/32`.

## Windows

1. Install the official WireGuard for Windows client.
2. Create a tunnel and generate its key pair.
3. Use [`../config/client-windows.conf.example`](../config/client-windows.conf.example) as a template.
4. Register the Windows public key on the server.
5. Activate the tunnel and verify the connection.

The tested lab Windows peer used `10.8.0.2/32`.

## Full-tunnel IPv4 settings

The client template uses:

```ini
AllowedIPs = 0.0.0.0/0
```

This routes IPv4 traffic through the VPN. This deployment does not configure IPv6 tunneling; do not assume IPv6 traffic is protected by this IPv4-only setup.
