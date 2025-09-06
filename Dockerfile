ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Build arguments
ARG BUILD_ARCH
ARG COTURN_VERSION=4.7.0

# Install Coturn and runtime dependencies
RUN \
    apk add --no-cache \
        ca-certificates \
        tzdata \
        coturn \
        jq \
        curl \
        openssl

# Create coturn user and directories
RUN \
    addgroup -g 3478 coturn \
    && adduser -D -s /bin/bash -u 3478 -G coturn coturn \
    && mkdir -p /var/lib/coturn \
    && mkdir -p /etc/coturn \
    && mkdir -p /var/log/coturn

# Set permissions
RUN \
    chown -R coturn:coturn /var/lib/coturn \
    && chown -R coturn:coturn /etc/coturn \
    && chown -R coturn:coturn /var/log/coturn \
    && chmod -R g+w /var/lib/coturn \
    && chmod -R g+w /etc/coturn \
    && chmod -R g+w /var/log/coturn

# Copy rootfs
COPY rootfs /

# Build arguments for labels
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Michal Torma <torma.michal@gmail.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Michal Torma <torma.michal@gmail.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/MichalTorma/ha-coturn" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

# Expose ports
EXPOSE 3478 3478/udp 5349 5349/udp

# Set working directory
WORKDIR /etc/coturn

# Health check - check if coturn is responding on the STUN port
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD timeout 5 bash -c "</dev/tcp/localhost/3478" || exit 1
