# Architecture

## Network plan

| Role | Interface/address |
|---|---|
| VPS public interface | `eth0` |
| WireGuard interface | `wg0` |
| VPN server | `10.8.0.1/24` |
| Windows peer | `10.8.0.2/32` |
| Android peer | `10.8.0.3/32` |
| VPN subnet | `10.8.0.0/24` |
| WireGuard UDP port | `51820` |

## Packet flow

1. A client establishes an encrypted WireGuard session with the VPS over UDP 51820.
2. The decrypted packet enters `wg0`.
3. IPv4 forwarding permits traffic from `10.8.0.0/24` to leave through `eth0`.
4. The UFW routed rule permits this forwarding path.
5. The NAT POSTROUTING MASQUERADE rule translates the VPN source address to the VPS egress address.
6. Return traffic is tracked and routed back to the originating VPN peer.

## Trust boundaries

- SSH administration is separate from VPN client traffic.
- UFW allows inbound SSH and WireGuard only.
- Forwarding is scoped to `wg0` -> `eth0` and the VPN subnet.
- Each device has its own WireGuard key pair and `/32` address.
