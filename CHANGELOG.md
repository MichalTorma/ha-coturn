# Changelog

All notable changes to this add-on will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-01-XX

### Added

- Initial release of Coturn TURN/STUN Server add-on
- Support for all major architectures (amd64, aarch64, armv7, armhf, i386)
- STUN/TURN server functionality based on Coturn 4.7.0
- Multiple authentication methods (static auth secret, username/password)
- TLS/DTLS support with SSL certificates
- Configurable port ranges for media relay
- Comprehensive logging with adjustable verbosity
- IP filtering (allow/deny lists)
- WebRTC compatibility
- Home Assistant add-on best practices implementation
- Detailed documentation and configuration examples

### Security

- Secure default configuration
- Support for TLS/DTLS encryption
- Authentication required by default
- IP filtering capabilities
