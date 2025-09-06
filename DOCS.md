# Home Assistant Add-on: Coturn TURN/STUN Server

A TURN/STUN server for WebRTC and VoIP NAT traversal, based on the Coturn project.

## Installation

1. Navigate to **Settings** → **Add-ons** → **Add-on Store** in your Home Assistant frontend.
2. Add this repository if not already added.
3. Install the "Coturn TURN/STUN Server" add-on.
4. Configure the add-on (see configuration options below).
5. Start the add-on.

## Configuration

Add-on configuration:

```yaml
listening_port: 3478
tls_listening_port: 5349
min_port: 49152
max_port: 65535
realm: "homeassistant.local"
use_auth_secret: true
static_auth_secret: "your-secret-here"
username: ""
password: ""
cert_file: ""
pkey_file: ""
log_level: 3
verbose: false
fingerprint: false
use_stun_server: true
use_turn_server: true
deny_peer_ip: []
allowed_peer_ip: []
external_ip: ""
```

### Configuration Options

#### Network Settings

- **listening_port**: Primary STUN/TURN port (default: 3478)
- **tls_listening_port**: TLS/DTLS port (default: 5349)
- **min_port/max_port**: Media relay port range (default: 49152-65535)
- **external_ip**: External IP for NAT traversal (auto-detected if empty)

#### Authentication

Choose one of these authentication methods:

**Method 1: Static Auth Secret (Recommended)**
```yaml
use_auth_secret: true
static_auth_secret: "your-long-random-secret"
```

**Method 2: Username/Password**
```yaml
use_auth_secret: false
username: "turnuser"
password: "turnpassword"
```

#### TLS/SSL Configuration

For secure connections:
```yaml
cert_file: "fullchain.pem"
pkey_file: "privkey.pem"
```

Place certificate files in the `/ssl/` Home Assistant directory.

#### Security Settings

- **fingerprint**: Enable STUN fingerprint (recommended: false for compatibility)
- **deny_peer_ip**: Block specific IP ranges
- **allowed_peer_ip**: Allow only specific IP ranges

#### Server Features

- **use_stun_server**: Enable STUN functionality (recommended: true)
- **use_turn_server**: Enable TURN functionality (recommended: true)

#### Logging

- **log_level**: Verbosity level 1-7 (3 is recommended)
- **verbose**: Enable detailed logging (useful for debugging)

## Usage Examples

### WebRTC Application Configuration

For applications using the auth secret method:

```javascript
// Calculate credentials using TURN REST API
const username = Math.floor(Date.now() / 1000) + 3600; // expire in 1 hour
const secret = "your-static-auth-secret";
const credential = btoa(hmacSHA1(username, secret));

const iceServers = [
  { urls: "stun:your-ha-ip:3478" },
  { 
    urls: "turn:your-ha-ip:3478",
    username: username,
    credential: credential
  }
];
```

### Simple Configuration for Testing

Minimal setup for testing (not secure for production):

```yaml
listening_port: 3478
realm: "test.local"
use_auth_secret: false
username: "test"
password: "test123"
```

### Production Configuration

Secure setup for production use:

```yaml
listening_port: 3478
tls_listening_port: 5349
realm: "yourdomain.com"
use_auth_secret: true
static_auth_secret: "generate-a-long-random-secret-here"
cert_file: "fullchain.pem"
pkey_file: "privkey.pem"
external_ip: "your.external.ip.address"
fingerprint: false
log_level: 2
verbose: false
```

## Network Requirements

### Firewall Configuration

Open these ports on your firewall:

- **3478/UDP**: STUN/TURN primary port
- **3478/TCP**: STUN/TURN primary port  
- **5349/UDP**: STUN/TURN over TLS/DTLS
- **5349/TCP**: STUN/TURN over TLS/DTLS
- **49152-65535/UDP**: Media relay ports (configurable range)

### NAT/Router Configuration

If running behind NAT, forward these ports to your Home Assistant machine:

```
External Port → Internal Port
3478/UDP     → 3478/UDP
3478/TCP     → 3478/TCP
5349/UDP     → 5349/UDP
5349/TCP     → 5349/TCP
49152-65535/UDP → 49152-65535/UDP
```

## Troubleshooting

### Connection Issues

1. **Check firewall**: Ensure required ports are open
2. **Verify NAT configuration**: Ports must be forwarded correctly
3. **Test connectivity**: Use online STUN/TURN testers
4. **Check external IP**: Verify the configured external IP is correct

### Authentication Problems

1. **Auth secret method**: Ensure credentials are calculated correctly
2. **Username/password**: Verify credentials match configuration
3. **Check logs**: Enable verbose logging for detailed auth information

### Certificate Issues

1. **File location**: Certificates must be in `/ssl/` directory
2. **File permissions**: Ensure files are readable
3. **Certificate validity**: Check certificate expiration and chain

### Performance Optimization

1. **Port range**: Adjust min/max ports based on concurrent connection needs
2. **Log level**: Reduce logging in production for better performance
3. **Resource limits**: Monitor CPU and memory usage

### Common Error Messages

**"Authentication failed"**
- Check username/password or auth secret configuration
- Verify client-side credential calculation

**"Certificate not found"**
- Ensure certificate files exist in `/ssl/` directory
- Check file names in configuration

**"Port already in use"**
- Another service is using the configured ports
- Change ports or stop conflicting services

## Advanced Configuration

### IP Restrictions

Block specific networks:
```yaml
deny_peer_ip:
  - "192.168.1.0/24"
  - "10.0.0.0/8"
```

Allow only specific networks:
```yaml
allowed_peer_ip:
  - "203.0.113.0/24"
  - "198.51.100.0/24"
```

### Multiple Realms

For complex setups, you may need multiple TURN servers with different realms.

## Support

- **Documentation**: [Coturn Project](https://github.com/coturn/coturn)
- **Issues**: [GitHub Issues](https://github.com/MichalTorma/ha-coturn/issues)
- **Community**: Home Assistant Community Forums
