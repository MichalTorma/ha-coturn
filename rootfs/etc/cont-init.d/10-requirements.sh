#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Coturn
# This files check if all user configuration requirements are met
# ==============================================================================

bashio::log.info "Checking add-on requirements..."

# Check if authentication method is configured
USE_AUTH_SECRET=$(bashio::config 'use_auth_secret')
STATIC_AUTH_SECRET=$(bashio::config 'static_auth_secret')
USERNAME=$(bashio::config 'username')
PASSWORD=$(bashio::config 'password')

if bashio::var.true "${USE_AUTH_SECRET}"; then
    if bashio::var.is_empty "${STATIC_AUTH_SECRET}"; then
        bashio::exit.nok "When using auth secret, 'static_auth_secret' must be configured!"
    fi
    bashio::log.info "Using static auth secret for authentication"
else
    if bashio::var.is_empty "${USERNAME}" || bashio::var.is_empty "${PASSWORD}"; then
        bashio::log.warning "No authentication configured. Coturn will run without authentication."
        bashio::log.warning "This is NOT recommended for production use!"
    else
        bashio::log.info "Using username/password authentication"
    fi
fi

# Check TLS configuration
CERT_FILE=$(bashio::config 'cert_file')
PKEY_FILE=$(bashio::config 'pkey_file')

if bashio::var.has_value "${CERT_FILE}" && bashio::var.has_value "${PKEY_FILE}"; then
    if [[ ! -f "/ssl/${CERT_FILE}" ]]; then
        bashio::exit.nok "Certificate file '/ssl/${CERT_FILE}' not found!"
    fi
    if [[ ! -f "/ssl/${PKEY_FILE}" ]]; then
        bashio::exit.nok "Private key file '/ssl/${PKEY_FILE}' not found!"
    fi
    bashio::log.info "TLS/DTLS will be enabled"
else
    bashio::log.warning "No TLS certificates configured. TLS/DTLS will be disabled."
fi

# Check port configuration
MIN_PORT=$(bashio::config 'min_port')
MAX_PORT=$(bashio::config 'max_port')

if (( MIN_PORT >= MAX_PORT )); then
    bashio::exit.nok "min_port must be less than max_port!"
fi

if (( MIN_PORT < 1024 )); then
    bashio::log.warning "min_port is below 1024. This may require additional privileges."
fi

bashio::log.info "Add-on requirements check completed successfully!"
