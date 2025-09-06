# Home Assistant Add-on: Coturn TURN/STUN Server

A Home Assistant add-on that provides a Coturn TURN/STUN server for WebRTC and VoIP NAT traversal.

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

## About

Coturn is a free open source implementation of TURN and STUN Server. The TURN Server is a VoIP media traffic NAT traversal server and gateway. This add-on provides an easy way to run Coturn within your Home Assistant environment.

### Features

- **STUN/TURN Server**: Full RFC-compliant STUN and TURN server implementation
- **WebRTC Support**: Enable WebRTC applications to work behind NAT/firewalls
- **Multiple Authentication Methods**: Support for static auth secrets or username/password
- **TLS/DTLS Support**: Secure connections with SSL certificates
- **Configurable Port Ranges**: Flexible media relay port configuration
- **Comprehensive Logging**: Adjustable logging levels for debugging

## Installation

1. Navigate in your Home Assistant frontend to **Settings** → **Add-ons** → **Add-on Store**.
2. Add this repository by clicking the menu in the top-right and selecting **Repositories**.
3. Add the URL: `https://github.com/MichalTorma/ha-repository`
4. Find the "Coturn TURN/STUN Server" add-on and click it.
5. Click on the "INSTALL" button.

## How to use

1. Start the add-on.
2. Configure the add-on according to your needs (see Configuration section).
3. Configure your WebRTC applications to use the TURN server.

### Basic Configuration

The minimal configuration requires setting up authentication:

```yaml
realm: "homeassistant.local"
use_auth_secret: true
static_auth_secret: "your-secret-key-here"
```

### Advanced Configuration

For production use with TLS support:

```yaml
realm: "your-domain.com"
use_auth_secret: true
static_auth_secret: "your-secret-key-here"
cert_file: "fullchain.pem"
pkey_file: "privkey.pem"
external_ip: "your.external.ip.address"
```

## Configuration

### Option: `listening_port` (required)

The primary port for STUN/TURN protocol (both UDP and TCP).

### Option: `tls_listening_port` (required)

The port for STUN/TURN over TLS/DTLS protocol. Requires SSL certificates.

### Option: `min_port` / `max_port` (required)

Port range for media relay. These ports must be opened in your firewall and forwarded if behind NAT.

### Option: `realm` (required)

The TURN server realm, typically your domain name.

### Option: `use_auth_secret` (required)

Enable static authentication secret method (recommended) instead of username/password.

### Option: `static_auth_secret`

Static secret for authentication. Required when `use_auth_secret` is true.

### Option: `username` / `password`

Username and password for authentication. Used when `use_auth_secret` is false.

### Option: `cert_file` / `pkey_file`

SSL certificate and private key files from the `/ssl/` directory for TLS/DTLS support.

### Option: `external_ip`

Your external IP address for NAT traversal. If not set, Coturn will try to auto-detect.

### Option: `log_level`

Logging verbosity level (1-7, where 1 is minimal and 7 is maximum).

### Option: `verbose`

Enable verbose logging output for debugging.

### Option: `fingerprint`

Enable STUN fingerprint security feature.

### Option: `use_stun_server` / `use_turn_server`

Enable or disable STUN and TURN server functionality.

### Option: `deny_peer_ip` / `allowed_peer_ip`

Lists of IP addresses or ranges to deny or allow peer connections from.

## Network Configuration

### Ports

The following ports need to be accessible:

- `3478` (UDP/TCP): STUN/TURN
- `5349` (UDP/TCP): STUN/TURN over TLS/DTLS
- `49152-65535` (UDP): Media relay ports (configurable range)

### Firewall

Ensure these ports are open in your firewall and properly forwarded if behind NAT.

## WebRTC Configuration

To use this TURN server with WebRTC applications, configure them with:

```javascript
{
  iceServers: [
    {
      urls: ["stun:your-ha-ip:3478"],
    },
    {
      urls: ["turn:your-ha-ip:3478"],
      username: "calculated-username", // For auth secret method
      credential: "calculated-credential" // For auth secret method
    }
  ]
}
```

For static auth secret, the username should be a timestamp and the credential should be calculated using HMAC-SHA1.

## Troubleshooting

### Common Issues

1. **Connection failures**: Check firewall settings and port forwarding
2. **Authentication errors**: Verify auth secret or username/password configuration
3. **TLS errors**: Ensure certificate files are correctly placed in `/ssl/` directory

### Logs

Check the add-on logs for detailed error messages. Enable verbose logging for more detailed output.

## Support

For issues and feature requests, please use the [GitHub repository](https://github.com/MichalTorma/ha-coturn).

## License

MIT License - see [LICENSE](LICENSE) file for details.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg